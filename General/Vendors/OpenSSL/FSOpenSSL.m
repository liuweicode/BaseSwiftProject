//
//  FSOpenSSL.m
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

#import "FSOpenSSL.h"
#include <openssl/md5.h>
#include <openssl/sha.h>
#import <openssl/evp.h>

#include "LMRSACryptor.h"
#include "LMAESCryptor.h"

@implementation FSOpenSSL

+ (nonnull NSString *)md5FromString:(NSString * __nonnull)string {
    //unsigned char *inStrg = (unsigned char *) [[string dataUsingEncoding:NSASCIIStringEncoding] bytes];
    unsigned char *inStrg = (unsigned char *) [string UTF8String];
    unsigned long lngth = [string length];
    unsigned char result[MD5_DIGEST_LENGTH];
    NSMutableString *outStrg = [NSMutableString string];

    MD5(inStrg, lngth, result);

    unsigned int i;
    for (i = 0; i < MD5_DIGEST_LENGTH; i++) {
        [outStrg appendFormat:@"%02x", result[i]];
    }
    return [outStrg copy];
}

+ (nullable NSString *)sha256FromString:(NSString * __nonnull)string {
    unsigned char *inStrg = (unsigned char *) [[string dataUsingEncoding:NSASCIIStringEncoding] bytes];
    unsigned long lngth = [string length];
    unsigned char result[SHA256_DIGEST_LENGTH];
    NSMutableString *outStrg = [NSMutableString string];

    SHA256_CTX sha256;
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, inStrg, lngth);
    SHA256_Final(result, &sha256);

    unsigned int i;
    for (i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        [outStrg appendFormat:@"%02x", result[i]];
    }
    return [outStrg copy];
}

+ (nullable NSString *)sha1FromString:(NSString * __nonnull)string {
    unsigned char *inStrg = (unsigned char *) [[string dataUsingEncoding:NSASCIIStringEncoding] bytes];
    unsigned long lngth = [string length];
    unsigned char result[SHA_DIGEST_LENGTH];
    NSMutableString *outStrg = [NSMutableString string];
    
    SHA_CTX sha1;
    SHA1_Init(&sha1);
    SHA1_Update(&sha1, inStrg, lngth);
    SHA1_Final(result, &sha1);
    
    unsigned int i;
    for (i = 0; i < SHA_DIGEST_LENGTH; i++) {
        [outStrg appendFormat:@"%02x", result[i]];
    }
    return [outStrg copy];
}


+ (nullable NSString *)base64FromString:(NSString * __nonnull)string encodeWithNewlines:(BOOL)encodeWithNewlines {
    BIO *mem = BIO_new(BIO_s_mem());
    BIO *b64 = BIO_new(BIO_f_base64());

    if (!encodeWithNewlines) {
        BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
    }
    mem = BIO_push(b64, mem);

    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = stringData.length;
    void *buffer = (void *) [stringData bytes];
    int bufferSize = (int)MIN(length, INT_MAX);

    NSUInteger count = 0;

    BOOL error = NO;

    // Encode the data
    while (!error && count < length) {
        int result = BIO_write(mem, buffer, bufferSize);
        if (result <= 0) {
            error = YES;
        }
        else {
            count += result;
            buffer = (void *) [stringData bytes] + count;
            bufferSize = (int)MIN((length - count), INT_MAX);
        }
    }

    int flush_result = BIO_flush(mem);
    if (flush_result != 1) {
        return nil;
    }

    char *base64Pointer;
    NSUInteger base64Length = (NSUInteger) BIO_get_mem_data(mem, &base64Pointer);

    NSData *base64data = [NSData dataWithBytesNoCopy:base64Pointer length:base64Length freeWhenDone:NO];
    NSString *base64String = [[NSString alloc] initWithData:base64data encoding:NSUTF8StringEncoding];

    BIO_free_all(mem);
    return base64String;
}

