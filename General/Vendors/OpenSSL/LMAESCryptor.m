/*
 * Gerard Martinez
 * CSE 40567
 * ndcrypto.c
 */

#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include "LMAESCryptor.h"

void aes_crypto_init()
{
	ERR_load_crypto_strings();
	OpenSSL_add_all_algorithms();
	OPENSSL_config(NULL);
}

void aes_crypto_cleanup()
{
	EVP_cleanup();
	ERR_free_strings();
}

void aes_crypto_error()
{
	ERR_print_errors_fp(stderr);
//	exit(1);
}

uint32_t aes_256_encrypt(unsigned char *input,
                          int len,
                          unsigned char *key,         
                          unsigned char *iv,         
                          unsigned char *output)
{
	int nlen, clen;
	EVP_CIPHER_CTX *ctx;

	ctx = EVP_CIPHER_CTX_new();
	if (!ctx) aes_crypto_error();

	if (EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1)
		aes_crypto_error();

	if (EVP_EncryptUpdate(ctx, output, &nlen, input, len) != 1)
		aes_crypto_error();

	clen = nlen;

	if (EVP_EncryptFinal_ex(ctx, output + nlen, &nlen) != 1)
		aes_crypto_error();

	clen += nlen;

	EVP_CIPHER_CTX_free(ctx);
	return clen;
}

uint32_t aes_256_decrypt(unsigned char *input,
                          int len,
                          unsigned char *key,         
                          unsigned char *iv,         
                          unsigned char *output)
{
	int nlen, plen;
	EVP_CIPHER_CTX *ctx;

	ctx = EVP_CIPHER_CTX_new();
	if (!ctx) aes_crypto_error();

	if (EVP_DecryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1)
		aes_crypto_error();

	if (EVP_DecryptUpdate(ctx, output, &nlen, input, len) != 1)
		aes_crypto_error();

	plen = nlen;

	if (EVP_DecryptFinal_ex(ctx, output + nlen, &nlen) != 1)
		aes_crypto_error();
    
	plen += nlen;

	EVP_CIPHER_CTX_free(ctx);
	return plen;
}

