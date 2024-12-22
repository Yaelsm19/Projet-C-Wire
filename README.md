# Projet-C-Wire

## Partie shell 

### Prérequis

- Bash (version 4.0 ou supérieure)
- Gnuplot pour la génération des graphiques
- Autorisations de lecture/écriture pour créer les dossiers `tmp` et `graphs`
- Ajouter le fichier à traiter dans le dossier input

---

### Description du projet

Ce programme Shell traite des fichiers de données au format `.dat`. Il permet de vérifier la validité des entrées utilisateur, de trier les données en fonction de différents paramètres et de les organiser dans des fichiers spécifiques pour une utilisation ultérieure.

---

### Fonctionnalités principales 

1. **Vérification des Paramètres** :
   - Le programme vérifie que les fichiers fournis existent et qu’ils ont l'extension`.dat`: 
   - Il valide les paramètres relatifs aux types de stations et de consommateurs.
   - Il gère les combinaisons interdites entre les paramètres.
   - Le programme vérifie que le nombre d'arguments fournis est correct (3 ou 4).

2. **Aide à l'Utilisation** :
   - Le programme fournit une description des paramètres via l'option `-h`.

3. **Gestion des Dossiers Temporaires** :
   - Le programme crée ou réinitialise les dossiers `tmp` et `graphs` pour organiser les fichiers temporaires et les résultats.

4. **Tri des Données** :
   - Les données sont triées dans des fichiers spécifiques en fonction des types de stations et de consommateurs.
   - Le tri peut se faire avec ou sans identifiant de centrale. 


---
### Structure attendue des fichiers `.dat`

Les fichiers doivent suivre cette structure :
- Colonne 1 : Identifiant (nombre entier)
- Colonne 2 : Type de station (hvb, hva, lv)
- Colonne 3 : Type de consommateur (comp, indiv, all)
- Colonne 4 : Capacité (nombre entier)
- Colonne 5 : Consommation (nombre entier)

Les colonnes doivent être séparées par des points-virgules (`;`).

---

### Structure des arguments

Le programme accepte entre 3 et 4 arguments :

1. **Paramètre 1** : Chemin du fichier d'entrée (doit être un fichier `.dat`).
2. **Paramètre 2** : Type de station (“hvb”, “hva” ou “lv”).
3. **Paramètre 3** : Type de consommateur (“comp”, “indiv” ou “all”).
4. **Paramètre 4 (Optionnel)** : Identifiant de centrale (valeurs possibles : 1, 2, 3, 4 ou 5).

**Combinaisons interdites** :
- `hvb` avec `all` ou `indiv`
- `hva` avec `all` ou `indiv`

---

### Utilisation

#### Exécution du programme

```bash
./c-wire.sh chemin_fichier type_station type_conso [id_centrale]
```

#### Demander l’aide

```bash
./c-wire.sh -h
```

### Exemple d’Exécution

1. Avec 3 paramètres :
   ```bash
   ./c-wire.sh "/workspaces/Projet-C-Wire/input/c-wire_v25.dat" hvb comp
   ```

2. Avec 4 paramètres :
   ```bash
   ./c-wire.sh "/workspaces/Projet-C-Wire/input/c-wire_v25.dat" lv indiv 1
   ```

---

### Détails des fonctions

#### Fonction : `afficher_aide()`
- Affiche une aide détaillée sur la syntaxe de la commande et les paramètres disponibles.
- Liste les combinaisons interdites pour éviter les erreurs courantes.
- Exemple de sortie :
  ```
  Utilisation : ./c-wire.sh c-wire_v25.dat type_station type_consommateur [id_centrale]
  - type_station : hvb, hva, lv
  - type_consommateur : comp, indiv, all
  ```

#### Fonction : `verification_demande_aide()`
- Vérifie si l'option `-h` est présente parmi les arguments.
- Si l'option est trouvée, affiche l'aide et interrompt l'exécution.

#### Fonction : `verif_3arguments()`
- Vérifie les trois premiers arguments fournis par l'utilisateur :
  1. Vérifie que le fichier d'entrée existe et a l'extension `.dat`.
  2. Valide le type de station (doit être “hvb”, “hva” ou “lv”).
  3. Valide le type de consommateur (doit être “comp”, “indiv” ou “all”).
- En cas d'erreur, affiche un message descriptif et arrête l'exécution.

#### Fonction : `verif_tout_arguments()`
- Vérifie que le nombre total d'arguments fournis est correct (il doit avoir entre 3 et 4 arguments).
- Si 4 arguments sont présents, valide également l'identifiant de centrale (qui doit être 1, 2, 3, 4 ou 5).
- Appelle la fonction appropriée (`verif_3arguments` ou `verif_4arguments`) pour effectuer les vérifications détaillées selon le nombre d'arguments.

#### Fonction : `verifier_presence_dossier()`
- Vérifie la présence des dossiers `tmp` et `graphs` nécessaires au programme.
- Supprime les dossiers existants pour éviter les conflits avec des fichiers temporaires précédents.
- Crée les dossiers s'ils n'existent pas.
- Exemple de commande utilisée :
  ```bash
  rm -rf tmp graphs
  mkdir tmp graphs
  ```

