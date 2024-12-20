#include <stdio.h>
#include <stdlib.h>
#include "avl_operations.h"

pArbre creer_arbre(int id, long capa){  // fonction pour creer un nœud d'arbre AVL
    pArbre nouveau = malloc(sizeof(Arbre));  // alloue dynamiquement un nouveau nœud d'arbre
    if(nouveau==NULL){  // vérifie si l'allocation mémoire a échoué
        printf("Erreur lors de l'allocation mémoire");  // message d'erreur
        exit(1);  // sortie du programme
    }
    nouveau->droit =NULL;  // initialisation du fils droit
    nouveau->gauche = NULL;  // initialisation du fils gauche
    nouveau->station.id_station = id;  // initialisation de l'identifiant de la station
    nouveau->station.capacite = capa;  // initialisation de la capacite de la station
    nouveau->station.somme_conso = 0;  // initialisation de consommation totale de la station à 0
    nouveau->equilibre = 0;  // initialisation de l'equilibre de la station à 0
    return nouveau;  // retourne le noeud créé
 }

int min(int a, int b){  // fonction calcul du minimum : renvoie le minimum entre deux entiers
    if(a > b){
        return b;
    }
    return a;
}

int max(int a, int b){  // fonction calcul du maximum : renvoie le maximum entre deux entiers
    if(a > b){
        return a;
    }
    return b;
}

pArbre rotation_droite(pArbre a){  // fonction pour faire une rotation à droite
    pArbre pivot = a->gauche;  // le pivot devient le fils gauche du nœud courant
    a->gauche = pivot->droit;  // le fils gauche devient le fils droit du pivot
    pivot->droit = a;  // fils droit du pivot devient a
    int equi_a = a->equilibre;  // création d'une variable égale à l'équilibre de a
    int equi_p = pivot->equilibre;  // création d'une variable égale à l'équilibre du pivot
    a->equilibre = equi_a - min(equi_p, 0) + 1;  // met à jour le facteur d'équilibre de a
    pivot->equilibre = max(max(equi_a+2, equi_a + equi_p +2), equi_p +1);  // met à jour le facteur d'équilibre du pivot
    a = pivot;  // a  est égal au pivot
    return a;  // retourner l'arbre 
}

pArbre rotation_gauche(pArbre a){  // fonction pour faire une rotation à gauche 
    pArbre pivot = a->droit;  // le pivot devient le fils droit du nœud courant
    a->droit = pivot->gauche;  // le fils droit devient le fils gauche du pivot
    pivot->gauche = a;  // le fils gauche du pivot devient a
    int equi_a = a->equilibre;  // création d'une variable egale à l'equilibre du pivot
    int equi_p = pivot->equilibre;  // création d'une variable egale à l'equilibre du pivot
    a->equilibre = equi_a - max(equi_p, 0) -1;  // met à jour le facteur d'équilibre du a
    pivot->equilibre = min(min(equi_a-2, equi_a + equi_p -2), equi_p-1);  // met à jour le facteur d'équilibre du pivot
    a = pivot;  // a est égal au pivot 
    return a;  // retourner l'arbre
}

pArbre double_rotation_droit(pArbre a){  // fonction double rotation droite : effectue une double rotation droite sur un nœud AVL
    a->gauche = rotation_gauche(a->gauche);  // effectue une rotation gauche sur le fils gauche
    a = rotation_droite(a);  // rotation droite de a
    return a;  // retourne l'arbre 
}

pArbre double_rotation_gauche(pArbre a){  // fonction double rotation gauche : effectue une double rotation gauche sur un nœud AVL
    a->droit = rotation_droite(a->droit);  // effectue une rotation droite sur le fils droit
    a = rotation_gauche(a);  // rotation gauche de a
    return a;  // retourne l'arbre 
}

pArbre equilibrer_AVL(pArbre a){  // fonction pour équilibrer un nœud AVL si nécessaire après une insertion
    if(a->equilibre >= 2){  // condition si l'equilibre de a est supérieur ou égal à 2
        if(a->droit->equilibre>=0){  // condition si l'equilibre du fils droit de a est supérieur ou égal à 0
            return rotation_gauche(a);  // rotation gauche de a
        }
        else{  // si l'equilibre du fils droit de a est négatif 
            return double_rotation_gauche(a);  // double rotation gauche de a
        }
    }
    else if(a->equilibre<=-2){  // condition si l'équilibre de a inférieur ou égal à -2
        if(a->gauche->equilibre<=0){  // condition si l'equilibre du fils gauche de a est inférieur ou égal à 0
            return rotation_droite(a); // rotation droite de a
        }
        else{  // si l'equilibre du fils gauche de a est positif 
            return double_rotation_droit(a);  // double rotation droite de a
        }
    }
    return a;
}

pArbre insert_AVL(pArbre a, int id, long capa, int* h){  // fonction pour inserer dans un AVL tout en maintenant son équilibre
    if(a==NULL){  // si l'arbre est vide
        *h = 1;  // indique que la hauteur a augmenté
        return creer_arbre(id, capa); // créer un nouveau nœud avec l'id et la capacité
    }
    else if(id <= a->station.id_station){  // insérer à gauche si l'id est inférieur ou égal à celui du nœud courant
        a->gauche = insert_AVL(a->gauche, id, capa, h);  
        *h = -*h;  // ajuste la hauteur
    }
    else if(id >= a->station.id_station){  // insérer à droite si l'id est supérieur à celui du nœud courant
        a->droit = insert_AVL(a->droit, id, capa, h);
    }
    else{  // si l'id est déjà présent, ne rien faire
        *h = 0;
        return a;
    }
    if(*h!=0){  // met à jour l'équilibre si la hauteur a changé
        a->equilibre = a->equilibre + *h;  // ajuste le facteur d'équilibre
        a = equilibrer_AVL(a);  // réequilibre si nécessaire
        if(a->equilibre==0){  // si l'equilibre de a est egal à 0
            *h = 0;  // la hauteur ne change pas
        }
        else{  // si l'equilibre de à est différent de 0
            *h = 1;  // indique que la hauteur a augmenté
        }
    }
    return a;  // retourner l'arbre 
}