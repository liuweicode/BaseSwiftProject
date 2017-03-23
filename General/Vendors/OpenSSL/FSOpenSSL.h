//
//  FSOpenSSL.h
//  OpenSSL-for-iOS
//
//  Created by Felix Schulze on 16.03.2013.
//  Copyright 2013 Felix Schulze. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <Foundation/Foundation.h>

@interface FSOpenSSL : NSObject

+ (nonnull NSString *)md5FromString:(NSString * __nonnull)string;

+ (nullable NSString *)sha256FromString:(NSString * __nonnull)string;

+ (nullable NSString *)sha1FromString:(NSString * __nonnull)string;

+ (nullable NSString *)base64FromString:(NSString * __nonnull)string encodeWithNewlines:(BOOL)encodeWithNewlines;

+ (nullable NSData *)rsaDecodeData:(NSData* __nonnull)encryptedData;

+ (nullable NSString *)rsaDecodeDataToString:(NSData* __nonnull)encryptedData;

+ (nullable NSData*)aes_decrypt:(NSData* __nonnull)encryptedData key:(NSString* __nonnull)keyStr iv:(NSString* __nonnull)ivStr;

+ (nullable NSString*)aes_decrypt_to_String:(NSData* __nonnull)encryptedData key:(NSString* __nonnull)keyStr iv:(NSString* __nonnull)ivStr;

+ (nullable NSData*)aes_encrypt:(NSData* __nonnull)plaintextData key:(NSString* __nonnull)keyStr iv:(NSString* __nonnull)ivStr;

@end