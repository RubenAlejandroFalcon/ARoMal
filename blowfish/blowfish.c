#include <windows.h>
#include "blowfish.h"
#include <string.h>
#include <stdlib.h>
#include <time.h>

//#include "unistd.h"


#define MAXKEYBYTES 56          /* 448 bits */
#define bf_N             16
#define noErr            0
#define DATAERROR         -1
#define KEYBYTES         8

#define nmalloc(x) n_malloc((x),__FILE__,__LINE__)

#define UBYTE_08bits  unsigned char
#define UWORD_16bits  unsigned short


/* dAS lEETo rIP fROm eggdrop.h */

/* FUCK THE AUTOCONF :D */

#define SIZEOF_INT 4
#define SIZEOF_LONG 4


#if SIZEOF_INT==4
#  define UWORD_32bits  unsigned int
#else
#  if SIZEOF_LONG==4
#  define UWORD_32bits  unsigned long
#  endif
#endif

/* choose a byte order for your hardware */

#ifdef WORDS_BIGENDIAN
/* ABCD - big endian - motorola */
union aword {
  UWORD_32bits word;
  UBYTE_08bits byte [4];
  struct {
    unsigned int byte0:8;
    unsigned int byte1:8;
    unsigned int byte2:8;
    unsigned int byte3:8;
  } w;
};
#endif  /* WORDS_BIGENDIAN */

#ifndef WORDS_BIGENDIAN
/* DCBA - little endian - intel */
union aword {
  UWORD_32bits word;
  UBYTE_08bits byte [4];
  struct {
    unsigned int byte3:8;
    unsigned int byte2:8;
    unsigned int byte1:8;
    unsigned int byte0:8;
  } w;
};
#endif  /* !WORDS_BIGENDIAN */


#include "bf_tab.h"		/* P-box P-array, S-box  */

/* each box takes up 4k so be very careful here */
#define BOXES  3

/* #define S(x,i) (bf_S[i][x.w.byte##i])  */
#define S0(x) (bf_S[0][x.w.byte0])
#define S1(x) (bf_S[1][x.w.byte1])
#define S2(x) (bf_S[2][x.w.byte2])
#define S3(x) (bf_S[3][x.w.byte3])
#define bf_F(x) (((S0(x) + S1(x)) ^ S2(x)) + S3(x))
#define ROUND(a,b,n) (a.word ^= bf_F(b) ^ bf_P[n])

/* keep a set of rotating P & S boxes */
struct box_t {
   UWORD_32bits *P;
   UWORD_32bits **S;
   char key[81];
   char keybytes;
} box[BOXES];


UWORD_32bits *bf_P;

UWORD_32bits **bf_S;



void blowfish_encipher (UWORD_32bits * xl, UWORD_32bits * xr)
{
   union aword Xl;
   union aword Xr;

   Xl.word = *xl;
   Xr.word = *xr;

   Xl.word ^= bf_P[0];
   ROUND(Xr, Xl, 1);
   ROUND(Xl, Xr, 2);
   ROUND(Xr, Xl, 3);
   ROUND(Xl, Xr, 4);
   ROUND(Xr, Xl, 5);
   ROUND(Xl, Xr, 6);
   ROUND(Xr, Xl, 7);
   ROUND(Xl, Xr, 8);
   ROUND(Xr, Xl, 9);
   ROUND(Xl, Xr, 10);
   ROUND(Xr, Xl, 11);
   ROUND(Xl, Xr, 12);
   ROUND(Xr, Xl, 13);
   ROUND(Xl, Xr, 14);
   ROUND(Xr, Xl, 15);
   ROUND(Xl, Xr, 16);
   Xr.word ^= bf_P[17];

   *xr = Xl.word;
   *xl = Xr.word;
}



