#ifndef AVL_FILE_OPERATIONS_H
#define AVL_FILE_OPERATIONS_H

#include <stdio.h>
#include "avl_operations.h" // Pour les fonctions AVL de base

// Déclarations des fonctions
pArbre ajout_consommation_noeud(pArbre a, long consommation, int id_noeud);
void ecrire(pArbre a, FILE* fichier2);
pArbre recuperer_fichier_tmp(FILE* fichier);
void traitement_total(FILE* fichier_tmp, FILE* fichier_final);

#endif // AVL_FILE_OPERATIONS_H