#!/usr/bin/env bash

# Temas a ver:
# 1. Hacer un mapa de una grilla categórica.
# 2. Ver CPT categóricos.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=TID_2024
	title=$(basename $0 .sh)

#	Grilla categórica
	TID=../37_Grilla_Categorica_GEBCO_TID/gebco_2024_tid_n-34.0_s-56.0_w-70.0_e-50.0.nc

#	CPT Categórico	
	CPT=../37_Grilla_Categorica_GEBCO_TID/GEBCO_TID_IHO.cpt	

#	Region y proyección
	REGION=$TID				# Misma región que la grilla
#	PROJ=M10c
#	PROJ=X10c
	PROJ=x2.05

#	Parametros GMT
	gmt set FONT_ANNOT_PRIMARY 8p,Helvetica,Black

#	Inicio
#	---------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear Proyección y region
	gmt basemap -R$REGION -J$PROJ -B+n

#	Dibujar Grilla categórica (-nn: Interpolar usando nearest-neighbor)
	gmt grdimage $TID -C${CPT} -nn+a

	gmt grdinfo $TID > info.txt

#	Crear imagenes georreferenciadas
#	***************************************************************************
#	1. Geotiff. 
#	gmt psconvert -A -Tt -Ftif
	gmt psconvert -A -Tt -FGeotiff_x1 -W+g
	gmt psconvert -A -Tt -FTiff_x1_q1 -W+g -Qt1

#	2. KML
	gmt psconvert -FKML -Tg -W+k

#	Dibujar elementos FUERA del mapa
#	***************************************************************************
#	Dibujar colorbar catetórigo	
	gmt colorbar -DJLR+o0.5c/0c+w-90%/0.6c -L0.1 

#	Dibujar marco del mapa
	gmt basemap -Baf

#	Cerrar sesión
gmt end

# Borrar archivos temporales
rm gmt.conf