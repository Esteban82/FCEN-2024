#!/usr/bin/env bash
clear

#	Temas a ver: 
#	1. Vista en perspectiva.
#	2. Usar otros paletas de colores maestras (CPT).
#	3. Crear grilla para sombreado.
#	4. Curvas de nivel.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=09_Grilla_02
	echo $title

#	Grilla
	GRD=@earth_relief_15s

#	Region: Argentina
	REGION=-72/-64/-35/-30
	REGION=AR,BR,CO
	REGION=AR,GS
#	REGION==SA

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Vista perspectiva (acimut/elevacion)
#	p=140/30
#	p=210/45
	p=180/90

# 	Archivos temporales
	CUT=tmp_$title.nc
	SHADOW=tmp_${title}_shadow.nc

	gmt set GMT_VERBOSE i

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n -p$p

#	Crear image a partir de grilla con sombreado personalizado
#	----------------------------------------------------------
#	Recortar Grilla
	gmt grdcut $GRD -G$CUT -R$REGION

#	Crear Imagen a partir de grilla con sombreado y diferentes cpt maestros
	gmt grdimage -p $CUT -I
#	gmt grdimage -p $CUT -I -Cglobe
#	gmt grdimage -p $CUT -I -Cetopo1
#	gmt grdimage -p $CUT -I -Coleron
#	gmt grdimage -p $CUT -I -Crelief

#	Crear Grilla de Pendientes para Sombreado (Hill-shaded). Definir azimuth del sol (-A)
#	gmt grdgradient $CUT -A270 -G$SHADOW -Nt0.8
#	gmt grdgradient $CUT -A270/45 -G$SHADOW -Nt0.8

#	gmt grdimage -p $CUT -I+a270+nt1
#	gmt grdimage -p $CUT -I$SHADOW  -Coleron
#	----------------------------------------------------------

#	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
#	gmt colorbar -DJRM+o0.3c/0+w11/0.618c -C -p -Ba1+l"Elevaciones (km)" -I -W0.001

#	Lineas de Contorno. Equidistancia (-C), Anotaciones (-A), Numero de Corte (-Q), Limitar rango (-Llow/high), 
#	gmt grdcontour $CUT -p -W0.5,black    -C500 -Vi
#	gmt grdcontour $CUT -p -W0.5,black    -C1000
#	gmt grdcontour $CUT -p -W0.5,black    -C1000 -L-7000/0
#	gmt grdcontour $CUT -p -W0.5,black    -C1000 -L-7000/2000
#	gmt grdcontour $CUT -p -W0.5,black    -C1000 -Ln
#	gmt grdcontour $CUT -p -W0.5,black    -C1000 -Lp
#	gmt grdcontour $CUT -p -W0.5,black    -C1000 -Ln -Q100k
#	gmt grdcontour $CUT -p -W0.35,black,- -C100  -Ln   -Q100k
#	gmt grdcontour $CUT -p -W0.5,black    -C1000 -Ln -A2000+gwhite+u" m"
	gmt grdcontour $CUT -p -W0.5,black    -C-1000,-500,5000

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -p -Bxaf -Byaf -BWesN

#	Dibujar Linea de Costa (W1)
#	gmt coast -p -Da -W1/faint

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt end

	rm tmp_* gmt.*

#	-----------------------------------------------------------------------------------------------------------
#
#	Ejercicios Sugeridos:
#	1. Utilizar otros cpt maestros (probar lineas 54-57). Ver en documentacion otros.
#	2. Modificar el acimut del sol para el efecto de sombreado y agregar otro (60-61).
#	3. Probar los distintos comandos para crear curvas de nivel (lineas 71 a 80)	
#	4. Hacer el mapa con otras perspectivas (lineas 29-30). Probar con otras.