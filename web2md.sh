#!/bin/bash

# Comprobar si se proporcionó un archivo
if [ $# -ne 1 ]; then
    echo "Uso: $0 lista_de_urls.txt"
    exit 1
fi

INPUT_FILE=$1
OUTPUT_DIR="descargas_md"
mkdir -p "$OUTPUT_DIR"

echo "--- Iniciando descarga de contenido ---"

while IFS= read -r url || [ -n "$url" ]; do
    # Salta líneas vacías o comentarios
    [[ -z "$url" || "$url" =~ ^# ]] && continue

    echo "Procesando: $url"

    # Generar un nombre de archivo limpio basado en la URL
    filename=$(echo "$url" | sed -E 's/https?:\/\///; s/[^a-zA-Z0-9]/_/g' | cut -c 1-50)
    
    # Descargar y convierte
    curl -sL "$url" | pandoc --from html --to markdown -o "$OUTPUT_DIR/${filename}.md"

    if [ $? -eq 0 ]; then
        echo "Guardado como: $OUTPUT_DIR/${filename}.md"
    else
        echo "Error al procesar: $url"
    fi

done < "$INPUT_FILE"

echo "--- Proceso finalizado ---"
