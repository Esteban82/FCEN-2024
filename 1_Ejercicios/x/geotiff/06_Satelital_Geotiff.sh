#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Crear un geotiff

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=06_Satelital_02_Malvinas
	echo $title

#	Imagen satelital (Geotfiff)
	IMG=../../06_Satelital_2/Datos/Malvinas_Geo.tif
	
#	Region Geografica
	REGION=$IMG
#	REGION=-61.5/-57.5/-52.5/-51
#	REGION=-60/-57.5/-52.5/-51
	
#	Proyeccion: (M)ercator y Ancho de la figura) 
	PROJ=M15c

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion MAPA
	gmt set MAP_FRAME_TYPE inside
#	gmt set MAP_FRAME_TYPE fancy+
#	gmt set MAP_FRAME_TYPE fancy

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png,ps

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Graficar Imagen Satelital
	#gmt grdimage "@earth_day_01m"
	gmt grdimage $IMG

#	Pintar Oceanos (-S)
	gmt coast -Sdodgerblue2

#	Dibujar Linea de Costa
	gmt coast -W1/faint

#	Dibujar Norte (-Td)
	gmt basemap -Tdg-58/-51.25+w1.25c	          --FONT_TITLE=8p,4,Black

#	Dibujar Escala 
	gmt basemap -Lg-58/-52:20+c-51:45+w50k+f+l

#	Crear GEOTIFF
#	****************************************************************
	gmt psconvert -A -Tt -W+g -Fmapa
#	****************************************************************

#	Dibujar frame
	gmt basemap -BWesN -Baf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

# Crear GEOTIFF 2
gmt psconvert $title.ps -A -Tt -W+g -Fmapa2

rm gmt.conf