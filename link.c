/*
   Squelette de l'application pour l'implementation rapide de AES

   Ce code pose les bases d'une implémenation à préciser.

   Victor Perron / Florian Vallée 2009

   ELECINF359

 */



/* Entrees/sorties standard */
#include <stdio.h>



unsigned int  SubBytes(unsigned int, unsigned int, unsigned int);


/*****************************************************************************/

int main(
        int argc, 
        char ** argv
        )
{

    unsigned int a = 0;

    unsigned int ret;

    ret = SubBytes(3,12,(unsigned int)&a);

    printf("ret = %x, a = %x",ret,a);

    return 0;
}
     

