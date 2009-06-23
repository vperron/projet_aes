/*
   Squelette de l'application pour l'implementation rapide de AES

   Ce code pose les bases d'une implémenation à préciser.

   Victor Perron / Florian Vallée 2009

   ELECINF359

 */



/* Entrees/sorties standard */
#include <stdio.h>

/* Definitions supplementaire */
#define u32 unsigned int 


#define BIT_SSE      0
#define BIT_SSE2     1
#define BIT_SSE3     2
#define BIT_SSSE3    3
#define BIT_SSE4_1   4
#define BIT_SSE4_2   5




/* Prototypes de fonctions à utiliser en assemblxmeur */
// Le cdecl est utilisé pour etre sur de ne pas defaulter en stdcall (gcc rajouterait des manips sur la pile)
u32 SubBytes(u32, u32, u32 *) __attribute__ ((cdecl)) ;
u32 AesInit(void) __attribute__ ((cdecl)) ;


/*****************************************************************************/

int main(
        int argc, 
        char ** argv
        )
{



	u32 res;
	u32 a = 1, b = 2;
	u32 * c;

	u32 caca = 8;

	c = &caca;

	printf("/==================================================\n\n");
	printf("/  PROJET AES          ============================\n\n");
	printf("/==================================================\n");

	printf("Test appel fonction ASM :");
	res = SubBytes(a,b,(u32 *)c);
	printf("a = %d, b = %d\n",a,b);
	printf("res ( a + b + 1 )  = %d\n",res);
	printf("*c ( a + b ) = %d\n",*c);

	printf("Identification processeur	:	\n");
	res = AesInit();
	
	printf("SSE	:	");
	if( res && BIT_SSE)
		printf("present.\n");		
	else
		printf("absent.\n");	

	printf("SSE2	:	");
	if( res && BIT_SSE2)
		printf("present.\n");		
	else
		printf("absent.\n");		

	printf("SSE3	:	");
	if( res && BIT_SSE3)
		printf("present.\n");		
	else
		printf("absent.\n");		

	printf("SSSE3	:	");
	if( res && BIT_SSSE3)
		printf("present.\n");		
	else
		printf("absent.\n");	
	
	printf("SSE4.1	:	");
	if( res && BIT_SSE4_1)
		printf("present.\n");		
	else
		printf("absent.\n");			

	printf("SSE4.2	:	");
	if( res && BIT_SSE4_2)
		printf("present.\n");		
	else
		printf("absent.\n");	
    
    return 0;
}
     

