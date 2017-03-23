//
//  Array+Extension.swift
//  Pods
//
//  Created by 刘伟 on 16/6/30.
//
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }

    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}
