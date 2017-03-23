//
//  LMRSACryptor.h
//  OpenSSL-lm
//
//  Created by 刘伟 on 16/7/29.
//  Copyright © 2016年 Linkim. All rights reserved.
//

#ifndef LMRSACryptor_h
#define LMRSACryptor_h

#include <stdio.h>

#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bio.h>
#include <openssl/err.h>


RSA* loadPUBLICKeyFromString( const char* publicKeyStr );

RSA* loadPRIVATEKeyFromString( const char* privateKeyStr );

unsigned char* public_encrypt( RSA *pubKey, const unsigned char* str, int dataSize, int *resultLen );

char* public_encrypt_base64( RSA *pubKey, unsigned char* binaryData, int binaryDataLen, int *outLen );

unsigned char* public_decrypt( RSA *pubKey, const unsigned char* encryptedData, int *resultLen );

unsigned char* public_decrypt_base64( RSA *pubKey, char* base64String, int *outLen );

unsigned char* private_encrypt( RSA *privKey, const unsigned char* str, int dataSize, int *resultLen );

char* private_encrypt_base64( RSA *privKey, unsigned char* binaryData, int binaryDataLen, int *outLen );

unsigned char* private_decrypt( RSA *privKey, const unsigned char* encryptedData, int *resultLen );

unsigned char* private_decrypt_base64( RSA *privKey, char* base64String, int *outLen );

#endif /* LMRSACryptor_h */