#### Fonction : `trier_fichier_3_parametre()`
- Trie les lignes du fichier d'entrée en fonction des trois premiers paramètres.
- Utilise des outils comme `grep` et `cut` pour extraire les données pertinentes.
- Enregistre les données triées dans des fichiers spécifiques dans le dossier `tmp/`.
- Exemple :
  ```bash
  grep "hvb;comp" "/workspaces/Projet-C-Wire/c-wire_v25.dat" > tmp/hvb_comp.dat
  ```

#### Fonction : `trier_fichier_4_parametre()`
- Trie les lignes du fichier d'entrée en fonction des quatre paramètres (y compris l'identifiant de centrale).
- Ajoute un niveau de précision supplémentaire au tri par rapport à `trier_fichier_3_parametre`.
- Enregistre les résultats dans des fichiers nommés selon les quatre paramètres dans le dossier `tmp/`.

#### Fonction : `tri_fichier()`
- Détermine automatiquement s'il faut utiliser `trier_fichier_3_parametre` ou `trier_fichier_4_parametre` en fonction du nombre d'arguments fournis.
- Sert de point d'entrée pour les opérations de tri.

#### Fonction : `creation_lv_min_max()`
- Traite un fichier CSV contenant des informations sur des stations (identifiant, capacité, consommation) pour produire un fichier trié et analysé.

#### Fonction : `creation_fichier_graphique()`
- Cette fonction prépare un fichier de données simplifié pour générer des graphiques avec GnuPlot à partir des informations sur les stations.

#### Fonction : `creation_graphique()`
- Cette fonction génère un graphique en format PNG à partir des données de stations, en visualisant les écarts de consommation avec des codes couleur.

#### Fonction : `traitement_lv_all()` 
- Cette fonction exécute le traitement complet pour les stations de type "LV" avec une consommation "all".
 1. Vérifie que type_station est "lv" et type_conso est "all".
 2. Lance les fonctions suivantes :
   - `creation_lv_min_max` : Analyse et trie les données.
   - `creation_fichier_graphique` : Prépare les données pour GnuPlot.
   - `creation_graphique` : Génère un graphique des écarts de consommation.
 3. Automatise l’analyse et la visualisation des données des stations LV.

---

### Processus d'exécution du programme

Le programme suit les étapes suivantes pour traiter les fichiers et générer les résultats :

 1. Vérification des Arguments :
    -Le script commence par vérifier le nombre d'arguments fournis avec la commande. Il valide également si des options d'aide sont demandées (par exemple, `-h`).
 2. Récupération des Paramètres :
   Les paramètres nécessaires sont extraits des arguments fournis, tels que le chemin du fichier, le type de station, le type de consommateur, et l'identifiant de la centrale.
 3. Vérification de la Présence des Dossiers :
   - Le programme vérifie si les dossiers nécessaires pour le traitement des fichiers existent (par exemple, `tmp` et `graphs`). Si ces dossiers n'existent pas, ils sont créés.
 4. Tri des Données :
   - Le fichier de données est trié par station et consommateur, et les résultats sont enregistrés dans un fichier temporaire.
 5. Exécution du Code C :
   - Le programme exécute un code C pour effectuer des traitements supplémentaires (par exemple, calcul des consommations ou des capacités).
 6. Tri Final et Résultats :
   - Après l'exécution du code C, les résultats sont triés à nouveau en fonction de certains critères (par exemple, le type de station).
 7. Calcul du Temps d'Exécution :
   - Enfin, le programme affiche le temps d'exécution total du processus.

---

### Structure des fichiers et répertoires

#### Fichier d’entrée
Le fichier `.dat` doit être structuré avec des colonnes séparées par un caractère délimiteur.

#### Dossier généré

