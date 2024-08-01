#!/bin/bash
clear

#	Temas a ver
#	1. Recorte irregular de una grilla

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=47_B_Mascara_Cuenca_Parana
	title=$(basename $0 .sh)
	echo $title

#	Region: Argentina
	REGION=-70/-42/-36/-12

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Resolucion de la grilla
	RES=15s
	RES=02m

#	Base de datos de GRILLAS
	DEM=@earth_relief_$RES

# 	Nombre archivo de salida
	CUT=tmp_$title.nc
	CUT1=tmp_$title-1.nc
	MASK=tmp_$title-2.nc
	CLIP=tmp_clip.txt

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion FUENTE
	gmt set FONT_ANNOT_PRIMARY 8,Helvetica,black
	gmt set FONT_LABEL 8,Helvetica,black

#	Sub-seccion FORMATO
	gmt set FORMAT_GEO_MAP ddd:mm:ssF

#	Sub-seccion GMT
	gmt set GMT_VERBOSE w

#	Iniciar sesion y tipo de figura
#	-----------------------------------------------------------------------------------------------------------
#	Abrir archivo de salida (ps)
gmt begin $title png

#	Setear la region y proyeccion (y no se dibuja nada)
	gmt basemap -R$REGION -J$PROJ -B+n	

#	Crear grilla
#	-------------------------------------------------------------
#	Recortar la grilla (rectangular)
	gmt grdcut $DEM -G$CUT1 -R$REGION

#	Crear/Definir poligono irregular
#	cat Cuenca_Parana.txt > $CLIP
	gmt coast -M -EPY > tmp_PY

#	Crear poligono con agujero ("dona") -Sh
	gmt spatial Cuenca_Parana.txt tmp_PY -Sh > $CLIP
#	gmt spatial Cuenca_Parana.txt tmp_CLIP -Ii > $CLIP

#	Crear Mascara con valores dentro del poligono (-Nfuera/borde/dentro)
	gmt grdmask -R$CUT1 $CLIP -G$MASK -NNaN/NaN/1

#	Recortar 
	gmt grdmath $CUT1 $MASK MUL = $CUT

#	Crear Mapa
#	-------------------------------------------------------------
#	gmt makecpt -Cdem4

#	Crear Imagen a partir de grilla con sombreado y cpt. -Q: Nodos sin datos sin color 
	gmt grdimage $CUT -I    -Cdem4
#	gmt grdimage $CUT -I -Q -Cdem4

#	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
#	gmt colorbar -Cdem4 -I -DJRM+o0.3c/0+w14/0.618c  -Ba+l"Alturas (km)" -W0.001

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Baf

#	Dibujar Linea de Costa
	gmt coast -Df -W1/0.5

#	Dibujar Bordes Administrativos. N1: paises. N2: Provincias, Estados, etc. N3: limites marítimos (Nborder[/pen])
	gmt coast -Df -N1/0.30 
	gmt coast -Df -N2/0.25,-.

#	Dibujar CLIP
	gmt plot $CLIP -W0.5,red

#	Pintar areas húmedas: Oceanos (-S) y Lagos y Rios (-C).
	gmt coast -Sdodgerblue2 -C-

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar sesion y mostrar figura
gmt end


rm tmp_* gmt.*