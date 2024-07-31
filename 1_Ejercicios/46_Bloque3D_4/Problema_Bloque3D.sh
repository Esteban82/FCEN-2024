#!/usr/bin/env bash
clear

#	Definir Variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=22_Bloque3D_3_DatosCulturales
	title=$(basename $0 .sh)
	echo $title

#	Region 
	REGION=-68/-64/-33/-30
	BASE=-1000			# en metros
	TOP=5000			# en metros
	REGION3D=$REGION/$BASE/$TOP

#	Proyeccion y Escala
	PROJ=M14c
	PROZ=2c			# variable para escala vertical
	PROZ=4c			# variable para escala vertical
	p=160/20
	#p=180/90

#	Grilla
	GRD=@earth_relief_03s
	IMG=@earth_day_30s

#	Datos IGN
	DIR_IGN=../22_Bloque3D_3_DatosCulturales/IGN/

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

#	Recortar Grilla
	gmt grdcut $GRD -G$CUT -R$REGION

#	Dibujar Figura
#	--------------------------------------------------------------------------------------------------------
#	Bloque 3D. 
	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I -Cwhite -Qi300 -Wf0.5 -N$BASE+glightgray -BnSwEZ+b -Baf -Bzaf+l"Altura (m)" 

#	Dibujar datos IGN en 3D
	gmt grdtrack -R$REGION ${DIR_IGN}/RedVial_Ruta_Provincial.gmt -G$CUT | gmt plot3d -R$REGION3D -p$p -Wthin,red

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

#	Borrar archivos temporales
	rm tmp_* gmt*