- **tmp/** : Contient les fichiers temporaires pour le tri.


### Gestion des erreurs

Le programme signale les erreurs suivantes :
- **Fichier non trouvé** : Si le fichier d’entrée n’existe pas.
- **Extension incorrecte** : Si le fichier n’a pas l’extension `.dat`.
- **Paramètres invalides** : Si un type de station ou de consommateur est incorrect.
- **Combinaisons interdites** : Si une combinaison comme `hvb` avec `all` est fournie.

---

## Partie langage C 

### Description du projet

Ce programme utilise un arbre binaire de recherche équilibré (AVL) pour gérer un ensemble de stations en enregistrant leur capacité et leur consommation. Il permet d'ajouter de nouvelles stations, de modifier la consommation des stations existantes et d'afficher les données sous la forme d'un arbre AVL équilibré.

---

### Fonctionnalités principales

1. **Insertion de Stations** :
   - Les stations sont insérées dans l'arbre AVL en fonction de leur identifiant `id_station`
   - L'arbre se rééquilibre automatiquement après chaque insertion pour rester équilibré.

2. **Gestion de la Consommation** :
   - On peut ajouter de la consommation à une station existante en utilisant son identifiant. La somme des consommations est mise à jour en conséquence.

3. **Affichage des Stations** :
   - Le programme affiche les informations de chaque station de l'arbre AVL (identifiant, capacité, consommation totale) en parcourant l'arbre en ordre infixe.

4. **Rééquilibrage AVL** :
   - Le programme utilise des rotations simples et doubles pour rééquilibrer l'arbre après chaque insertion.

--- 

### Bibliothèques utilisées 

- <stdio.h>
- <stdlib.h>
- <string.h>
- "structures.h"
- "avl_file_operations.h"

---

### Structure des données 

#### Station
Cette structure représente une station avec les informations suivantes :
- `id_station`: Identifiant unique de la station.
- `capacite`: Capacité de la station.
- `somme_conso`: Somme des consommations de la station.

#### Arbre
L'arbre binaire de recherche est structuré de manière suivante :
- `station`: Contient les informations d'une station.
- `droit`: Pointeur vers le sous-arbre droit.
- `gauche`: Pointeur vers le sous-arbre gauche.
- `equilibre`:  Indicateur d'équilibre de l'arbre (utilisé pour les rotations).

--- 

### Fonctions principales 

#### `avl_operation.c`

##### Fonction : `creer_arbre()`
- Crée un nouvel arbre AVL avec une station d'identifiant `id` et de capacité `capa`. Le programme alloue dynamiquement la mémoire nécessaire pour l'arbre.

##### Fonctions : `min()` et `max()`
- Fonctions utilitaires qui retournent respectivement le minimum et le maximum de deux valeurs entières.

##### Fonctions : `rotation_droite()` et `rotation_gauche()`
- Effectuent respectivement une rotation droite et une rotation gauche pour rééquilibrer l'arbre. Ces rotations sont utilisées dans l'algorithme AVL pour maintenir l'équilibre après des insertions.

##### Fonctions : `double_rotation_droit()` et `double_rotation_gauche()`
- Effectuent des rotations doubles pour rééquilibrer l'arbre lorsque c'est nécessaire.

Les rotations simples et doubles sont utilisées pour maintenir l'équilibre de l'arbre AVL. Cela permet d'assurer des performances optimales pour les opérations d'insertion et de recherche. En effet, ces rotations sont nécessaires pour garantir que l'arbre reste équilibré et que les opérations sur l'arbre se réalisent en temps logarithmique O(log n).

##### Fonction : `equilibrer_AVL()`
- Équilibre l'arbre AVL après une insertion en appliquant les rotations nécessaires.

##### Fonction : `insert_AVL()`
- Insère une nouvelle station dans l'arbre AVL et met à jour l'équilibre de l'arbre. La fonction renvoie l'arbre rééquilibré.

#### `avl_file_operation_c` : 

##### Fonction : `ajout_consommation_noeud()` 
- Ajoute la consommation à une station existante identifiée par son `id_noeud` . Si le noeud n'existe pas, il parcourt l'arbre pour l'ajouter ou met à jour la consommation de la station correspondante.

##### Fonction : `ecrire()` 
- Écrit les données de l'arbre AVL (ID, capacité, consommation) dans un fichier, en parcourant l'arbre récursivement.

##### Fonction : `recuperer_fichier_tmp ()`
- Lit un fichier contenant des données de stations et construit un arbre AVL. Si la consommation est nulle, un nouveau nœud est ajouté, sinon la consommation est mise à jour dans l'arbre existant.

##### Fonction : `traitement_total()`
- Lit un fichier temporaire pour construire un arbre AVL et écrit les résultats dans un fichier final.

--- 

### Exemple d'utilisation

Pour exécuter le programme, il suffit de passer un fichier d'entrée contenant les stations et un fichier de sortie où les résultats seront écrits. Exemple d'exécution : ./programme fichier_temporaire.txt fichier_final.txt
Dans cet exemple, `fichier_temporaire.txt` contient les données des stations à charger dans l'arbre AVL, et `fichier_final.txt` recevra les résultats après le traitement.

### Structure des Fichiers

Le programme lit les données depuis un fichier d'entrée (fichier temporaire) et écrit les résultats dans un fichier de sortie (fichier final). La gestion de ces fichiers se fait via des fonctions spécifiques. Les données sont traitées en mémoire grâce aux structures de données, et les fichiers servent uniquement à l'entrée et à la sortie des informations.

---

### Gestion des Erreurs

Le programme signale les erreurs suivantes :
- **Erreur d'allocation mémoire** : Si l'allocation mémoire pour un nouvel arbre échoue.
- **Erreur d'ouverture de fichier** : Si un fichier d'entrée ou de sortie ne peut pas être ouvert, un message d'erreur est affiché et le programme se termine.
- **Erreur lors de l'ajout de consommation** : Si une station n'est pas trouvée lors de l'ajout de consommation. Le programme tentera de la parcourir dans l'arbre ou mettra à jour les informations si elle existe déjà.