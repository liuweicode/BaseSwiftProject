//
//  NSProtocolInterceptor.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/8.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation

// 参考 http://stackoverflow.com/questions/3498158/intercept-objective-c-delegate-messages-within-a-subclass
/**
 `NSProtocolInterceptor` is a proxy which intercepts messages to the middle man
 which originally intended to send to the receiver.
 
 - Discussion: `NSProtocolInterceptor` is a class cluster which dynamically
 subclasses itself to conform to the intercepted protocols at the runtime.
 */
public final class NSProtocolInterceptor: NSObject {
    
    /// Returns the intercepted protocols
    public var interceptedProtocols: [Protocol] { return _interceptedProtocols }
    fileprivate var _interceptedProtocols: [Protocol] = []
    
    /// The receiver receives messages
    public weak var receiver: NSObjectProtocol?
    
    /// The middle man intercepts messages
    public weak var middleMan: NSObjectProtocol?
    
    fileprivate func doesSelectorBelongToAnyInterceptedProtocol(
        _ aSelector: Selector) -> Bool
    {
        for aProtocol in _interceptedProtocols
            where sel_belongsToProtocol(aSelector, aProtocol)
        {
            return true
        }
        return false
    }
    
    /// Returns the object to which unrecognized messages should first be
    /// directed.
    public override func forwardingTarget(for aSelector: Selector)
        -> Any?
    {
        if middleMan?.responds(to: aSelector) == true &&
            doesSelectorBelongToAnyInterceptedProtocol(aSelector)
        {
            return middleMan
        }
        
        if receiver?.responds(to: aSelector) == true {
            return receiver
        }
        
        return super.forwardingTarget(for: aSelector)
    }
    
    /// Returns a Boolean value that indicates whether the receiver implements
    /// or inherits a method that can respond to a specified message.
    public override func responds(to aSelector: Selector) -> Bool {
        if middleMan?.responds(to: aSelector) == true &&
            doesSelectorBelongToAnyInterceptedProtocol(aSelector)
        {
            return true
        }
        
        if receiver?.responds(to: aSelector) == true {
            return true
        }
        
        return super.responds(to: aSelector)
    }
    
    /**
     Create a protocol interceptor which intercepts a single Objecitve-C
     protocol.
     
     - Parameter     protocols:  An Objective-C protocol, such as
     UITableViewDelegate.self.
     */
    public class func forProtocol(_ aProtocol: Protocol)
        -> NSProtocolInterceptor
    {
        return forProtocols([aProtocol])
    }
    
    /**
     Create a protocol interceptor which intercepts a variable-length sort of
     Objecitve-C protocols.
     
     - Parameter     protocols:  A variable length sort of Objective-C protocol,
     such as UITableViewDelegate.self.
     */
    public class func forProtocols(_ protocols: Protocol ...)
        -> NSProtocolInterceptor
    {
        return forProtocols(protocols)
    }
    
    /**
     Create a protocol interceptor which intercepts an array of Objecitve-C
     protocols.
     
     - Parameter     protocols:  An array of Objective-C protocols, such as
     [UITableViewDelegate.self].
     */
    public class func forProtocols(_ protocols: [Protocol])
        -> NSProtocolInterceptor
    {
        let protocolNames = protocols.map { NSStringFromProtocol($0) }
        let sortedProtocolNames = protocolNames.sorted()
        let concatenatedName = sortedProtocolNames.joined(separator: ",")
        
        let theConcreteClass = concreteClassWithProtocols(protocols,
                                                          concatenatedName: concatenatedName,
                                                          salt: nil)
        
        let protocolInterceptor = theConcreteClass.init()
            as! NSProtocolInterceptor
        protocolInterceptor._interceptedProtocols = protocols
        
        return protocolInterceptor
    }
    
