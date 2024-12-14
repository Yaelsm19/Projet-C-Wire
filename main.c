#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct station{
    int id_station;
    long capacite;
    long somme_conso;
}Station;

typedef struct arbre{
    Station station;
    struct arbre* droit;
    struct arbre* gauche;
    int equilibre;
}Arbre;

typedef Arbre* pArbre;

pArbre creer_arbre(int id, long capa){
    pArbre nouveau = malloc(sizeof(Arbre));
    if(nouveau==NULL){
        printf("Erreur lors de l'allocation mémoire");
        exit(1);
    }
    nouveau->droit =NULL;
    nouveau->gauche = NULL;
    nouveau->station.id_station = id;
    nouveau->station.capacite = capa;
    nouveau->station.somme_conso = 0;
    nouveau->equilibre = 0;
    return nouveau;
 }
int min(int a, int b){
    if(a > b){
        return b;
    }
    return a;
}

int max(int a, int b){
    if(a > b){
        return a;
    }
    return b;
}

pArbre rotation_droite(pArbre a){
    pArbre pivot = a->gauche;
    a->gauche = pivot->droit;
    pivot->droit = a;
    int equi_a = a->equilibre;
    int equi_p = pivot->equilibre;
    a->equilibre = equi_a - min(equi_p, 0) + 1;
    pivot->equilibre = max(max(equi_a+2, equi_a + equi_p +2), equi_p +1);
    a = pivot;
    return a;
}

pArbre rotation_gauche(pArbre a){
    pArbre pivot = a->droit;
    a->droit = pivot->gauche;
    pivot->gauche = a;
    int equi_a = a->equilibre;
    int equi_p = pivot->equilibre;
    a->equilibre = equi_a - max(equi_p, 0) -1;
    pivot->equilibre = min(min(equi_a-2, equi_a + equi_p -2), equi_p-1);
    a = pivot;
    return a;
}

pArbre double_rotation_droit(pArbre a){
    a->gauche = rotation_gauche(a->gauche);
    a = rotation_droite(a);
    return a;
}

pArbre double_rotation_gauche(pArbre a){
    a->droit = rotation_droite(a->droit);
    a = rotation_gauche(a);
    return a;
}

pArbre equilibrer_AVL(pArbre a){
    if(a->equilibre >= 2){
        if(a->droit->equilibre>=0){
            return rotation_gauche(a);
        }
        else{
            return double_rotation_gauche(a);
        }
    }
    else if(a->equilibre<=-2){
        if(a->gauche->equilibre<=0){
            return rotation_droite(a);
        }
        else{
            return double_rotation_droit(a);
        }
    }
    return a;
}

pArbre insert_AVL(pArbre a, int id, long capa, int* h){
    if(a==NULL){
        *h = 1;
        return creer_arbre(id, capa);
    }
    else if(id <= a->station.id_station){
        a->gauche = insert_AVL(a->gauche, id, capa, h);
        *h = -*h;
    }
    else if(id >= a->station.id_station){
        a->droit = insert_AVL(a->droit, id, capa, h);
    }
    else{
        *h = 0;
        return a;
    }
    if(*h!=0){
        a->equilibre = a->equilibre + *h;
        a = equilibrer_AVL(a);
        if(a->equilibre==0){
            *h = 0;
        }
        else{
            *h = 1;
        }
    }
    return a;
}

void afficher_station(Station station){
    printf("\n");
    printf("id : %d, capacite : %ld, consommation : %ld", station.id_station, station.capacite, station.somme_conso);
}

void afficher_AVL(pArbre a){
    if(a!=NULL){
        afficher_AVL(a->gauche);
        afficher_station(a->station);
        afficher_AVL(a->droit);
    }
}

pArbre ajout_consommation_noeud(pArbre a, long consommation, int id_noeud){
    if(a == NULL){
        printf("erreur lors du code");
        exit(1);
    }
    else if(id_noeud < a->station.id_station){
        a->gauche = ajout_consommation_noeud(a->gauche, consommation, id_noeud);
    }
    else if(id_noeud > a->station.id_station){
        a->droit = ajout_consommation_noeud(a->droit, consommation, id_noeud);
    }
    else{
        a->station.somme_conso = a->station.somme_conso + consommation;
    }
    return a;
}

void ecrire(pArbre a, FILE* fichier2){
    if(a!=NULL){
        ecrire(a->gauche, fichier2);
        fprintf(fichier2, "%d;%ld;%ld\n", a->station.id_station, a->station.capacite, a->station.somme_conso);
        ecrire(a->droit, fichier2);
    }
}
int main(int argc, char* argv[]){
     if (argc < 2) {
        printf("Il n'y a pas de fichier en argument.\n");
        return 1;
    }
    FILE * fichier = fopen(argv [1], "r");
    if (fichier == NULL) {
        printf("Impossible d'ouvrir le fichier");
        return 1;
    }
    int id;
    long capacite;
    long consommation;
    pArbre a = NULL;
    int h;
    while(fscanf(fichier, "%d;%ld;%ld", &id, &capacite, &consommation) != EOF){
        if(consommation == 0){
            a = insert_AVL(a, id, capacite, &h);
        }
        else{
            a = ajout_consommation_noeud(a, consommation, id);
        }
    }
    FILE* fichier2 = fopen(argv [2], "a+");
    ecrire(a, fichier2);
    fclose(fichier2);
}