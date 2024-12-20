#ifndef AVL_OPERATIONS_H
#define AVL_OPERATIONS_H

#include "structures.h" // Inclure les structures AVL et Station

// Déclaration des fonctions AVL
pArbre creer_arbre(int id, long capa);
int min(int a, int b);
int max(int a, int b);
pArbre rotation_droite(pArbre a);
pArbre rotation_gauche(pArbre a);
pArbre double_rotation_droit(pArbre a);
pArbre double_rotation_gauche(pArbre a);
pArbre equilibrer_AVL(pArbre a);
pArbre insert_AVL(pArbre a, int id, long capa, int* h);

#endif // AVL_OPERATIONS_H