    /**
     Return a subclass of `NSProtocolInterceptor` which conforms to specified
     protocols.
     
     - Parameter     protocols:          An array of Objective-C protocols. The
     subclass returned from this function will conform to these protocols.
     
     - Parameter     concatenatedName:   A string which came from concatenating
     names of `protocols`.
     
     - Parameter     salt:               A UInt number appended to the class name
     which used for distinguishing the class name itself from the duplicated.
     
     - Discussion: The return value type of this function can only be
     `NSObject.Type`, because if you return with `NSProtocolInterceptor.Type`,
     you can only init the returned class to be a `NSProtocolInterceptor` but not
     its subclass.
     */
    fileprivate class func concreteClassWithProtocols(_ protocols: [Protocol],
                                                  concatenatedName: String,
                                                  salt: UInt?)
        -> NSObject.Type
    {
        let className: String = {
            let basicClassName = "_" +
                NSStringFromClass(NSProtocolInterceptor.self) +
                "_" + concatenatedName
            
            if let salt = salt { return basicClassName + "_\(salt)" }
            else { return basicClassName }
        }()
        
        let nextSalt = salt.map {$0 + 1}
        
        if let theClass = NSClassFromString(className) {
            switch theClass {
            case let anInterceptorClass as NSProtocolInterceptor.Type:
                let isClassConformsToAllProtocols: Bool = {
                    // Check if the found class conforms to the protocols
                    for eachProtocol in protocols
                        where !class_conformsToProtocol(anInterceptorClass,
                                                        eachProtocol)
                    {
                        return false
                    }
                    return true
                }()
                
                if isClassConformsToAllProtocols {
                    return anInterceptorClass
                } else {
                    return concreteClassWithProtocols(protocols,
                                                      concatenatedName: concatenatedName,
                                                      salt: nextSalt)
                }
            default:
                return concreteClassWithProtocols(protocols,
                                                  concatenatedName: concatenatedName,
                                                  salt: nextSalt)
            }
        } else {
            let subclass = objc_allocateClassPair(NSProtocolInterceptor.self,
                                                  className,
                                                  0)
                as! NSObject.Type
            
            for eachProtocol in protocols {
                class_addProtocol(subclass, eachProtocol)
            }
            
            objc_registerClassPair(subclass)
            
            return subclass
        }
    }
}

/**
 Returns true when the given selector belongs to the given protocol.
 */
public func sel_belongsToProtocol(_ aSelector: Selector,
                                  _ aProtocol: Protocol) -> Bool
{
    for optionBits: UInt in 0..<(1 << 2) {
        let isRequired = optionBits & 1 != 0
        let isInstance = !(optionBits & (1 << 1) != 0)
        
        var methodDescription = protocol_getMethodDescription(aProtocol, aSelector, isRequired, isInstance)
        if !objc_method_description_isEmpty(&methodDescription)
        {
            return true
        }
    }
    return false
}

public func objc_method_description_isEmpty(_ methodDescription: inout objc_method_description)
    -> Bool
{
//    let ptr = withUnsafePointer(to: &methodDescription) { UnsafePointer<Int8>($0) }
//    for offset in 0..<MemoryLayout<objc_method_description>.size {
//        if ptr[offset] != 0 {
//            return false
//        }
//    }
//    return true
    
    
//    let pp = withUnsafePointer(to: &methodDescription) {
//            $0.withMemoryRebound(to: <#T##T.Type#>, capacity: <#T##Int#>, <#T##body: (UnsafeMutablePointer<T>) throws -> Result##(UnsafeMutablePointer<T>) throws -> Result#>)
//    }
    
    let count = MemoryLayout<objc_method_description>.size
    let bytePointer = withUnsafePointer(to: &methodDescription) {
//        UnsafePointer<Int8>($0)
//        UnsafePointer.withMemoryRebound
        
        $0.withMemoryRebound(to: UInt8.self, capacity: count) {
            UnsafeBufferPointer(start: $0, count: count)
        }
    }
    
//    let bytePointer = withUnsafePointer(to: &methodDescription) { ptr in
//        unsafeBitCast(ptr, UnsafePointer<Int8>.self)
//        //UnsafePointer<Int8>(ptr)
//    }
    
//    let ptr = withUnsafePointer(to: &methodDescription)
//    {
//        UnsafePointer<Int8>($0)
//    }
    
    for offset in 0..<MemoryLayout<objc_method_description>.size {
        if bytePointer[offset] != 0 {
            return false
        }
    }
    return true
}
