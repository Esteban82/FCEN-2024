#!/usr/bin/env bash
#
# Script adaptado del GMT Example 28.
#
# Temas a ver:
# 1. Trabajar con grillas/imagen en coordenadas planas (UTM)
#

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=$(basename $0 .sh)
	
#	Datos (geotiff exportado en UTM 21 sur)
	IMG=Malvinas_UTM.tif

#	Setear ancho de la figura (alto = 0 para mantener proporcion original).
	ANCHO=10c/0

#	Ver información de la imagen satelital
#	---------------------------------------------------------------------------
#	gmt grdinfo $IMG

	# Defino variable con proyección de la imagen 
	PROJ=u-21

#	Dibujar mapa
#	---------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Datos en coordenadas no geograficas (-Jx)
#	---------------------------------------------
#	Graficar imagen
	gmt grdimage $IMG -JX$ANCHO

#	Ver información para extraer escala
	# 1. Guardar estandar error en archivo
	gmt basemap -B+n -Vi 2> tmp_escala.txt 
	# 2. Obtener texte que empiece con "1:"
	#grep -oP 1:.* escala.txt
	# 3. Borrar punto final	
	#grep -oP 1:.* escala.txt | sed 's/.$//'
	# 4. Guardar resultado en una variable
	ESCALA=$(grep -oP 1:.* tmp_escala.txt | sed 's/.$//' )
#	ESCALA=1:1.88e+06

#	Información del tamaño de la figura (ancho y alto en cm):
#	gmt mapproject -W

#	Agregar anotaciones de coordenadas planas en ejes W y S
	gmt basemap -Bag+u" m" -BWeSn --MAP_GRID_CROSS_SIZE_PRIMARY=0.25c

#	Datos en coordenadas UTM (-Ju)
#	---------------------------------------------
#	Superponer datos geográficos y coregistro utilizando la región correcta y la proyección gmt con la misma escala.
	gmt coast -R$IMG -J$PROJ/$ESCALA -Df+ -Slightblue -W0.5p

#	Agregar anotaciones geográficas en ejes N y E
	gmt basemap -Byafg -Bxafg -BNE --FORMAT_GEO_MAP=ddd:mmF

gmt end

# Ejercicios sugeridos
# 1. Cambiar la escala del mapa.
# 2. Usar otra imagen satelital.