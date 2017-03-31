//
//  OpenSSLUtil.h
//  BaseSwiftProject
//
//  Created by 刘伟 on 3/28/17.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenSSLUtil : NSObject

+ (nonnull NSString *)md5FromString:(NSString * __nonnull)string;
    
+ (nullable NSString *)sha256FromString:(NSString * __nonnull)string;
    
+ (nullable NSString *)sha1FromString:(NSString * __nonnull)string;
    
+ (nullable NSString *)base64FromString:(NSString * __nonnull)string encodeWithNewlines:(BOOL)encodeWithNewlines;
    
+ (nullable NSData *)rsaDecode:(NSData* __nonnull)encryptedData;
    
+ (nullable NSString *)rsaDecodeDataToString:(NSData* __nonnull)encryptedData;
    
+ (nullable NSData*)aes_256_decrypt:(NSData* __nonnull)encryptedData key:(NSString* __nonnull)keyStr iv:(NSString* __nonnull)ivStr;
    
+ (nullable NSData*)aes_256_encrypt:(NSData* __nonnull)plaintextData key:(NSString* __nonnull)keyStr iv:(NSString* __nonnull)ivStr;
    
@end
