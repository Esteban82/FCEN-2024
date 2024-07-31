#!/bin/bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
	title=$(basename $0 .sh)
 
#	Region Geografica y proyección
#	REGION=-79/-20/-63/-20
	REGION=-74/-64/-36/-28
	PROJ=M15c

#	Grilla mapa base
	GRD=@earth_relief
#	GRD=@earth_relief_05m 

#   Resolucion de la grilla de densidades (heatmap)
	res=10k

#	Datos
	DATOS=../33_Heatmap/Datos/query_*

# 	Nombre archivo de salida
	HEATGRID=tmp_heatgrid.nc

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt	set FONT_TITLE 16,4,Black
	gmt	set FONT_LABEL 10p,19,Black
	gmt	set FONT_ANNOT_PRIMARY 8p,Helvetica,Black
	gmt	set MAP_FRAME_AXES WesN

#	Sub-seccion COLOR
	gmt set COLOR_NAN white

#	***********************************************************************
#	Procesar Sismos
#	-----------------------------------------------------------------------------------------------------------
#	Combinar archivos con datos de sismicidad en un unico archivo.
	cat $DATOS > tmp_sismos.txt

#	Extraer datos de Longitud y Latitud. -s: no escribe datos con NaN
	gmt convert tmp_sismos.txt -i2,1 -hi1 -s > tmp_LongLat.txt

#	Crear grilla con binstat
#	-fg: Datos en Long-Lat
#	-I: Resolucion de la grilla de salida
#	-G: Grilla de salida
#	-Cn: Contar cantidad de datos en el area de busqueda
#	-S: radio del círculo del area de busqueda
	gmt binstats tmp_LongLat.txt -fg -R$REGION -G$HEATGRID -I1m -S50k -Cn -Vi
#	gmt binstats tmp_LongLat.txt -fg -R$REGION -G$HEATGRID -I1k -S50k -Cn -Vi
#	gmt binstats tmp_LongLat.txt -fg -R$REGION -G$HEATGRID -I20k -S4k -Cn -Vi
#	gmt binstats tmp_LongLat.txt -fg -R$REGION -G$HEATGRID -I20k -S40k -Cn -Vi

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear variables
	gmt basemap -R$REGION -J$PROJ -B+n

#	Dibujar Mapa Base
#	-----------------------------------------------------------------------------------------------------------
#	Crear CPT Mapa Fondo
	gmt makecpt -T-11000,0,9000 -Cdodgerblue2,white

#	Crear Imagen a partir de grilla con sombreado
	gmt grdimage $GRD -C -I

#	Dibujar Bordes Administrativos. N1: paises. N2: Provincias, Estados, etc.
	gmt coast -N1/0.30 
	gmt coast -N2/0.25,-.

#	Crear Variable para CPT
#	T=$(gmt grdinfo $HEATGRID -T+a5)

#	Crear CPT. Paleta Maestra (-C).
	gmt makecpt -Chot -Di $(gmt grdinfo $HEATGRID -T)

#	Crear Imagen a partir de grilla con sombreado y cpt
#	gmt grdimage $HEATGRID -C
#	gmt grdimage $HEATGRID -C    -t50
#	gmt grdimage $HEATGRID -C -Q 
#	gmt grdimage $HEATGRID -C -Q -t50
	gmt grdimage $HEATGRID -C -Q -t50 

#	Agregar escala de colores a partir de CPT (-C). Posicion (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -C -DjRT+o1.7c/0.7+w9/0.618c+ef -Baf+l"Cantidad de Sismos ocurridos a 50 km de distancia"  -F+gwhite+p+i+s

#	Dibujar frame (-B): Anotaciones (a), frame (f), grilla (g)
	gmt basemap -Bxaf -Byaf

#	gmt basemap -L+w50k -Vd
#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

rm tmp_* gmt.*

#	Ejercicios sugeridos
#	1. Cambiar los valores del incremento de la grilla (-I) para binstats.
#	1. Cambiar los valores del área de búsqueda (-S) para binstats.
