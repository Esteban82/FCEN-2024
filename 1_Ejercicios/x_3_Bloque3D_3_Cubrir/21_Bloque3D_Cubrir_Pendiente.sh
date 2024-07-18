#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Cubrir bloque 3D con otra grilla/imagen.
#	2. Agregar escala al bloque. 

#	Definir Variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
#	title=21_Bloque3D_Cubrir_Pendiente
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

#	Grilla 
#	GRD=@earth_relief_01m
	GRD=@earth_relief_30s_p

# 	Nombre archivo de salida y Variables Temporales
	RELIEVE=tmp_${title}_relieve.nc
	PENDIENTE=tmp_${title}_pendiente.nc

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

#	Calcular grilla de pendientes (en grados)
#	---------------------------------------------
#	Recortar Grilla
	gmt grdcut $GRD -R$REGION -G$RELIEVE

#	Calcular Grilla con modulo del gradiente (-D) para grilla con datos geograficos (-fg)
	gmt grdgradient $RELIEVE -D -S$PENDIENTE -fg

#	Convertir modulo del gradiente a inclinacion (pendiente) en grados(ATAND).
	gmt grdmath $PENDIENTE ATAND = $PENDIENTE
#	---------------------------------------------

#	Crear Paleta de Color para PENDIENTES
#	gmt makecpt -Crainbow -T0/30 -I -Di

#	Dibujar Figura
#	--------------------------------------------------------------------------------------------------------
#	Bloque 3D
	gmt grdview $RELIEVE -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I -C -Qi300 -N$BASE+glightgray -Wf0.5 \
   -BnSwEZ+b -Baf -Bzaf+l"Altura (m)"
#    gmt grdview $RELIEVE -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I -C -Qi300 -N$BASE+glightgray -Wf0.5 \
#    -BnSwEZ -Baf -Bzaf+l"Altura (m)" -G$CUT2

#	Dibujar datos culturales en bloque 3D
#	-----------------------------------------------------------------------------------------------------------
#	Pintar Oceanos (-S) y Lineas de Costa en 2D
	gmt coast -p$p/0 -Da -Sdodgerblue2 -A0/0/1 
	gmt coast -p$p/0 -Da -W1/0.3,black 
	
#	Dibujar datos de coast en 3D
	gmt coast -R$REGION -Df -M -N1/ | gmt grdtrack -G$RELIEVE -sa | gmt plot3d -R$REGION3D -p$p -W0.5,black 
	gmt coast -R$REGION -Df -M -N2/ | gmt grdtrack -G$RELIEVE -sa | gmt plot3d -R$REGION3D -p$p -W0.2,black,-

#	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano (+c), 
	gmt basemap -Ln0.88/0.075+c+w100k+f+l -p$p/0

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end
	
#	Borrar archivos temporales
	rm tmp_* gmt*
