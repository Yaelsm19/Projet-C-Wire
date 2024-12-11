

nb_args=$#
afficher_aide() {
    echo "Voici les différents paramètres que vous pouvez remplir"
    echo "parametre 1 : chemin du fichier d'entrée"
    echo "parametre 2 : type de station : hvb ou hva ou lv"
    echo "parametre 3 : type de consommateur : comp ou indiv ou all
    options interdites : hvb all ou hdv indiv ou hva all hva indiv"
    echo "parametre 4 : Optionelle : identifiant de centrale : filtre les résultats pour une centrale spécifique"
    echo "parametre 5 : Option d’aide (-h)"
}
verif_3arguments() {
    echo "salut"
    if [ ! -f "$1" ]; then
        echo "Le fichier spécifié n'existe pas ou n'est pas un fichier valide."
        return 1
    elif [ "$1" != *.csv ]; then
        echo "Le fichier spécifié n'est pas un fichier CSV."
        return 1
    elif [ "$2" != "hvb" ] && [ "$2" != "hva" ] && ["$2" != "lv"] ; then
        echo "Le deuxième paramètre n'est pas bon."
        return 1
    elif [ "$3" != "comp" ] && [ "$3" != "indiv" ] && [ "$3" != "all" ]; then
        echo "Le troisième paramètre n'est pas bon."
        return 1
    elif [[ "$2" == "hvb" || "$2" == "hva" ]] && [[ "$3" == "indiv" || "$3" == "all" ]]; then
        echo "Combinaison de paramètres 2 et 3 impossible."
        return 1
    fi
    return 0
}

verif_tout_arguments(){
    for param in "$@"; do
        if [ "$param" == "-h" ]; then
            afficher_aide
            return 1
        fi
    done
    if [ $nb_args -lt 3 ] || [ $nb_args -gt 6 ];then
        echo "Nombre de paramètres incorrect"
        afficher_aide
        return 1
    fi
    resultat=$(verif_3arguments)
    echo "$resultat"
    return 1
}
verif_tout_arguments

