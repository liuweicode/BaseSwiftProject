//
//  LMRSACryptor.c
//  OpenSSL-lm
//
//  Created by 刘伟 on 16/7/29.
//  Copyright © 2016年 Linkim. All rights reserved.
//
// 参考 https://gist.github.com/superwills/5415344

#include "LMRSACryptor.h"
#include "base64.h"

#define PADDING RSA_PKCS1_PADDING

RSA* loadPUBLICKeyFromString( const char* publicKeyStr )
{
    // A BIO is an I/O abstraction (Byte I/O?)
    
    // BIO_new_mem_buf: Create a read-only bio buf with data
    // in string passed. -1 means string is null terminated,
    // so BIO_new_mem_buf can find the dataLen itself.
    // Since BIO_new_mem_buf will be READ ONLY, it's fine that publicKeyStr is const.
    BIO* bio = BIO_new_mem_buf( (void*)publicKeyStr, -1 ) ; // -1: assume string is null terminated
    
    BIO_set_flags( bio, BIO_FLAGS_BASE64_NO_NL ) ; // NO NL
    
    // Load the RSA key from the BIO
    RSA* rsaPubKey = PEM_read_bio_RSA_PUBKEY( bio, NULL, NULL, NULL ) ;
    if( !rsaPubKey )
        printf( "ERROR: Could not load PUBLIC KEY!  PEM_read_bio_RSA_PUBKEY FAILED: %s\n", ERR_error_string( ERR_get_error(), NULL ) ) ;
    
    BIO_free( bio ) ;
    return rsaPubKey ;
}

RSA* loadPRIVATEKeyFromString(const char* privateKeyStr)
{
    BIO *bio = BIO_new_mem_buf( (void*)privateKeyStr, -1 );
    //BIO_set_flags( bio, BIO_FLAGS_BASE64_NO_NL ) ; // NO NL
    RSA* rsaPrivKey = PEM_read_bio_RSAPrivateKey( bio, NULL, NULL, NULL ) ;
    
    if ( !rsaPrivKey )
        printf("ERROR: Could not load PRIVATE KEY!  PEM_read_bio_RSAPrivateKey FAILED: %s\n", ERR_error_string(ERR_get_error(), NULL));
    
    BIO_free( bio ) ;
    return rsaPrivKey ;
}

unsigned char* public_encrypt( RSA *pubKey, const unsigned char* str, int dataSize, int *resultLen )
{
    int rsaLen = RSA_size( pubKey ) ;
    unsigned char* ed = (unsigned char*)malloc( rsaLen ) ;
    
    // RSA_public_encrypt() returns the size of the encrypted data
    // (i.e., RSA_size(rsa)). RSA_private_decrypt()
    // returns the size of the recovered plaintext.
    *resultLen = RSA_public_encrypt( dataSize, (const unsigned char*)str, ed, pubKey, PADDING ) ;
    if( *resultLen == -1 )
        printf("ERROR: RSA_public_encrypt: %s\n", ERR_error_string(ERR_get_error(), NULL));
    
    return ed ;
}

char* public_encrypt_base64( RSA *pubKey, unsigned char* binaryData, int binaryDataLen, int *outLen )
{
    int encryptedDataLen ;
    
    // RSA encryption with public key
    unsigned char* encrypted = public_encrypt( pubKey, binaryData, binaryDataLen, &encryptedDataLen ) ;
    
    // To base 64
    int asciiBase64EncLen ;
    char* asciiBase64Enc = base64( encrypted, encryptedDataLen, &asciiBase64EncLen ) ;
    
    // Destroy the encrypted data (we are using the base64 version of it)
    free( encrypted ) ;
    
    // Return the base64 version of the encrypted data
    return asciiBase64Enc ;
}

unsigned char* public_decrypt( RSA *pubKey, const unsigned char* encryptedData, int *resultLen )
{
    int rsaLen = RSA_size( pubKey ) ; // That's how many bytes the decrypted data would be
    
    unsigned char *decryptedBin = (unsigned char*)malloc( rsaLen ) ;
    *resultLen = RSA_public_decrypt( RSA_size(pubKey), encryptedData, decryptedBin, pubKey, PADDING ) ;
    if( *resultLen == -1 )
        printf( "ERROR: RSA_public_decrypt: %s\n", ERR_error_string(ERR_get_error(), NULL) ) ;
    
    return decryptedBin ;
}

unsigned char* public_decrypt_base64( RSA *pubKey, char* base64String, int *outLen )
{
    int encBinLen ;
    unsigned char* encBin = unbase64( base64String, (int)strlen( base64String ), &encBinLen ) ;
    
    // rsaDecrypt assumes length of encBin based on privKey
    unsigned char *decryptedBin = public_decrypt( pubKey, encBin, outLen ) ;
    free( encBin ) ;
    
    return decryptedBin ;
}

unsigned char* private_encrypt( RSA *privKey, const unsigned char* str, int dataSize, int *resultLen )
{
    int rsaLen = RSA_size( privKey ) ;
    unsigned char* ed = (unsigned char*)malloc( rsaLen ) ;
    
    // RSA_private_encrypt() returns the size of the encrypted data
    // (i.e., RSA_size(rsa)). RSA_public_decrypt()
    // returns the size of the recovered plaintext.
    *resultLen = RSA_private_encrypt( dataSize, (const unsigned char*)str, ed, privKey, PADDING ) ;
    if( *resultLen == -1 )
        printf("ERROR: RSA_public_encrypt: %s\n", ERR_error_string(ERR_get_error(), NULL));
    
    return ed ;
}

char* private_encrypt_base64( RSA *privKey, unsigned char* binaryData, int binaryDataLen, int *outLen )
{
    int encryptedDataLen ;
    
    // RSA encryption with public key
    unsigned char* encrypted = private_encrypt( privKey, binaryData, binaryDataLen, &encryptedDataLen ) ;
    
    // To base 64
    int asciiBase64EncLen ;
    char* asciiBase64Enc = base64( encrypted, encryptedDataLen, &asciiBase64EncLen ) ;
    
    // Destroy the encrypted data (we are using the base64 version of it)
    free( encrypted ) ;
    
    // Return the base64 version of the encrypted data
    return asciiBase64Enc ;
}

unsigned char* private_decrypt( RSA *privKey, const unsigned char* encryptedData, int *resultLen )
{
    int rsaLen = RSA_size( privKey ) ; // That's how many bytes the decrypted data would be
    
    unsigned char *decryptedBin = (unsigned char*)malloc( rsaLen ) ;
    *resultLen = RSA_private_decrypt( RSA_size(privKey), encryptedData, decryptedBin, privKey, PADDING ) ;
    if( *resultLen == -1 )
        printf( "ERROR: RSA_private_decrypt: %s\n", ERR_error_string(ERR_get_error(), NULL) ) ;
    
    return decryptedBin ;
}

unsigned char* private_decrypt_base64( RSA *privKey, char* base64String, int *outLen )
{
    int encBinLen ;
    unsigned char* encBin = unbase64( base64String, (int)strlen( base64String ), &encBinLen ) ;
    
    // rsaDecrypt assumes length of encBin based on privKey
    unsigned char *decryptedBin = private_decrypt( privKey, encBin, outLen ) ;
    free( encBin ) ;
    
    return decryptedBin ;
}
