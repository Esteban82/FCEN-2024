#!/usr/bin/env bash
clear

#	Temas a ver
#	1. Aplicar recortes (visuales) irregulares segun base de datos GSHHG y DCW.

#	Definir variables del mapa
#	---------------------------------------------------------------------------
#	Titulo del mapa
	title=24_DEM_Satelital
	title=$(basename $0 .sh)
	echo $title

#	Region: Argentina
#	REGION=-72/-64/-35/-30
#	REGION=AR,BR,CO
#	REGION=AR,CL,GS
#	REGION==SA  # Límite definido por los límites de los países de Sudamérica.
	REGION=SAM	# Codigo de DCW Collections. Límites geográficos de Sudamérica.

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Resolución para las grillas
	RES=_03m
	RES=     # Vacio para que tenga resolución automática.

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
	gmt grdimage $DEM -I
    
#	Dibujar escala de colores
	gmt colorbar -DJRM -I -Baf -By+l"km" -W0.001 -F+gwhite+p+i+s -GNaN/0

#	Recorte (visual)
#******************************************************************************
	gmt coast -G    		# Recorte para mostrar continentes
#	gmt coast -S	   		# Recorte para mostras oceanos
#	gmt coast -EAR,FK,GS+c  # Recorte segun paises por dentro (+c)
#	gmt coast -EAR,FK,GS+c 	# Recorte segun paises por dentro (+c)
# 	gmt coast -EAR,FK,GS+C 	# Recorte según paíse por afuera (+C)

#	DEM/Imagen recortada
	gmt grdimage $IMG  				# Imagen satelital 
#	gmt grdimage $DEM -I -Cgray 	# Relieve con escala de grises

#	Limites administrativos de nivel 2
#	gmt coast -N2

#	Finalizar recorte
	gmt coast -Q
#******************************************************************************

#	Dibujar frame
	gmt basemap -Bxaf -Byaf

#	Dibujar Linea de Costa (W1)
	gmt coast -N1/faint

#	---------------------------------------------------------------------------
#	Cerrar el archivo
gmt end

# Ejercicios sugeridos
# 1. Probar las otras opciones para recortar continentes, oceános.
# 2. Recortar según polígonos de DCW collections.
# 3. Graficar el mismo DEM pero con escala de grises.
# 4. Graficar los límites administrativos de nivel 2 de un país. 