/* 
 * Gerard Martinez
 * CSE 40567
 * ndcrypto.h
 */

#include <stdint.h>

#ifndef _ND_CRYPTO_
#define _ND_CRYPTO_

void aes_crypto_init();

void aes_crypto_cleanup();

uint32_t aes_256_encrypt(unsigned char *input,
                          int len,
                          unsigned char *key,
                          unsigned char *iv,
                          unsigned char *output);

uint32_t aes_256_decrypt(unsigned char *input,
                          int len,
                          unsigned char *key,
                          unsigned char *iv,
                          unsigned char *output);
#endif /* _ND_CRYPTO_ */
