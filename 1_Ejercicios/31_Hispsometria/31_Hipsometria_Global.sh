#!/bin/bash

#	Temas a ver
#	1. Extraer datos de una grilla para su analisis.
#	2. Trabajar con datos binarios (para mayor velocidad de procesamiento).
#	3. Hacer histograma rotado y con colores.
#	4. Superponer curva acumulada.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=31_Hipsometria_Global
	title=$(basename $0 .sh)
	echo $title

#	Definir Tipo de Histograma: Contar (-Z0), Frecuencia (-Z1).
#	Z=0
	Z=1

#	Ancho de la clase (bin width) del Histograma (-T)
	T=50
#	T=10
#	T=100

#	Resoluciones disponibles: 01d, 30m, 20m, 15m, 10m, 06m, 05m, 04m, 03m, 02m, 01m, 30s, 15s
	RES=20m

#	Definir DEM
	#DEM="@mars_relief_$RES"
	DEM="@earth_relief_$RES"
	
#	Dimensiones y tipo de graficos y rango de alturas
	PROJ=X15c/10c

#	Binario (h: 2-byte signed int. f: 4-byte single-precision float).
	BIN=1h,1f

# 	Nombre archivo de salida
	color=tmp_$title.cpt
	DATOS=tmp_datos.bin

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt set FONT_TITLE 14,4,Black
	gmt set FONT_LABEL 10p,19,Red
	gmt set FONT_ANNOT_PRIMARY 8p,Helvetica,Black
	gmt set FONT_ANNOT_SECONDARY 7p,Helvetica,Black

	gmt set MAP_ANNOT_OFFSET_SECONDARY 5p
	gmt set MAP_GRID_PEN_SECONDARY 1p

	gmt set GMT_VERBOSE w

#	Inicio
#	---------------------------------------------------------------------------

#	A. Preprocesamiento de datos
#	---------------------------------------------------------------------------
#	1. Extraer datos alturas (ponderados por area -Wa) de la grilla
#	gmt grd2xyz $DEM -Wa -o2,3 > tmp_datos.txt 	# Formato por defecto (ascii)
	gmt grd2xyz $DEM -Wa -o2,3 > $DATOS -bo$BIN	# Formato binario
		
#	Opcional: Convertir datos binarios a txt. 
#	gmt convert "tmp_datos" -bi$BIN > "tmp_datos.txt"

#	B. Hacer figura
#	-------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Frecuencia Altimetrica
#	-------------------------------------------------------------------------------------
#	1. Analizar datos y extraer info
	gmt histogram $DATOS -bi$BIN -I -Z$Z+w -T$T
	MIN=$(gmt histogram $DATOS -bi$BIN -Z$Z+w -T$T -I -o0)
	MAX=$(gmt histogram $DATOS -bi$BIN -Z$Z+w -T$T -I -o1)

#	2. Crear CPT para los colores
	gmt makecpt -Cgeo -T$MIN/$MAX

#	3. Dibujar Curva Hipsometrica rotada (-A). Datos ponderados (+w).
	gmt histogram $DATOS -bi$BIN -J$PROJ -A -C -T$T -Z$Z+w \
	-Bxafg+l"Elevaciones (m)" -Byaf+l"Frecuencia Altimétrica (\045)"

#	Dibujar Curva Hipsometrica Acumulada
#	-------------------------------------------------------------------------------------
#	Redefinir Parametros
	DOMINIO=$MIN/$MAX/0/100.3
	gmt set	MAP_FRAME_AXES EN
	gmt set	FONT_LABEL 10p,19,Blue

#	Dibujar Curva Hipsometrica (-S)
#	gmt histogram $DATOS -bi$BIN -J$PROJ -R$DOMINIO -A -F -Z$Z+w -T$T -S -Wthinner,blue -Qr \
	gmt histogram $DATOS -bi$BIN -J$PROJ -R$DOMINIO -A -F -Z$Z+w -T1  -S -Wthinner,blue -Qr \
	-Byaf+l"Frecuencia Acumulada (%)" -B+t"Análisis Hipsométrico"

#	-------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt end

#	rm gmt.* tmp_*