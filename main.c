/*
   Squelette de l'application pour l'implementation rapide de AES

   Ce code pose les bases d'une implémenation à préciser.

   Victor Perron / Florian Vallée 2009

   ELECINF359

 */
/* Entrees/sorties standard */
#include <stdio.h>
#include "main.h"
#include "aes.h"
#include "cpucycles/cpucycles.h"

#define BIT_SSE      0
#define BIT_SSE2     1
#define BIT_SSE3     2
#define BIT_SSSE3    3
#define BIT_SSE4_1   4
#define BIT_SSE4_2   5



u32 StateOne[4] = {
       /* 0xabcdabcd,
	0x12341234,
	0x12345678,
	0x1f2f3f4f */
	0x19a09ae9,
	0x3df4c6f8,
	0xe3e28d48,
	0xbe2b2a08
};

u32 StateTwo[4] = { 
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000
};

u32 PlainText[4] = { 
	0x328831e0,
	0x435a3137,
	0xf6309807,
	0xa88da234
};



/*****************************************************************************/
int main(
        int argc, 
        char ** argv
        )
{

	long	t;
	long	t2;

	u32 res;
	u32 a = 1, b = 2;
	u32 * c;

	u32 caca = 8;

	c = &caca;

	printf("/==================================================\n\n");
	printf("/  PROJET AES          ============================\n\n");
	printf("/==================================================\n");

	printf("Test appel fonction ASM :");
	res = AsmTest(a,b,(u32 *)c);
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


	printf("Generation des RoundKeys ...\n");
	t	= cpucycles();
	aes_generate_roundkeys( );
	t2	= cpucycles();
	printf("\nCycles : %d\n", (int) (t2 - t) );
	printf("Generation Terminee ...\n");
	aes_print_round_keys( );	
/*
	printf("Chargement d'une valeur de test dans l'etat\n");
	res = SetState( (u32*) StateOne );

	DumpState( (u32*) StateTwo );

	printf("Test de la valeur chargee :\n");
	for ( a = 0 ; a < 4 ; a++ ) {
		printf( "Val %i %x\n" , a, StateTwo[a] ); 
	}

	SubByte( );
	ShiftRows_SSSE3( );
	MixColumns( (u32*) StateTwo   );

	for ( a = 0 ; a < 4 ; a++ ) {
		printf( "Val %i %x\n" , a, (keys.round_keys + 4)[a] ); 
	}

	AddRoundKey( keys.round_keys + 4 , StateTwo );

	DumpState( (u32*) StateTwo );

	printf("Test de la valeur chargee :\n");
	for ( a = 0 ; a < 4 ; a++ ) {
		printf( "Val %i %x\n" , a, StateTwo[a] ); 
	}

	printf("Premier tour d'encodage :\n");
*/

	t	= cpucycles();

	printf("Test D'encodage\n");
	printf("Test D'encodage\n");
	printf("Test D'encodage\n");


	for ( a = 0 ; a < 1 ; a++ ) { 
		aes_cipher( PlainText );
	}

	t2	= cpucycles();

	printf( "Test CLK %d\n", (int) (t2 - t)  );


	aes_ViewState();

	printf( " %d\n ", a );

    return 0;
}

