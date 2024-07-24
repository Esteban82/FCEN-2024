#!/usr/bin/env bash
clear

export http_proxy="http://proxy.fcen.uba.ar:8080"
gmt set GMT_DATA_SERVER Brasil


#	Temas a ver
#	1. Aplicar recortes (visuales) irregulares según otros datos.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=25_Recorte_irregular_2
	title=$(basename $0 .sh)
	echo $title

#	Region: Argentina
	REGION=-72/-64/-35/-30
	REGION=-70/-42/-36/-12

#	REGION=AR,BR,CO
#	REGION=AR,CL,GS
#	REGION==SA  # Límite definido por los límites de los países de Sudamérica.
#	REGION=SAM	# Codigo de DCW Collections. Límites geográficos de Sudamérica.

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Resolución para las grillas
	RES=_03m
#	RES=     # Vacio para que tenga resolución automática.
	RES=_02m

#	Fuente a utilizar
	DEM=@earth_relief$RES
	IMG=@earth_day$RES

#	Dibujar mapa
#	---------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Graficar grilla
	gmt grdimage $DEM -I -Cwhite
    
#	Dibujar escala de colores
#	gmt colorbar -DJRM -I -Baf -By+l"km" -W0.001 -F+gwhite+p+i+s -GNaN/0

#	Recorte (visual)
#******************************************************************************
#	Iniciar recorte a partir de tmp_clip
	gmt clip Cuenca_Parana.txt
#   gmt clip Cuenca_Parana.txt -N	# -N: Invertir mascara

#	Graficar imagen satelital
	#gmt grdimage $IMG
#   gmt grdimage $IMG -t50
	gmt grdimage $DEM -I -Cdem4

#	Finalizar recorte
    gmt clip -C
#	*************************************************************

#	---------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Bxaf -Byaf

#	Dibujar Linea de Costa (W1)
	gmt coast -N1/faint

#	---------------------------------------------------------------------------
#	Cerrar el archivo
gmt end

# Ejercicios sugeridos
# 1. Invertir mascara.
# 2. Utilizar otro polígono.
