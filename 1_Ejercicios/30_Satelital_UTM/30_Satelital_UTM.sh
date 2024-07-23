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

#	Escala de la figura 
#	ESCALA=1:2000000
	ESCALA=1:1000000

#	Ver información de la imagen satelital
#	---------------------------------------------------------------------------
	gmt grdinfo $IMG

	# Defino variable con proyección de la imagen 
	PROJ=u-21

#	Dibujar mapa
#	---------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Datos en coordenadas no geograficas (-Jx)
#	---------------------------------------------
#	Graficar imagen
	gmt grdimage $IMG -Jx$ESCALA -Vi

#	Información del tamaño de la figura (ancho y alto en cm):
	gmt mapproject -W

#	Agregar anotaciones de coordenadas planas en ejes W y S
	gmt basemap -Bag+u" m" -BWSne --MAP_GRID_CROSS_SIZE_PRIMARY=0.25c

#	Datos en coordenadas UTM (-Ju)
#	---------------------------------------------
#	Superponer datos geográficos y coregistro utilizando la región correcta y la proyección gmt con la misma escala.
	gmt coast -R$IMG -J$PROJ/$ESCALA -Df+ -Slightblue -W0.5p

#	Agregar anotaciones geográficas en ejes N y E
	gmt basemap -Byafg -Bxafg -BNE --FORMAT_GEO_MAP=ddd:mmF

gmt end

# Ejercicios sugeridos
# 1. Cambiar la escala del mapa
# 2. Usar otra imagen satelital.