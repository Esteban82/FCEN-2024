#!/usr/bin/env bash
clear

#	Temas a ver: 
#	1. Crear grilla a partir de tabla de datos.
#	2. Crear cpt a partir de la grilla (grd2cpt).
#	3. Ver la diferencia entre tabla y grilla de datos.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=26_CrearGrilla_MapaBouguer
	title=$(basename $0 .sh)
	echo $title

#	Tabla de Datos
	TABLA=EIGEN-6C4.gdf

#	Region y proyeccion geografica
	REGION=d
	PROJ=W15c

# 	Archivos creado
#	GRD=tmp_$title.nc
	GRD=Mapa_Bouguer.nc

	gmt set GMT_VERBOSE w

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura.
	gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Ver info de la tabla de datos
#	gmt info $TABLA -h37

#	Crear grilla a partir de tabla de formato gdf. Stepgrid (-I). Lineas de encabezado (-h).
#	Importante: xyz2grd NO grilla (interpola) los datos. Simplemente los reformatea en una grilla.
	gmt xyz2grd -R$REGION $TABLA -h37 -fg -I0.5d -G$GRD		# Formato standard (GMT netCDF format (64-bit float, COARDS, CF-1.5))
#	gmt xyz2grd -R$REGION $TABLA -h37 -fg -I0.5d -G$GRD=ef	# ESRI Arc/Info ASCII Grid Interchange format (ASCII integer)
#	gmt xyz2grd -R$REGION $TABLA -h37 -fg -I0.5d -G$GRD=ei	# ESRI Arc/Info ASCII Grid Interchange format (ASCII float)

#	Extraer informacion de la grilla recortada para determinar rango de CPT
#	gmt grdinfo $GRD

# 	Obtener informacion de la distribución de los datos de la grilla SIN CREAR El CPT (> /dev/null)
	gmt grd2cpt $GRD -V > /dev/null							# Muestra información en la terminal
#	gmt grd2cpt $GRD -V > /dev/null 2> Standard_error.txt	# Guardar en archivo.


#	Crear CPT para optimizar la distribución de los colores segun los valores de la grilla
#	gmt grd2cpt $GRD								# Crea CPT
#	gmt grd2cpt $GRD -V -Z							# Z: CPT continuo
#	gmt grd2cpt $GRD -V -Z -L-200/300				# L: Limitar valores 
#	gmt grd2cpt $GRD -V -Z -L-200/300 -D			# D: extender colores de los extremos
#	gmt grd2cpt $GRD -V -Z -L-200/300 -D -Cjet		# C: CPT maestra
#	gmt grd2cpt $GRD -V -Z -Cred2green				# Su: Simetrica con respecto al 0.
	gmt grd2cpt $GRD -V -Z -Cred2green -Su			# Su: Simetrica con respecto al 0.

#	Graficar grilla
	gmt grdimage $GRD -I

#	Agregar escala de colores
	gmt colorbar -DJRM+o0.3c/0 -C -Ba200+l"Anomalias Bouguer (mGal)" -I

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Bf

#	Dibujar Linea de Costa (W1)
	gmt coast -W1/faint -N1

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

# Borrar archivos temporales
rm tmp_* gmt.conf

#	Ejercicios sugeridos
#	1. Ver las distintas opciones de grd2cpt para crear un CPT.


# Lista de formatos de grillas disponibles en GMT:
# https://docs.generic-mapping-tools.org/latest/reference/features.html#grid-file-format