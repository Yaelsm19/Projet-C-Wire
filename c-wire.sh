start=$(date +%s)
afficher_aide() {  #fonction permettant d'afficher différentes aides pour l'utilisateur
    echo "Voici les différents paramètres que vous pouvez remplir" 
    echo "parametre 1 : chemin du fichier d'entrée"
    echo "parametre 2 : type de station : hvb ou hva ou lv"
    echo "parametre 3 : type de consommateur : comp ou indiv ou all"
    echo "combinaisons interdites : hvb all ou hdv indiv ou hva all hva indiv"
    echo "parametre 4 : Optionel : identifiant de centrale : 1, 2, 3, 4 ou 5"
    echo "Le programme a pris $(( $(date +%s) - start )) secondes à s'exécuter." #Affiche le temps d'éxécution du programme
}
verification_demande_aide(){  #fonction permettant de déterminer si l'utilisateur demande de l'aide c'est à dire si l'un des arguments est -h
    for param in "$@"; do  #boucle qui parcours tous les paramètres
        if [ "$param" == "-h" ]; then #condition si le paramètre est égal à -h
            afficher_aide  #appel la fonction afficher_aide
            exit 1  #sortie du programme
        fi
    done
}
verif_3arguments() {  #fonction permettant de vérifier que les trois premiers arguments sont valide
    verification=0  #initialisation de verification à 0
    if [[ ! -f "$chemin_fichier" ]]; then  #vérifie si le paramètre n'est pas un fichier
        echo "Le fichier spécifié n'existe pas ou n'est pas un fichier valide."  #afficher un message d'erreur
        verification=1  #variable verification égal 1
    fi
    if [[ "$chemin_fichier" != *.dat ]]; then  #vérifie si le fichier n'est pas en format.dat
        echo "Le fichier spécifié n'est pas un fichier dat."  #afficher un message d'erreur
        verification=1  #variable verification égal 1
    fi
    if [[ "$type_station" != "hvb" && "$type_station" != "hva" && "$type_station" != "lv" ]] ; then  #condition vérifiant si le type de la station est bien hvb, hva ou lv
        echo "Le deuxième paramètre n'est pas bon."  #afficher un message d'erreur
        verification=1  #variable verification égal 1
    fi
    if [[ "$type_conso" != "comp" && "$type_conso" != "indiv" && "$type_conso" != "all" ]]; then  #condition vérifiant si le type de consommateur est bien comp, indiv ou all
        echo "Le troisième paramètre n'est pas bon."  #afficher un message d'erreur
        verification=1  #variable verification égal 1
    fi
    if [[ "$type_station" == "hvb" || "$type_station" == "hva" ]] && [[ "$type_conso" == "indiv" || "$type_conso" == "all" ]]; then  #condition vérifiant si il n'y a pas de combinaison de paramètre interdite
        echo "Combinaison de paramètres 2 et 3 impossible."  #afficher un message d'erreur
        verification=1  #variable verification égal 1
    fi
    if [[ "$verification" -eq 1 ]]; then  #vérifie si la variable vérification est égal à 1
        afficher_aide  #appel de la fonction afficher aide
        exit 1  #sortie du programme
    fi
}
verif_tout_arguments(){  #fonction vérifiant tous les arguments
    if [[ $nb_args -lt 3 || $nb_args -gt 4 ]];then  #condition vérifiant vérifiant si il y a le bon nombre de paramètre
        echo "Nombre de paramètres incorrect"  #afficher un message d'erreur
        afficher_aide  #appel de la fonction afficher_aide
        exit 1  #sortie du programme
    elif [[ $nb_args -eq 3 ]];then  #vérifie si il y a trois paramètres
        verif_3arguments  #appel de la fontion verif_3arguments
    elif [[ $nb_args -eq 4 ]]; then  #vérifie si il y a quatres paramètres
    verif_3arguments  #appel de la fontion verif_3arguments
        if [[ "$id_centrale" != 1 && "$id_centrale" != 2 && "$id_centrale" != 3 && "$id_centrale" != 4 && "$id_centrale" != 5 ]]; then  #condition vérifiant que l'identifiant de la centrale est correct
            echo "Le quatrième paramètre n'est pas bon"  #afficher un message d'erreur
            afficher_aide  #appel de la fonction afficher aide
            exit 1  #sortie du programme
        fi
    fi

}
verif_presence_dossier(){  #fonction vérifiant que les dossiers tmp et graphs existe
    if [[ ! -d "tmp" ]]; then  #verifie si tmp n'existe pas
        mkdir tmp  #création du dossier tmp
    else  #sinon
        rm -r tmp/*  #suppression du contenu du dossier tmp
    fi
    if [[ ! -d "graphs" ]]; then  #condition si le dossier graphs n'existe pas
        mkdir graphs  #création du dossier graphs
    elif [ "$(ls -A "graphs")" ]; then #Vérifie si le dossier n'est pas vide
        rm -r graphs/*  #suppression du contenu du dossier graphs
    fi
}
trier_fichier_3_parametre(){  #fonction permettant de trier le fichier en fonction des trois premiers paramètres
    if [[ "$type_station" == "hvb" ]]; then  #vérifie si le type de station est hvb
        fichier_final="$(pwd)/tmp/hvb_comp.csv"  #attribution d'un chemin pour le fichier final
        fichier_tmp="$(pwd)/tmp/tmp_hvb_comp.csv"  #attribution d'un chemin pour le fichier tmp
        head -n 1 "$chemin_fichier" | cut -d ';' -f 2,7,8 >> "$fichier_final"  #Garder les colonnes 2,7,8 de la première ligne dans le fichier final
        grep -E -e "^[^-]+;[^-]+;-;-;-;-;[^-]+;-" -e "^[^-]+;[^-]+;-;-;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 2,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 2,7,8 des hvb et des consommateur direct des hvb 
    elif [[ "$type_station" == "hva" ]]; then  #vérifie si le type de station est hva
        fichier_final="$(pwd)/tmp/hva_comp.csv"  #attribution d'un chemin pour le fichier final
        fichier_tmp="$(pwd)/tmp/tmp_hva_comp.csv"  #attribution d'un chemin pour le fichier tmp
        head -n 1 "$chemin_fichier" | cut -d ';' -f 3,7,8 >> "$fichier_final"  #Garder les colonnes 3,7,8 de la première ligne dans le fichier final
        grep -E -e "^[^-]+;[^-]+;[^-]+;-;-;-;[^-]+;-" -e "^[^-]+;-;[^-]+;-;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 3,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 3,7,8 des hva et des consommateur direct des hva 
    elif [[ "$type_station" == "lv" ]]; then  #vérifie si le type de station est lv
        if [[ "$type_conso" == "indiv" ]]; then  #vérifie si le type de consommateur est indiv
            fichier_final="$(pwd)/tmp/lv_indiv.csv"  #attribution d'un chemin pour le fichier final
            fichier_tmp="$(pwd)/tmp/tmp_lv_indiv.csv"  #attribution d'un chemin pour le fichier tmp
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"  #Garder les colonnes 4,7,8 de la première ligne dans le fichier final
            grep -E -e "^[^-]+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^[^-]+;-;-;[^-]+;-;[^-]+;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 4,7,8 des lv et des consommateur indiv des lv 
        elif [[ "$type_conso" == "comp" ]]; then  #vérifie si le type de consommateur est comp
            fichier_final="$(pwd)/tmp/lv_comp.csv"  #attribution d'un chemin pour le fichier final
            fichier_tmp="$(pwd)/tmp/tmp_lv_comp.csv"  #attribution d'un chemin pour le fichier tmp
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"  #Garder les colonnes 4,7,8 de la première ligne dans le fichier final
            grep -E -e "^[^-]+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^[^-]+;-;-;[^-]+;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 4,7,8 des lv et des consommateur comp des lv 
        elif [[ "$type_conso" == "all" ]]; then  #vérifie si le type de consommateur est all
            fichier_final="$(pwd)/tmp/lv_all.csv"  #attribution d'un chemin pour le fichier final
            fichier_tmp="$(pwd)/tmp/tmp_lv_all.csv"  #attribution d'un chemin pour le fichier tmp
            fichier_lv_min_max="$(pwd)/tmp/lv_all_minmax.csv"  #attribution d'un chemin pour le fichier lv_min_max
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"  #Garder les colonnes 4,7,8 de la première ligne dans le fichier final
            grep -E -e "^[^-]+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^[^-]+;-;-;[^-]+;[^-]+;-;-;[^-]" -e "^[^-]+;-;-;[^-]+;-;[^-]+;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 4,7,8 des lv et de tous les consommateurs directs des lv 
        fi
    fi
}
trier_fichier_4_parametre(){ #fonction permettant de trier le fichier en fonction des quatres paramètres
    if [[ "$type_station" == "hvb" ]]; then  #vérifie si le type de station est hvb
        fichier_final="$(pwd)/tmp/hvb_comp_${id_centrale}.csv"  #attribution d'un chemin pour le fichier final
        fichier_tmp="$(pwd)/tmp/tmp_hvb_comp_${id_centrale}.csv"  #attribution d'un chemin pour le fichier tmp
        head -n 1 "$chemin_fichier" | cut -d ';' -f 2,7,8 >> "$fichier_final"  #Garder les colonnes 2,7,8 de la première ligne dans le fichier final
        grep -E -e "^$id_centrale+;[^-]+;-;-;-;-;[^-]+;-" -e "^$id_centrale+;[^-]+;-;-;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 2,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 2,7,8 des hvb et de leurs consommateurs directs pour la centrale choisi
    elif [[ "$type_station" == "hva" ]]; then #vérifie si le type de station est hva
        fichier_final="$(pwd)/tmp/hva_comp_${id_centrale}.csv"  #attribution d'un chemin pour le fichier final
        fichier_tmp="$(pwd)/tmp/tmp_hva_comp_${id_centrale}.csv"  #attribution d'un chemin pour le fichier tmp
        head -n 1 "$chemin_fichier" | cut -d ';' -f 3,7,8 >> "$fichier_final"  #Garder les colonnes 3,7,8 de la première ligne dans le fichier final
        grep -E -e "^$id_centrale+;[^-]+;[^-]+;-;-;-;[^-]+;-" -e "^$id_centrale+;-;[^-]+;-;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 3,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 3,7,8 des hva et de leurs consommateurs directs pour la centrale choisi
    elif [[ "$type_station" == "lv" ]]; then  #vérifie si le type de station est lv
        if [[ "$type_conso" == "indiv" ]]; then  #vérifie si le type de consommateur est indiv
            fichier_final="$(pwd)/tmp/lv_indiv_${id_centrale}.csv"  # Attribution d'un chemin pour le fichier final
            fichier_tmp="$(pwd)/tmp/tmp_lv_indiv_${id_centrale}.csv"  # Attribution d'un chemin pour le fichier temporaire
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"  #Garder les colonnes 4,7,8 de la première ligne dans le fichier final
            grep -E -e "^$id_centrale+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^$id_centrale+;-;-;[^-]+;-;[^-]+;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 4,7,8 des lv et de leurs consommateurs indiv pour la centrale choisi
        elif [[ "$type_conso" == "comp" ]]; then  #vérifie si le type de consommateur est comp
            fichier_final="$(pwd)/tmp/lv_comp_${id_centrale}.csv"  #attribution d'un chemin pour le fichier final
            fichier_tmp="$(pwd)/tmp/tmp_lv_comp_${id_centrale}.csv"  #attribution d'un chemin pour le fichier tmp
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"  #Garder les colonnes 4,7,8 de la première ligne dans le fichier final
            grep -E -e "^$id_centrale+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^$id_centrale+;-;-;[^-]+;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 4,7,8 des lv et de leurs consommateurs comp pour la centrale choisi
        elif [[ "$type_conso" == "all" ]]; then  #vérifie si le type de consommateur est all
            fichier_final="$(pwd)/tmp/lv_all_${id_centrale}.csv"  #attribution d'un chemin pour le fichier final
            fichier_tmp="$(pwd)/tmp/tmp_lv_all_${id_centrale}.csv"  #attribution d'un chemin pour le fichier tmp
            fichier_lv_min_max="$(pwd)/tmp/lv_all_minmax_${id_centrale}.csv"  #attribution d'un chemin pour le fichier lv_min_max
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_lv_min_max"  #Garder les colonnes 4,7,8 de la première ligne dans le fichier lv_min_max
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"  #Garder les colonnes 4,7,8 de la première ligne dans le fichier final
            grep -E -e "^$id_centrale+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^$id_centrale+;-;-;[^-]+;[^-]+;-;-;[^-]" -e "^$id_centrale+;-;-;[^-]+;-;[^-]+;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"  #utilisation des fonctions cut et grep afin de garder uniquement les colonnes 4,7,8 des lv et de tous leurs consommateurs pour la centrale choisi
        fi
    fi
}
tri_fichier(){  #fonction permettant de trier le fichier
    if [[ $nb_args -eq 3 ]]; then  #condition si il y a trois paramètres
        trier_fichier_3_parametre  #appel de la fonction trier_fichier_3_parametre
    elif [[ $nb_args -eq 4 ]]; then  #condtion si il y a quatres paramètres
        trier_fichier_4_parametre  #appel de la fonction trier_fichier_4_parametre
    else  #sinon
        echo "Erreur dans le programme"  #afficher un message d'erreur
        exit 1  #sortie du programme
    fi
    sort -t';' -k3 -n "$fichier_tmp" -o "$fichier_tmp"  #trie du fichier en fonction de la colonnes trois dans l'ordre croissant
    sed -i 's/;/:/g' "$fichier_final" #Remplace les ";" par des ":"
}
creation_lv_min_max() { #creation_lv_min_max
        fichier_tmp_lv_min_max="$(pwd)/tmp/tmp_lv_all_minmax.csv" # Définit le chemin vers un fichier temporaire utilisé pour les calculs et transformations
        fichier_tmp2_lv_min_max="$(pwd)/tmp/tmp2_lv_all_minmax.csv" # Définit le chemin vers un fichier temporaire utilisé pour les calculs et transformations
        if [[ "$(wc -l < "$fichier_final")" -lt 22 ]]; then # Vérifie si le nombre de lignes du fichier final est inférieur ou égal à 21
            awk -F':' '{diff = $3 - $2; abs = (diff < 0) ? -diff : diff; print $0, abs}' OFS=':' "$fichier_final" > "$fichier_tmp_lv_min_max" # Ajoute une quatrième colonne avec la valeur absolue de la différence (|consommation - capacité|)
            { head -n 1 "$fichier_tmp_lv_min_max"; tail -n +2 "$fichier_tmp_lv_min_max" | sort -t':' -k4 -n -r; } > "$fichier_tmp2_lv_min_max" # Trie les lignes du fichier temporaire par la quatrième colonne (différence absolue), en ordre décroissant
            cut -d ':' -f 1,2,3 "$fichier_tmp2_lv_min_max" > "$fichier_lv_min_max" # Garde uniquement les trois premières colonnes (id_station, capacité, consommation) et les écrit dans `fichier_lv_min_max

        else # Si le nombre de lignes du fichier final est supérieur à 21
            { head -n 1 "$fichier_final"; tail -n +2 "$fichier_final" | sort -t':' -k3 -n -r; } > "$fichier_lv_min_max" # Trie les données par la colonne 3 (consommation) en ordre décroissant après la première ligne
            { head -n 11 "$fichier_lv_min_max"; tail -n 10 "$fichier_lv_min_max"; } > "$fichier_tmp_lv_min_max" # Conserve les 11 premières lignes et les 10 dernières lignes dans un fichier temporaire
            awk -F':' '{diff = $3 - $2; abs = (diff < 0) ? -diff : diff; print $0, abs}' OFS=':' "$fichier_tmp_lv_min_max" > "$fichier_lv_min_max" # Ajoute une quatrième colonne avec la valeur absolue de la différence (|consommation - capacité|)
            { head -n 1 "$fichier_lv_min_max"; tail -n +2 "$fichier_lv_min_max" | sort -t':' -k4 -n -r; } > "$fichier_tmp2_lv_min_max" # Trie les lignes du fichier temporaire par la quatrième colonne (différence absolue), en ordre décroissant
            cut -d ':' -f 1,2,3 "$fichier_tmp2_lv_min_max" > "$fichier_lv_min_max" # Garde uniquement les trois premières colonnes et les écrit dans `fichier_lv_min_max
        fi
        rm "$fichier_tmp_lv_min_max" # Supprime le fichier temporaire
        rm "$fichier_tmp2_lv_min_max" # Supprime le fichier temporaire 2
}

creation_fichier_graphique(){
    fichier_graphique_txt="$(pwd)/graphs/gnuplot_donnee.txt"  # Attribution d'un chemin pour le fichier simplifié pour GnuPlot
    # Préparation des données avec `awk` (conserver un en-tête simplifié)
    awk -F':' '
    BEGIN { print "ID Diff Color" > "'"$fichier_graphique_txt"'" }  # Début : ajouter un nouvel en-tête
    NR > 1 && NF == 3 {  # Ignorer la première ligne (en-tête original) et traiter uniquement les lignes valides
        diff = $3 - $2;  # Calcul direct de la différence (positif ou négatif)
        color = (diff > 0) ? "1" : "2";  # Rouge si diff > 0, sinon vert
        printf "%s %d %s\n", $1, diff, color >> "'"$fichier_graphique_txt"'";  # ID, Diff, Color
    }' "$fichier_lv_min_max"

}
creation_graphique() {
    fichier_graphique_png="$(pwd)/graphs/gnuplot_graphique.png" # Définition du chemin pour le fichier PNG qui contiendra le graphique généré

    gnuplot << EOF
    set terminal pngcairo size 1280,720 enhanced font 'Verdana,12' # Définition du terminal de sortie au format PNG avec des dimensions et une police spécifiques
    set output "$fichier_graphique_png" # Chemin de sortie pour le fichier graphique

    set title "Graphique avec toutes les stations" font ",14" # Titre du graphique
    set xlabel "Postes LV (ID Station)" font ",12" # Étiquette de l'axe des abscisses
    set ylabel "Différence (kWh)" font ",12" # Étiquette de l'axe des ordonnées

    set style data histograms # Affichage des données sous forme d'histogrammes
    set style histogram cluster gap 1 # Regroupe les histogrammes avec un espacement de 1 entre les clusters
    set style fill solid border -1 # Remplit les barres avec des couleurs unies et désactive les bordures
    set boxwidth 0.8 # Définit la largeur des barres

    plot "$fichier_graphique_txt" using (column(3) == 1 ? column(2) : NaN):xtic(1) with boxes lc rgb "red" title "Surplus de consommation", \
         "$fichier_graphique_txt" using (column(3) == 2 ? column(2) : NaN):xtic(1) with boxes lc rgb "green" title "Marge d'énergie"
    # Lecture et traçage des données à partir du fichier texte
EOF

    if [ -f "$fichier_graphique_png" ]; then # Vérification si le fichier PNG a été généré avec succès
        echo "Graphique généré avec succès : $fichier_graphique_png" # Message de succès si le fichier existe
    else
        echo "Erreur : Le graphique n'a pas été généré." #Message d'erreur et arrêt du script si le fichier n'a pas été généré
        echo "Le programme a pris $(( $(date +%s) - start )) secondes à s'exécuter." #Affiche le temps d'execution du programme
        exit 1
    fi
}


traitement_lv_all(){
    if [[ "$type_station" == "lv" && "$type_conso" == "all" ]]; then # Vérifie si le type de station est "lv" et le type de consommation est "all"
        creation_lv_min_max # Creer le fichier lv_min_max
        creation_fichier_graphique # Creer le fichier simplifié pourle graphique
        creation_graphique # Permet de créer le graphique
    fi
}
enregistre_resultat(){
    chemindossier="$(pwd)/tests"  # Chemin du dossier cible
    if [ -e "$chemindossier/$(basename "$fichier_final")" ]; then
        echo "Le fichier $(basename "$fichier_final") est déjà présent dans le dossier $chemindossier."
    else
        # Si le fichier n'est pas présent, le copie dans le dossier
        cp "$fichier_final" "$chemindossier"
    fi
    if [[ "$type_station" == "lv" && "$type_conso" == "all" ]]; then # Vérifie si le type de station est "lv" et le type de consommation est "all"
            if [ -e "$chemindossier/$(basename "$fichier_lv_min_max")" ]; then
                echo "Le fichier $(basename "$fichier_lv_min_max") est déjà présent dans le dossier $chemindossier."
            else
            # Si le fichier n'est pas présent, le copie dans le dossier
                cp "$fichier_lv_min_max" "$chemindossier"
            fi
    fi
}

nb_args=$#  # Stocke le nombre d'arguments passés au script dans la variable `nb_args`
verification_demande_aide "$@"  # Vérifie si une demande d'aide est passée en argument (`-h`)
chemin_fichier="$1"  # Stocke le premier argument dans la variable `chemin_fichier`, correspondant au chemin du fichier d'entrée
type_station=$2  # Stocke le deuxième argument dans la variable `type_station`, correspondant au type de station
type_conso=$3  # Stocke le troisième argument dans la variable `type_conso`, correspondant au type de consommation
id_centrale=$4  # Stocke le quatrième argument dans la variable `id_centrale`, correspondant à l'identifiant de la centrale
verif_tout_arguments  # Vérifie que tous les arguments nécessaires sont présents et valides
verif_presence_dossier  # Vérifie la présence des dossiers requis pour le traitement
tri_fichier  # Trie les données du fichier d'entrée selon des critères spécifiques
make -s -C Code_C run ARGS="$fichier_tmp $fichier_final"  # Exécute la commande `make` pour compiler et exécuter le programme C avec des arguments spécifiques
sort -t ':' -k2 -n "$fichier_final" -o "$fichier_final"  # Trie le fichier final par la deuxième colonne en ordre numérique
traitement_lv_all  # Effectue un traitement spécifique pour toutes les stations de type LV
enregistre_resultat
echo "Le programme a pris $(( $(date +%s) - start )) secondes à s'exécuter."  # Affiche le temps total d'exécution du programme
