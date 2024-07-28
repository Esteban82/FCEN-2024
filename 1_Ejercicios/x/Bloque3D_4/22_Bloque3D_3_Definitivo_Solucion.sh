#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Dibujar datos culturales en bloque 3D

#	Definir Variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=22_Bloque3D_3_DatosCulturales
	title=$(basename $0 .sh)
	echo $title

#	Region: Cuyo
	REGION=-68/-64/-33/-30
	BASE=-1000			# en metros
	TOP=5000			# en metros
	REGION3D=$REGION/$BASE/$TOP

#	Proyeccion Mercator (M)
	PROJ=M14c
	PROZ=2c			# variable para escala vertical
	PROZ=4c			# variable para escala vertical
	p=160/20
#	p=180/90

#	Grilla
#	GRD=@earth_relief_30s
#	GRD=@earth_relief_15s
	GRD=@earth_relief_03s

# 	Nombre archivo de salida y Variables Temporales
	CUT=tmp_$title.nc

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion FORMATO
	gmt set FORMAT_GEO_MAP ddd:mm:ssF

#	Sub-seccion GMT
	gmt set GMT_VERBOSE w

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear region
	gmt basemap -R$REGION -JX14c -B+n

#	Recortar Grilla
	gmt grdcut $GRD -G$CUT -R$REGION

#	Hace mapa
	gmt grdimage $CUT -Cgeo

#	Dibujar datos IGN en 3D
	gmt plot IGN/RedVial_Ruta_Provincial.gmt  -Wthin,red

	gmt psconvert -A -Tt -W+g -Fmapa -E600

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

#	Dibujar Bloque 3D
#	--------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
#gmt begin $title png

#	Bloque 3D. 
	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I -Qi300 -N$BASE+glightgray -Wf0.5 \
	-BnSwEZ+b -Baf -Bzaf+l"Altura (m)" -Gmapa.tif -png 3D_I300
	
	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I -Qc -N$BASE+glightgray -Wf0.5 \
	-BnSwEZ+b -Baf -Bzaf+l"Altura (m)" -Gmapa.tif -png 3D_C

#	Cerrar el archivo de salida (ps)
#gmt end

#	Borrar archivos temporales
	rm tmp_* gmt*