+ (nullable NSData *)rsaDecodeData:(NSData* __nonnull)encryptedData
{
    
    if (encryptedData.length == 0) {
        return nil;
    }
    // 以256个字节分割Data
    NSArray* splitedDataArr = [FSOpenSSL splitDataWithData:encryptedData splitSize:256];
    
    // 私钥
    //char publicKey[] = "-----BEGIN PUBLIC KEY-----\n"\
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqPAN5nVk/OAEC2ybIFv5\n"\
    "MvP7Nd/7jsKka1fmLR5upzGP2kOYIIAwSRMNTf9XsxvzoU/8fgVyMaRHro7bQfkV\n"\
    "HL3lzJzuHD9668ZlMkYkv8lhisXCbec/CvqHyfX38WInNMeEbD/0xlP3Yvs16EJB\n"\
    "SjZeeZ6hQbhG7z7GQCqXLQO5ri7SWdLWA1GJb5eJzvbUwrUR7VL6FZCSQawzF+WK\n"\
    "ZJzfoJICKKhD9EfB66yAQWuniad7YK6DOvX7ZJpjBS/8nIEuCnwQGu7iOHhiECxs\n"\
    "gOFrLi1Ed+zvJNE9IA66wtMzNcB+v+SAZx7AEhxmYObdYMJIw4LB67NDEUEtHxGk\n"\
    "gwIDAQAB\n"\
    "-----END PUBLIC KEY-----\n";
    
    char publicKey[] = "-----BEGIN PUBLIC KEY-----\n"\
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqPAN5nVk/OAEC2ybIFv5\n"\
    "MvP7Nd/7jsKka1fmLR5upzGP2kOYIIAwSRMNTf9XsxvzoU/8fgVyMaRHro7bQfkV\n"\
    "HL3lzJzuHD9668ZlMkYkv8lhisXCbec/CvqHyfX38WInNMeEbD/0xlP3Yvs16EJB\n"\
    "SjZeeZ6hQbhG7z7GQCqXLQO5ri7SWdLWA1GJb5eJzvbUwrUR7VL6FZCSQawzF+WK\n"\
    "ZJzfoJICKKhD9EfB66yAQWuniad7YK6DOvX7ZJpjBS/8nIEuCnwQGu7iOHhiECxs\n"\
    "gOFrLi1Ed+zvJNE9IA66wtMzNcB+v+SAZx7AEhxmYObdYMJIw4LB67NDEUEtHxGk\n"\
    "gwIDAQAB\n"\
    "-----END PUBLIC KEY-----\n";
    
    ERR_load_crypto_strings();
    
    // 加载公钥
    RSA *pubKey = loadPUBLICKeyFromString(publicKey);
    
    if (pubKey == NULL) {
        printf( "ERROR: RSA_public_decrypt: rsa public key error") ;
        return nil;
    }
    
    NSMutableData* recoveredAllData = [NSMutableData data];
    // 分段解密
    for (NSData* data in splitedDataArr) {
        // 解密
        int resultLen ;
        const unsigned char* rxOverHTTP = [data bytes];
        unsigned char* decryptedBin = public_decrypt( pubKey, rxOverHTTP, &resultLen ) ;
        if (resultLen != -1) {
            //printf("Decrypted %d bytes, the recovered data is:\n%.*s\n\n", resultLen, resultLen, decryptedBin );
            NSData *recoveredData = [NSData dataWithBytes: decryptedBin length:resultLen];
            [recoveredAllData appendData:recoveredData];
        }
        free(decryptedBin);
    }
    
    RSA_free(pubKey) ;
    
    ERR_free_strings();
    
    if (recoveredAllData.length == 0) {
        return nil;
    }

    return [NSData dataWithData:recoveredAllData];
}

+ (nullable NSString *)rsaDecodeDataToString:(NSData* __nonnull)encryptedData
{
    NSData* data = [FSOpenSSL rsaDecodeData:encryptedData];
    
    if (data == nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSArray *)splitDataWithData:(NSData *)data splitSize:(int)size
{
    NSRange dataRange;
    NSInteger dataSize = data.length;
    NSInteger dataSplitCount = dataSize/size;
    
    dataRange.length = size;
    dataRange.location = 0;
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for(NSInteger cnt = 0;cnt<dataSplitCount;cnt++) {
        
        [dataArray addObject:[data subdataWithRange:dataRange]];
        dataRange.location += size;
    }
    dataRange.length = dataSize % size;
    if ([[data subdataWithRange:dataRange] length] > 0) {
        [dataArray addObject:[data subdataWithRange:dataRange]];
    }
    return dataArray;
}

#pragma mark - AES

+ (nullable NSData*)aes_decrypt:(NSData* __nonnull)encryptedData key:(NSString* __nonnull)keyStr iv:(NSString* __nonnull)ivStr
{
    unsigned char *ciphertext = (unsigned char *)[encryptedData bytes];
    int ciphertextLen = (int)[encryptedData length];
    
    unsigned char *key = (unsigned char *)[keyStr UTF8String];
    unsigned char *iv = (unsigned char *)[ivStr UTF8String];
    
    unsigned char *plaintext = (unsigned char *)malloc(ciphertextLen);
    
    int resultLen = aes_256_decrypt(ciphertext, ciphertextLen, key, iv, plaintext);
    
    if (resultLen > 0) {
        NSData *recoveredData = [NSData dataWithBytes:plaintext length:resultLen];//[NSData dataWithBytesNoCopy:plaintext length:resultLen freeWhenDone:YES];
        free(plaintext);
        return recoveredData;
    }
    free(plaintext);
    return nil;
}

+ (nullable NSString*)aes_decrypt_to_String:(NSData* __nonnull)encryptedData key:(NSString* __nonnull)keyStr iv:(NSString* __nonnull)ivStr
{
    NSData* decryptedData = [FSOpenSSL aes_decrypt:encryptedData key:keyStr iv:ivStr];
    if (decryptedData == nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

+ (nullable NSData*)aes_encrypt:(NSData* __nonnull)plaintextData key:(NSString* __nonnull)keyStr iv:(NSString* __nonnull)ivStr
{
    unsigned char *plaintext = (unsigned char *)[plaintextData bytes];
    unsigned char *key = (unsigned char *)[keyStr UTF8String];
    unsigned char *iv = (unsigned char *)[ivStr UTF8String];
    
//    unsigned char empty[] = { 0 };
//    unsigned char *ciphertext = empty;
    unsigned char *ciphertext = (unsigned char *)malloc(plaintextData.length + 256);

    int len = (int)[plaintextData length];
    
    int resultLen = aes_256_encrypt(plaintext, len, key, iv, ciphertext);
    if (resultLen > 0) {
        NSData *recoveredData = [NSData dataWithBytes: ciphertext length:resultLen];
        free(ciphertext);
        return recoveredData;
    }
    return nil;
}

@end