void blowfish_init (UBYTE_08bits * key, short keybytes, int bxtouse)
{
   int i, j, bx;
//   time_t lowest;
   UWORD_32bits data;
   UWORD_32bits datal;
   UWORD_32bits datar;
   union aword temp;

   /* is buffer already allocated for this? */
   for (i = 0; i < BOXES; i++)
      if (box[i].P != NULL) {
	 if ((box[i].keybytes == keybytes) &&
	 (strncmp((char *) (box[i].key), (char *) key, keybytes) == 0)) {
	    /* match! */
	    bf_P = box[i].P;
	    bf_S = box[i].S;
	    return;
	 }
      }
   /* no pre-allocated buffer: make new one */
   /* set 'bx' to empty buffer */
   bx = (-1);
   for (i = 0; i < BOXES; i++) {
      if (box[i].P == NULL) {
	 bx = i;
	 i = BOXES + 1;
      }
   }
   if (bx < 0) {
      /* find oldest */
/* fuck it, use first box available */

bx = bxtouse;
      free(box[bx].P);
      for (i = 0; i < 4; i++)
	 free(box[bx].S[i]);
      free(box[bx].S);
   }
   /* initialize new buffer */
   /* uh... this is over 4k */
   box[bx].P = (UWORD_32bits *) malloc((bf_N + 2) * sizeof(UWORD_32bits));
   box[bx].S = (UWORD_32bits **) malloc(4 * sizeof(UWORD_32bits *));
   for (i = 0; i < 4; i++)
      box[bx].S[i] = (UWORD_32bits *) malloc(256 * sizeof(UWORD_32bits));
   bf_P = box[bx].P;
   bf_S = box[bx].S;
   box[bx].keybytes = (char) keybytes;
   strncpy(box[bx].key, key, keybytes);
   /* robey: reset blowfish boxes to initial state */
   /* (i guess normally it just keeps scrambling them, but here it's */
   /* important to get the same encrypted result each time) */
   for (i = 0; i < bf_N + 2; i++)
      bf_P[i] = initbf_P[i];
   for (i = 0; i < 4; i++)
      for (j = 0; j < 256; j++)
	 bf_S[i][j] = initbf_S[i][j];

   j = 0;
   for (i = 0; i < bf_N + 2; ++i) {
      temp.word = 0;
      temp.w.byte0 = key[j];
      temp.w.byte1 = key[(j + 1) % keybytes];
      temp.w.byte2 = key[(j + 2) % keybytes];
      temp.w.byte3 = key[(j + 3) % keybytes];
      data = temp.word;
      bf_P[i] = bf_P[i] ^ data;
      j = (j + 4) % keybytes;
   }

   datal = 0x00000000;
   datar = 0x00000000;

   for (i = 0; i < bf_N + 2; i += 2) {
      blowfish_encipher(&datal, &datar);

      bf_P[i] = datal;
      bf_P[i + 1] = datar;
   }

   for (i = 0; i < 4; ++i) {
      for (j = 0; j < 256; j += 2) {

	 blowfish_encipher(&datal, &datar);

	 bf_S[i][j] = datal;
	 bf_S[i][j + 1] = datar;
      }
   }
}


#define SALT1  0xdeadd061
#define SALT2  0x23f6b095

/* convert 64-bit encrypted password to text for userfile */
char *base64 = "./0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

int base64dec (char c)
{
   int i;
   for (i = 0; i < 64; i++)
      if (base64[i] == c)
	 return i;
   return 0;
}

void blowfish_encrypt_pass (char *text, char *new, int bxtouse)
{
   UWORD_32bits left, right;
   int n;
   char *p;
   blowfish_init((UBYTE_08bits *)text, (short)strlen(text), bxtouse);
   left = SALT1;
   right = SALT2;
   blowfish_encipher(&left, &right);
   p = new;
   *p++ = '+';			/* + means encrypted pass */
   n = 32;
   while (n > 0) {
      *p++ = base64[right & 0x3f];
      right = (right >> 6);
      n -= 6;
   }
   n = 32;
   while (n > 0) {
      *p++ = base64[left & 0x3f];
      left = (left >> 6);
      n -= 6;
   }
   *p = 0;
}