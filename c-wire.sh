

afficher_aide(){
    echo "Voici les différents paramètres que vous pouvez remplir"
    echo "parametre 1 : chemin du fichier d'entrée"
    echo "parametre 2 : type de station : hvb ou hva ou lv"
    echo "parametre 3 : type de consommateur : comp ou indiv ou all
    options interdites : hvb all ou hdv indiv ou hva all hva indiv"
    echo "parametre 4 : Optionelle : identifiant de centrale : filtre les résultats pour une centrale spécifique"
    echo "parametre 5 : Option d’aide (-h)
}
for param in "$@"; do
    if [ "$param" == "-h" ]; then
        afficher_aide
        exit 0 
    fi
done
nb_args=$#
if [ $nb_args -lt 3 ] || [ $nb_args -gt 6];then
    echo "Nombre de paramètres incorrecte"
    afficher_aide
elif [ $nb_args -eq 3 ];then
    echo "c'est bon"
elif [ $nb_args -eq 4 ];then
    echo "c'est bon"
fi

fichier = 'c-wire_v00 (2).dat'
