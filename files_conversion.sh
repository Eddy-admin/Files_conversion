#!/bin/bash

DOSSIER_CIBLE="$PWD"

# Répertoire à surveiller
read -p "Sélectionnez le répertoire dont les fichiers doivent être convertis, par défaut ($PWD) : " DOSSIER_CHOISI

if [[ -e "$DOSSIER_CHOISI" ]]; then 
        DOSSIER_CIBLE="$DOSSIER_CHOISI"
fi

# Fonction pour convertir DOCX en PDF
convertir_docx_en_pdf() {
    local fichier_a_convertir="$1"
    local fichier_converti="${fichier_a_convertir%.docx}.pdf"
    echo "Conversion de $fichier_a_convertir en $fichier_converti..."
    libreoffice --headless --convert-to pdf "$fichier_a_convertir" --outdir "$(dirname "$fichier_a_convertir")"
}

# Fonction pour convertir PNG en JPG
convertir_png_en_jpg() {
    local fichier_a_convertir="$1"
    local fichier_converti="${fichier_a_convertir%.png}.jpg"
    echo "Conversion de $fichier_a_convertir en $fichier_converti..."
    convert "$fichier_a_convertir" "$fichier_converti"
}

# Fonction pour convertir PNG en PDF
convertir_png_en_pdf() {
    local fichier_a_convertir="$1"
    local fichier_converti="${fichier_a_convertir%.png}.pdf"
    echo "Conversion de $fichier_a_convertir en $fichier_converti..."
    convert "$fichier_a_convertir" "$fichier_converti"
}

# Fonction pour convertir CSV en XLSX
convertir_csv_en_xlsx() {
    local fichier_a_convertir="$1"
    local fichier_converti="${fichier_a_convertir%.csv}.xlsx"
    echo "Conversion de $fichier_a_convertir en $fichier_converti..."
    csvformat -X "$fichier_a_convertir" > "$fichier_converti"
}

choisir_conversion() {
    local fichier="$1"
    local extension="${fichier##*.}"

    case "$extension" in
        docx)
            echo "Choisissez le type de conversion pour le fichier $fichier :"
            echo "1) DOCX en PDF"
            echo "2) Ignorer ce fichier"
            read -p "Votre choix (1-2) : " choix

            case "$choix" in
                1) convertir_docx_en_pdf "$fichier" ;;
                2) echo "Fichier ignoré." ;;
                *) echo "Choix invalide, fichier ignoré." ;;
            esac
            ;;
        
        png)
            echo "Choisissez le type de conversion pour le fichier $fichier :"
            echo "1) PNG en JPG"
            echo "2) PNG en PDF"
            echo "3) Ignorer ce fichier"
            read -p "Votre choix (1-3) : " choix

            case "$choix" in
                1) convertir_png_en_jpg "$fichier" ;;
                2) convertir_png_en_pdf "$fichier" ;;
                3) echo "Fichier ignoré." ;;
                *) echo "Choix invalide, fichier ignoré." ;;
            esac
            ;;
        
        csv)
            echo "Choisissez le type de conversion pour le fichier $fichier :"
            echo "1) CSV en XLSX"
            echo "2) Ignorer ce fichier"
            read -p "Votre choix (1-2) : " choix

            case "$choix" in
                1) convertir_csv_en_xlsx "$fichier" ;;
                2) echo "Fichier ignoré." ;;
                *) echo "Choix invalide, fichier ignoré." ;;
            esac
            ;;
        
        *)
            echo "Aucune conversion disponible pour l'extension .$extension. Fichier ignoré."
            ;;
    esac
}

for fichier in "$DOSSIER_CIBLE"/*; do
    if [[ -f "$fichier" ]]; then
        choisir_conversion "$fichier"
    fi
done

echo "Processus de conversion terminé pour tous les fichiers dans $DOSSIER_CIBLE."
