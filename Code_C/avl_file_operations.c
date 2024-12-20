#include <stdio.h>
#include <stdlib.h>
#include "avl_file_operations.h"

pArbre ajout_consommation_noeud(pArbre a, long consommation, int id_noeud){  // fonction pour ajouteur de la consommation à un noeud dans l'arbre 
    if(a == NULL){  // si l'arbre est vide
        printf("erreur lors du code");  // message d'erreur
        exit(1);  // sortie du programme
    }
    else if(id_noeud < a->station.id_station){  // si l'id recherché est inférieur à l'id du nœud courant
        a->gauche = ajout_consommation_noeud(a->gauche, consommation, id_noeud);  // exploration du fils gauche
    }
    else if(id_noeud > a->station.id_station){  // si l'id recherché est supérieur à l'id du nœud courant
        a->droit = ajout_consommation_noeud(a->droit, consommation, id_noeud);  // exploration du fils droit
    }
    else{  // si le noeud est trouvé 
        a->station.somme_conso = a->station.somme_conso + consommation;  // met à jour la consommation totale de la station
    }
    return a;  // retourner l'arbre 
}

void ecrire(pArbre a, FILE* fichier2){  // fonction pour écrire les données d'un arbre dans un fichier
    if(a!=NULL){  // / vérifie si l'arbre n'est pas vide
        ecrire(a->gauche, fichier2);  // appel récursif pour parcourir le sous-arbre gauche
        fprintf(fichier2, "%d:%ld:%ld\n", a->station.id_station, a->station.capacite, a->station.somme_conso);  // écrit les informations du nœud courant dans le fichier (id:capacité:consommation)
        ecrire(a->droit, fichier2);  // appel récursif pour parcourir le sous-arbre droit
        free(a);  // libère la mémoire allouée pour le nœud courant
    }
}


pArbre recuperer_fichier_tmp(FILE* fichier){  // fonction pour construire un arbre AVL à partir d'un fichier
    int id;  // identifiant de la station
    long capacite;  // capacité de la station
    long consommation;  // consommation de la station 
    int h = 0;  // variable pour gérer la hauteur lors de l'insertion dans l'AVL
    pArbre a = NULL;  // initialise un arbre vide
    while(fscanf(fichier, "%d;%ld;%ld", &id, &capacite, &consommation) != EOF){  // lit une ligne du fichier jusqu'à la fin (EOF) au format id;capacité;consommation
        if(consommation == 0){  // si la consommation est 0 (C'est une station)
            a = insert_AVL(a, id, capacite, &h);  // ajoute un nouveau nœud dans l'AVL
        }
        else{  // sinon
            a = ajout_consommation_noeud(a, consommation, id);  // ajoute la consommation à un nœud existant dans l'arbre
        }
    }
    return a;  // retourne l'arbre construit
}

void traitement_total(FILE* fichier_tmp, FILE* fichier_final){  // fonction pour traiter un fichier et écrire le résultat dans un fichier final
    pArbre a = NULL;  // initialise un arbre vide
    a = recuperer_fichier_tmp(fichier_tmp);  // construit l'arbre à partir du fichier temporaire
    ecrire(a, fichier_final);  // écrit les données de l'arbre dans le fichier final
}