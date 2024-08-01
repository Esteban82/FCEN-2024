#!/bin/bash
clear

#	Temas a ver
#	1. Recorte irregular de una grilla (con una máscara)

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=48_Mascara_Cuenca_Parana
	title=$(basename $0 .sh)
	echo $title

#	Region: Argentina
	REGION=-70/-42/-36/-12

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Grilla
	DEM=@earth_relief

# 	Nombre archivo de salida
	CUT=tmp_$title.nc
	CUT1=tmp_${title}_1.nc
	MASCARA=tmp_${title}_mascara.nc
	POLIGONO=tmp_poligono.txt

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
	gmt grdcut $DEM -G$CUT1 -R$REGION -J$PROJ

#	Crear/Definir poligono irregular para la máscara
	cat Cuenca_Parana.txt > $POLIGONO
#	gmt coast -M -EPY > $POLIGONO
#	gmt coast -M -EAR.A,AR.Y   > $POLIGONO
#	gmt grdcontour $CUT1  -C+3000 -D$POLIGONO

#	Crear Mascara con valores dentro del poligono (-Nfuera/borde/dentro)
#	Crear mascara siguiendo POLIGONO en la region de $CUT1. Setear valores de 1 dentro y guaradar en $MASCARA
	gmt grdmask -R$CUT1 $POLIGONO -G$MASCARA -NNaN/NaN/1	# Recorte dentro
#	gmt grdmask -R$CUT1 $POLIGONO -G$MASCARA -N1/NaN/NaN	# Recorte fuera

#	Recortar 
	gmt grdmath $CUT1 $MASCARA MUL = $CUT

#	Crear Mapa
#	-------------------------------------------------------------

#	Crear CPT con NAN white
	gmt makecpt -Cdem4 -M --COLOR_NAN=white

#	Crear Imagen a partir de grilla con sombreado y cpt. -Q: Nodos sin datos sin color
	gmt grdimage $CUT -I    -C
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
	gmt plot $POLIGONO -W0.5,red

#	Pintar areas húmedas: Oceanos (-S) y Lagos y Rios (-C).
	gmt coast -Sdodgerblue2 -C-

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar sesion y mostrar figura
gmt end # show

#	rm tmp_* gmt.*

#	Ejercicios sugeridos
#	1. Probar otros poligonos.
#	2. Invertir la mascara. 