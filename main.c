/*
   Squelette de l'application pour l'implementation rapide de AES

   Ce code pose les bases d'une implémenation à préciser.

   Victor Perron / Florian Vallée 2009

   ELECINF359

 */



/* Entrees/sorties standard */
#include <stdio.h>



    /* 
        TODO: A placer dans un include 
    */

/* Premières définitions */

#define KEY_SIZE 16

#define KEY_ROUNDS 12

typedef struct {

    /* Pointeur sur les données à crypter */
    char * data;

    /* Taille des données, doit etre un multiple de 16. A l'implementation de padder. */
    int ln;

    /* Pointeur sur la clé, eventuellement de taille quelconque */
    char key[KEY_SIZE];

    /* Tableau contenant les différentes variantes de clé */
    char round_keys[KEY_ROUNDS][KEY_SIZE];

} options;




    /* 
       TODO end
    */
    


unsigned int  SubBytes(unsigned int, unsigned int, unsigned int);


/*****************************************************************************/

int main(
        int argc, 
        char ** argv
        )
{


    options mesOptions;

    
    /* Recuperation des infos eventuelles de fichiers de config */
    getConfig(&mesOptions);
    
    /* Parsage des arguments de la ligne de commande : 
     override les infos des fichiers de config                  */
    parse_args(argc, argv, &mesOptions);

    // TODO: A ce moment je me dis que pourquoi pas le C++.
    /* En effet, on pourrait tres bien imaginer l'initialisation
       en CONSTRUISANT la classe infos,
       pui utiliser les méthodes de la classe en mode
       options.generateRoundKeys();
       options.digest() pour crypter
       et ainsi de suite.
    */

    
    return 0;
}
     

