start=$(date +%s)
afficher_aide() {
    echo "Voici les différents paramètres que vous pouvez remplir"
    echo "parametre 1 : chemin du fichier d'entrée"
    echo "parametre 2 : type de station : hvb ou hva ou lv"
    echo "parametre 3 : type de consommateur : comp ou indiv ou all"
    echo "combinaisons interdites : hvb all ou hdv indiv ou hva all hva indiv"
    echo "parametre 4 : Optionel : identifiant de centrale : 1, 2, 3, 4 ou 5"
    echo "Le programme a pris $(( $(date +%s) - start )) secondes à s'exécuter."
}
verification_demande_aide(){
    for param in "$@"; do
        if [ "$param" == "-h" ]; then
            afficher_aide
            exit 1
        fi
    done
}
verif_3arguments() {
    verification=0
    if [[ ! -f "$chemin_fichier" ]]; then
        echo "Le fichier spécifié n'existe pas ou n'est pas un fichier valide."
        verification=1
    fi
    if [[ "$chemin_fichier" != *.dat ]]; then
        echo "Le fichier spécifié n'est pas un fichier dat."
        verification=1
    fi
    if [[ "$type_station" != "hvb" && "$type_station" != "hva" && "$type_station" != "lv" ]] ; then
        echo "Le deuxième paramètre n'est pas bon."
        verification=1
    fi
    if [[ "$type_conso" != "comp" && "$type_conso" != "indiv" && "$type_conso" != "all" ]]; then
        echo "Le troisième paramètre n'est pas bon."
        verification=1
    fi
    if [[ "$type_station" == "hvb" || "$type_station" == "hva" ]] && [[ "$type_conso" == "indiv" || "$type_conso" == "all" ]]; then
        echo "Combinaison de paramètres 2 et 3 impossible."
        verification=1
    fi
    if [[ "$verification" -eq 1 ]]; then
        afficher_aide
        exit 1
    fi
}
verif_tout_arguments(){
    if [[ $nb_args -lt 3 || $nb_args -gt 4 ]];then
        echo "Nombre de paramètres incorrect"
        afficher_aide
        exit 1
    elif [[ $nb_args -eq 3 ]];then
        verif_3arguments
    elif [[ $nb_args -eq 4 ]]; then
    verif_3arguments
        if [[ "$id_centrale" != 1 && "$id_centrale" != 2 && "$id_centrale" != 3 && "$id_centrale" != 4 && "$id_centrale" != 5 ]]; then
            echo "Le quatrième paramètre n'est pas bon"
            afficher_aide
            exit 1
        fi
    fi

}
verif_presence_dossier(){
    if [[ ! -d "tmp" ]]; then
        mkdir tmp
    else
        rm -r tmp/*
    fi
    if [[ ! -d "graphs" ]]; then
        mkdir graphs
    fi
}
trier_fichier_3_parametre(){
    if [[ "$type_station" == "hvb" ]]; then
        fichier_final="/workspaces/Projet-C-Wire/tmp/hvb_comp.csv"
        fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_hvb_comp.csv"
        head -n 1 "$chemin_fichier" | cut -d ';' -f 2,7,8 >> "$fichier_final"
        grep -E -e "^[^-]+;[^-]+;-;-;-;-;[^-]+;-" -e "^[^-]+;[^-]+;-;-;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 2,7,8 | tr "-" "0" >> "$fichier_tmp"
    elif [[ "$type_station" == "hva" ]]; then
        fichier_final="/workspaces/Projet-C-Wire/tmp/hva_comp.csv"
        fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_hva_comp.csv"
        head -n 1 "$chemin_fichier" | cut -d ';' -f 3,7,8 >> "$fichier_final"
        grep -E -e "^[^-]+;[^-]+;[^-]+;-;-;-;[^-]+;-" -e "^[^-]+;-;[^-]+;-;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 3,7,8 | tr "-" "0" >> "$fichier_tmp"
    elif [[ "$type_station" == "lv" ]]; then
        if [[ "$type_conso" == "indiv" ]]; then
            fichier_final="/workspaces/Projet-C-Wire/tmp/lv_indiv.csv"
            fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_lv_indiv.csv"
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"
            grep -E -e "^[^-]+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^[^-]+;-;-;[^-]+;-;[^-]+;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"
        elif [[ "$type_conso" == "comp" ]]; then
            fichier_final="/workspaces/Projet-C-Wire/tmp/lv_comp.csv"
            fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_lv_comp.csv"
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"
            grep -E -e "^[^-]+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^[^-]+;-;-;[^-]+;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"
        elif [[ "$type_conso" == "all" ]]; then
            fichier_final="/workspaces/Projet-C-Wire/tmp/lv_all.csv"
            fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_lv_all.csv"
            fichier_lv_min_max="/workspaces/Projet-C-Wire/tmp/lv_all_minmax.csv"
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"
            grep -E -e "^[^-]+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^[^-]+;-;-;[^-]+;[^-]+;-;-;[^-]" -e "^[^-]+;-;-;[^-]+;-;[^-]+;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"
        fi
    fi
}
trier_fichier_4_parametre(){
    if [[ "$type_station" == "hvb" ]]; then
        fichier_final="/workspaces/Projet-C-Wire/tmp/hvb_comp.csv"
        fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_hvb_comp.csv"
        head -n 1 "$chemin_fichier" | cut -d ';' -f 2,7,8 >> "$fichier_final"
        grep -E -e "^$id_centrale+;[^-]+;-;-;-;-;[^-]+;-" -e "^$id_centrale+;[^-]+;-;-;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 2,7,8 | tr "-" "0" >> "$fichier_tmp"
    elif [[ "$type_station" == "hva" ]]; then
        fichier_final="/workspaces/Projet-C-Wire/tmp/hva_comp.csv"
        fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_hva_comp.csv"
        head -n 1 "$chemin_fichier" | cut -d ';' -f 3,7,8 >> "$fichier_final"
        grep -E -e "^$id_centrale+;[^-]+;[^-]+;-;-;-;[^-]+;-" -e "^$id_centrale+;-;[^-]+;-;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 3,7,8 | tr "-" "0" >> "$fichier_tmp"
    elif [[ "$type_station" == "lv" ]]; then
        if [[ "$type_conso" == "indiv" ]]; then
            fichier_final="/workspaces/Projet-C-Wire/tmp/lv_indiv.csv"
            fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_lv_indiv.csv"
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"
            grep -E -e "^$id_centrale+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^$id_centrale+;-;-;[^-]+;-;[^-]+;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"
        elif [[ "$type_conso" == "comp" ]]; then
            fichier_final="/workspaces/Projet-C-Wire/tmp/lv_comp.csv"
            fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_lv_comp.csv"
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"
            grep -E -e "^$id_centrale+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^$id_centrale+;-;-;[^-]+;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"
        elif [[ "$type_conso" == "all" ]]; then
            fichier_final="/workspaces/Projet-C-Wire/tmp/lv_all.csv"
            fichier_tmp="/workspaces/Projet-C-Wire/tmp/tmp_lv_all.csv"
            fichier_lv_min_max="/workspaces/Projet-C-Wire/tmp/lv_all_minmax.csv"
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_lv_min_max"
            head -n 1 "$chemin_fichier" | cut -d ';' -f 4,7,8 >> "$fichier_final"
            grep -E -e "^$id_centrale+;-;[^-]+;[^-]+;-;-;[^-]+;-" -e "^$id_centrale+;-;-;[^-]+;[^-]+;-;-;[^-]" -e "^$id_centrale+;-;-;[^-]+;-;[^-]+;-;[^-]" "$chemin_fichier" | cut -d ';' -f 4,7,8 | tr "-" "0" >> "$fichier_tmp"
        fi
    fi
}
tri_fichier(){
    if [[ $nb_args -eq 3 ]]; then
        trier_fichier_3_parametre
    elif [[ $nb_args -eq 4 ]]; then
        trier_fichier_4_parametre
    else
        echo "Erreur dans le programme"
        exit 1
    fi
    sort -t';' -k3 -n "$fichier_tmp" -o "$fichier_tmp"
}
creation_lv_min_max(){
    if [[ "$type_station" == "lv" && "$type_conso" == "all" ]]; then
        fichier_tmp_lv_min_max="/workspaces/Projet-C-Wire/tmp/tmp_lv_all_minmax.csv"
        if [[ "$(wc -l < "$fichier_final")" -lt 22 ]]; then
            awk -F':' '{diff = $3 - $2; abs = (diff < 0) ? -diff : diff; print $0, abs}' OFS=':' "$fichier_final" > "$fichier_tmp_lv_min_max"
            sort -t ":" -k4 -n "$fichier_tmp_lv_min_max" -o "$fichier_tmp_lv_min_max"
            cut -d ':' -f 1,2,3 "$fichier_tmp_lv_min_max" > $fichier_lv_min_max

            
        else
            { head -n 1 "$fichier_final"; tail -n +2 "$fichier_final" | sort -t';' -k3 -n -r; } > "$fichier_lv_min_max"
            { head -n 11 "$fichier_lv_min_max"; tail -n 10 "$fichier_lv_min_max"; } > "$fichier_tmp_lv_min_max"
            awk -F':' '{diff = $3 - $2; abs = (diff < 0) ? -diff : diff; print $0, abs}' OFS=':' "$fichier_tmp_lv_min_max" > "$fichier_lv_min_max"
            sort -t ":" -k4 -n "$fichier_lv_min_max" > "$fichier_tmp_lv_min_max"
            cut -d ':' -f 1,2,3 "$fichier_tmp_lv_min_max" > "$fichier_lv_min_max"     
        fi
        rm "$fichier_tmp_lv_min_max"
    fi
}

nb_args=$#
verification_demande_aide "$@"
chemin_fichier="$1"
type_station=$2
type_conso=$3
id_centrale=$4
verif_tout_arguments
verif_presence_dossier
tri_fichier
sed -i 's/;/:/g' "$fichier_final"
make run ARGS="$fichier_tmp $fichier_final"
sort -t ':' -k2 -n "$fichier_final" -o "$fichier_final"
creation_lv_min_max
echo "Le programme a pris $(( $(date +%s) - start )) secondes à s'exécuter."
