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
	
#	Datos
	IMG=Malvinas_UTM.tif

#	Escala de la figura 
	ESCALA=1:2000000


#	Ver información de la imagen satelital
#	---------------------------------------------------------------------------
#	gmt grdinfo $IMG

#	Dibujar mapa
#	---------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Datos en coordenadas no geograficas (-Jx)
#	---------------------------------------------
#	Graficar imagen 
	gmt grdimage $IMG -Jx$ESCALA

#	Agregar anotaciones planes en ejes S y W
	#gmt basemap -R$IMG+Uk -Bag+u" m" -BWSne --FONT_ANNOT_PRIMARY=10p --MAP_GRID_CROSS_SIZE_PRIMARY=0.25c  #--FONT_LABEL=10p

#	En km pero añade ,000m a las anotaciones para obtener etiquetas de metros personalizadas.
#	gmt basemap -Bag+u" m" -BWSne --FONT_ANNOT_PRIMARY=8p \
#		--MAP_GRID_CROSS_SIZE_PRIMARY=0.25c --FONT_LABEL=10p
	gmt basemap -R$IMG+Uk -Jx1:2000 -Bag+u"@:8:000m@::" -BWSne --FONT_ANNOT_PRIMARY=10p \
		--MAP_GRID_CROSS_SIZE_PRIMARY=0.25c --FONT_LABEL=10p

#	Datos en coordenadas UTM (-Ju)
#	---------------------------------------------
#	gmt mapproject -W

#	gmt grdimage $IMG -JX14.1/8.825c --FONT_ANNOT_PRIMARY=9p -Vi
#	gmt mapproject -W

#	Superponer datos geográficos y coregistro utilizando la región correcta y la proyección gmt con la misma escala.
	gmt coast -R$IMG -Ju-21/$ESCALA -Df+ -Slightblue -W0.5p

#	Agregar anotaciones geográficas en ejes N y E
	gmt basemap -Byafg -Bxafg -BNE --FONT_ANNOT_PRIMARY=12p --FORMAT_GEO_MAP=ddd:mmF

gmt end
