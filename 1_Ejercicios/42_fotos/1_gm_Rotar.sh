#!/bin/bash

# Usar graphicsmagick
# ---------------------------------------------------------------------
# 1. Rotar una imagen 
# Sintaxis basica para un unico archivo
gm convert fotos/Snap-400.jpg -rotate 90 Snap-400_rotada.jpg


# 2. Rotar todas las imagenes en un directorio
# Directorio donde están las imágenes
DIR="fotos"

# Ángulo de rotación
ANGULO=90

# Extensión de las imágenes (ej. jpg, png)
EXT="jpg"

# Recorrer cada archivo en el directorio con la extensión especificada
for FOTO in "$DIR"/*."$EXT"; do
    # Obtener el nombre base del archivo sin la extensión
    NOMBRE=$(basename $FOTO .$EXT)

    # Definir el nuevo nombre del archivo rotado
    NUEVO_NOMBRE="${NOMBRE}_rotada.${EXT}"

    # Rotar la imagen y guardar con el nuevo nombre
    echo "Rotando $FOTO"
    gm convert "$FOTO" -rotate "$ANGULO" "$DIR/${NUEVO_NOMBRE}"
done