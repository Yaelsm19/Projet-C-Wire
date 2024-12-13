#include <stdio.h>
#include <stdlib.h>

typedef struct station{
    int id_station;
    int capacite;
    int somme_conso;
}Station;

typedef struct arbre{
    Station station;
    struct arbre* droit;
    struct arbre* gauche;
    int equilibre;
}Arbre;

typedef Arbre* pArbre;

pArbre creer_arbre(int id, int capa){
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

pArbre insert_AVL(pArbre a, int id, int capa, int* h){
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
    printf("id : %d, capacite : %d, consommation : %d", station.id_station, station.capacite, station.somme_conso);
}

void afficher_AVL(pArbre a){
    if(a!=NULL){
        afficher_station(a->station);
        afficher_AVL(a->droit);
        afficher_AVL(a->gauche);
    }
}
int main(int argc, char* argv){
    
}