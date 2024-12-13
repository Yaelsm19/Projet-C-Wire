afficher_aide() {
    echo "Voici les différents paramètres que vous pouvez remplir"
    echo "parametre 1 : chemin du fichier d'entrée"
    echo "parametre 2 : type de station : hvb ou hva ou lv"
    echo "parametre 3 : type de consommateur : comp ou indiv ou all"
    echo "combinaisons interdites : hvb all ou hdv indiv ou hva all hva indiv"
    echo "parametre 4 : Optionel : identifiant de centrale : 1, 2 ou 3"
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
            exit 1
        fi
    fi

}
nb_args=$#
verification_demande_aide "$@"
chemin_fichier="$1"
type_station=$2
type_conso=$3
id_centrale=$4
verif_tout_arguments
verifier_presence_dossier(){
    if [[ ! -d "tmp" ]]; then
        mkdir tmp
    else
        rm -r tmp/*
    fi
    if [[ ! -d "graphs" ]]; then
        mkdir graphs
    fi
}
verifier_presence_dossier
#(head -n 1 "$chemin_fichier" && grep "1" "$chemin_fichier")

grep -E -e "^[^-]+;[^-]+;-;-;-;-;[^-]+;-" -e "^[^-]+;[^-]+;-;-;[^-]+;-;-;[^-]" "$chemin_fichier" | cut -d ';' -f 2,7,8 | tr "-" "0" >> /workspaces/Projet-C-Wire/tmp/hvb_comp.csv
