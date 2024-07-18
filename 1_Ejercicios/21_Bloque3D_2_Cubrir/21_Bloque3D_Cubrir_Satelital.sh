#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Cubrir bloque 3D con imagen satelital.

#	Definir Variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=21_Bloque3D_Cubrir_Satelital
	title=$(basename $0 .sh)
	echo $title

#	Region: Cuyo
	REGION=-72/-64/-35/-30
	BASE=-10000
	TOP=10000	
	REGION3D=$REGION/$BASE/$TOP

#	Proyeccion Mercator (M)
	PROJ=M14c
	PROZ=4c
	p=160/30

#   Resolucion
    RES=01m

#	Grilla 
	RELIEVE=@earth_relief_$RES
	IMG=@earth_day_$RES

# 	Nombre archivo de salida y Variables Temporales
	CUT=tmp_$title.nc
    SHADOW=tmp_$title-shadow.nc

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion FUENTE
	gmt set FONT_ANNOT_PRIMARY 8,Helvetica,black
	gmt set FONT_LABEL 8,Helvetica,black

#	Sub-seccion FORMATO
	gmt set FORMAT_GEO_MAP ddd:mm:ssF

#	Sub-seccion GMT
	gmt set GMT_VERBOSE w

#	Sub-seccion MAPA
	gmt set MAP_FRAME_TYPE fancy
	gmt set MAP_FRAME_WIDTH 0.1
	gmt set MAP_GRID_CROSS_SIZE_PRIMARY 0
	gmt set MAP_SCALE_HEIGHT 0.1618
	gmt set MAP_TICK_LENGTH_PRIMARY 0.1

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Recortar Grilla
	gmt grdcut $RELIEVE -G$CUT -R$REGION

#	Dibujar Figura
#	--------------------------------------------------------------------------------------------------------
#	Bloque 3D
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I -C -Qi300 -N$BASE+glightgray -Wf0.5 \
#   -BnSwEZ+b -Baf -Bzaf+l"Altura (m)"
    gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I    -Qi300 -N$BASE+glightgray -Wf0.5 \
    -BnSwEZ -Baf -Bzaf+l"Altura (m)" -G$IMG

#	Dibujar datos culturales en bloque 3D
#	-----------------------------------------------------------------------------------------------------------
#	Pintar Oceanos (-S) y Lineas de Costa en 2D
	gmt coast -p$p/0 -Da -Sdodgerblue2 -A0/0/1 
	gmt coast -p$p/0 -Da -W1/0.3,black 
	
#	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano central (+c), 
	gmt basemap -Ln0.88/0.075+c+w100k+f+l -p$p/0

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end
	
#	Borrar archivos temporales
	rm tmp_* gmt*
