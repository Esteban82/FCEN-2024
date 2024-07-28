#!/usr/bin/env -S bash -e

# Archivo de entrada. 
# Datos del segemar.
ARCHIVO=e250K.DepositMetalif.csv

# Filtrar depositos segun modelo
# ----------------------------------------
# 0. Ver info con GMT
#gmt info $ARCHIVO -h1
# No funciona. GMT espera columna numericas con texto unicamente en la ultima columna.

# 1. Ver si AWK lee bien el archivo. Imprimir primer columna
#awk '{print $1}' $ARCHIVO | head
# Se ve que toma los espacios como separador de campo. 

# 2. Setear la coma como separador de campo
#awk -F"," '{print $1}' $ARCHIVO | head

# 3. Ver tipos de modelos existentes
#awk -F"," '{print $5}' $ARCHIVO

# 3. ... y ordenar salida
#awk -F"," '{print $5}' $ARCHIVO | sort

# 4. ... y dejar nombres unicos
#awk -F"," '{print $5}' $ARCHIVO | sort | uniq

# 5. Filtrar segun modelo: 04c Cu-Au
#awk -F"," '$5 == "04c Cu-Au"' $ARCHIVO

# Lo mismo pero modelo definido en una variable
#MODELO="04c Cu-Au"
#awk -F"," -v mod="$MODELO" '$5 == mod' $ARCHIVO

# 5. Guardar resultado en un archivo
#awk -F"," '$5 == "04c Cu-Au"' $ARCHIVO > Depositos.txt

# 6. Quedarse con ubicacion
#awk -F"," '$5 == "04c Cu-Au" {print $NF}' $ARCHIVO #> Depositos.txt

# 7. ... y limpiar salida con sed
awk -F"," '$5 == "04c Cu-Au" {print $NF}' $ARCHIVO | sed 's/POINT (//; s/)//'

# 8. ... y graficar los datos con GMT
#awk -F"," '$5 == "04c Cu-Au" {print $NF}' $ARCHIVO | sed 's/POINT (//; s/)//' | gmt plot -Sa0.4c -Gred -png map -Baf -JM10c

# Fuente de datos:
# https://sigam.segemar.gov.ar/geonetwork39/srv/spa/catalog.search#/metadata/edf20fa93001726f635e48a4e10a6065e0ed49b4