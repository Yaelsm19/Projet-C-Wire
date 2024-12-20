#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct station{  // définition de la structure représentant une station
    int id_station;  // identifiant de la station
    long capacite;  // capacite de la station
    long somme_conso;  // somme des consommations associées à cette station
}Station;  

typedef struct arbre{  // définition de la structure d'un nœud d'arbre AVL
    Station station;  // données de la station associée à ce nœud
    struct arbre* droit;  // pointeur vers le fils droit 
    struct arbre* gauche;  // pointeur vers le fils gauche
    int equilibre;  // equilibre arbre
}Arbre;

typedef Arbre* pArbre;  // pointeur arbre

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
    a->gauche = pivot->droit;  // le fils gauche devient le pivot du fils droit
    pivot->droit = a;  // le pivot du fils droit devient a
    int equi_a = a->equilibre;  // création d'une variable égale à l'équilibre de a
    int equi_p = pivot->equilibre;  // création d'une variable égale à l'équilibre du pivot
    a->equilibre = equi_a - min(equi_p, 0) + 1;  // calcul du nouvel equilibre de a
    pivot->equilibre = max(max(equi_a+2, equi_a + equi_p +2), equi_p +1);  // met à jour le facteur d'équilibre du pivot
    a = pivot;  // a  est égal au pivot
    return a;  // retourner l'arbre 
}

pArbre rotation_gauche(pArbre a){  // fonction pour faire une rotation à gauche 
    pArbre pivot = a->droit;  // le pivot devient le fils droit du nœud courant
    a->droit = pivot->gauche;  // le fils droit devient le pivot du fils gauche
    pivot->gauche = a;  // le pivot du fils droit devient a
    int equi_a = a->equilibre;  // création d'une variable egale à l'equilibre du pivot
    int equi_p = pivot->equilibre;  // création d'une variable egale à l'equilibre du pivot
    a->equilibre = equi_a - max(equi_p, 0) -1;  // calcul du nouvel equilibre de a
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
        fprintf(fichier2, "%d:%ld:%ld\n", a->station.id_station, a->station.capacite, a->station.somme_conso);  // écrit les informations du nœud courant dans le fichier (id, capacité, consommation)
        ecrire(a->droit, fichier2);  // appel récursif pour parcourir le sous-arbre droit
        free(a);  // libère la mémoire allouée pour le nœud courant
    }
}

int verifier_nb_argument(int argc){  // fonction pour vérifier si le programme reçoit le bon nombre d'arguments
    if (argc != 3){  // vérifie si le nombre d'arguments est différent de 3 
        printf("Il n'y a pas le bon nombre d'argument");  // message d'erreur 
        return 0;  // retourne 0 pour signaler une erreur
    }
    return 1;  // retourne 1 si le nombre d'arguments est correct

}

pArbre recuperer_fichier_tmp(FILE* fichier){  // fonction pour construire un arbre AVL à partir d'un fichier temporaire
    int id;  // identifiant de la station
    long capacite;  // capacité de la station
    long consommation;  // consommation de la station 
    int h = 0;  // variable pour gérer la hauteur lors de l'insertion dans l'AVL
    pArbre a = NULL;  // initialise un arbre vide
    while(fscanf(fichier, "%d;%ld;%ld", &id, &capacite, &consommation) != EOF){  // lit une ligne du fichier jusqu'à la fin (EOF) au format id;capacité;consommation
        if(consommation == 0){  // si la consommation est 0
            a = insert_AVL(a, id, capacite, &h);  // ajoute un nouveau nœud dans l'AVL
        }
        else{  // sinon
            a = ajout_consommation_noeud(a, consommation, id);  // ajoute la consommation à un nœud existant dans l'arbre
        }
    }
    return a;  // retourne l'arbre construit
}

void traitement_total(FILE* fichier_tmp, FILE* fichier_final){  // fonction pour traiter un fichier temporaire et écrire le résultat dans un fichier final
    pArbre a = NULL;  // initialise un arbre vide
    a = recuperer_fichier_tmp(fichier_tmp);  // construit l'arbre à partir du fichier temporaire
    ecrire(a, fichier_final);  // écrit les données de l'arbre dans le fichier final
}

int main(int argc, char* argv[]){  // fonction principale du programme
    if(!verifier_nb_argument(argc)){  // vérifie si le nombre d'arguments est correct
        exit (1);  // quitte le programme en cas d'erreur
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