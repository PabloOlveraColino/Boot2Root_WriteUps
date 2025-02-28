#!/bin/bash
# Este script reemplaza los espacios en los nombres de archivos por guiones bajos

# Activamos nullglob para que no se procese un literal cuando no haya archivos con espacios
shopt -s nullglob

# Recorremos todos los archivos que contengan espacios en su nombre
for file in *" "*; do
    # Creamos el nuevo nombre reemplazando los espacios por guiones bajos
    newname="${file// /_}"
    echo "Renombrando: '$file' -> '$newname'"
    mv -- "$file" "$newname"
done
