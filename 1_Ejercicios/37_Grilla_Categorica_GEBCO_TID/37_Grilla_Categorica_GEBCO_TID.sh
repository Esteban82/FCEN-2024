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
	TID=gebco_2024_tid_n-34.0_s-56.0_w-70.0_e-50.0.nc

#	CPT Categórico	
	CPT=GEBCO_TID_IHO.cpt	

#	Region y proyección
	RREGION=-70/-54/-56/-33
	REGION=$TID				# Misma región que la grilla
	PROJ=M10c

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

#	Agregar curva de nivel de -200 m
	gmt grdcontour @earth_relief -C-200, -Wblue

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