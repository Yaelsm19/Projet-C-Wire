#ifndef STRUCTURES_H
#define STRUCTURES_H

// Définition de la structure représentant une station
typedef struct station {
    int id_station;     // Identifiant de la station
    long capacite;      // Capacité de la station
    long somme_conso;   // Somme des consommations associées à cette station
} Station;

// Définition de la structure d'un nœud d'arbre AVL
typedef struct arbre {
    Station station;       // Données de la station associée à ce nœud
    struct arbre* droit;   // Pointeur vers le fils droit
    struct arbre* gauche;  // Pointeur vers le fils gauche
    int equilibre;         // Facteur d'équilibre de l'arbre
} Arbre;

typedef Arbre* pArbre;  // Pointeur vers un Arbre

#endif // STRUCTURES_H