#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structures.h"
#include "avl_file_operations.h"


int main(int argc, char* argv[]){  // fonction principale du programme
    if (argc != 3){  // vérifie si le nombre d'arguments est différent de 3 
        printf("Il n'y a pas le bon nombre d'argument");  // message d'erreur 
        return 0;  // retourne 0 pour signaler une erreur
    }
    FILE* fichier_tmp = fopen(argv [1], "r");  // ouvre le fichier temporaire en mode lecture
    FILE* fichier_final = fopen(argv [2], "a+");  // ouvre le fichier final en mode ajout/lecture
    if((fichier_tmp == NULL) || (fichier_final == NULL)){  // vérifie si les fichiers ont été ouverts correctement
        printf("Problème lors de l'ouverture des fichiers");  // affiche un message d'erreur en cas d'échec
        exit (1); // quitte le programme en cas d'erreur
    }
    traitement_total(fichier_tmp, fichier_final);  // traite les fichiers (construction et écriture des données)
    fclose(fichier_final);  // ferme le fichier final
    fclose(fichier_tmp);  // ferme le fichier temporaire
}