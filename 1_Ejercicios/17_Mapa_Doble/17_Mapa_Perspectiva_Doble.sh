#!/bin/bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=17_Mapa_Perspectiva_Doble
	title=$(basename $0 .sh)
	echo $title

#	Region Geografica, Proyeccion y perpectiva
	REGION=-72/-64/-35/-30
	PROJ=M15c
	p=160/30

#	Datos
	RES=01m
	GRD=@earth_relief_$RES
	SAT=@earth_day_$RES

	
	gmt set MAP_FRAME_AXES WesN
	gmt set GMT_VERBOSE w

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Dibujar mapa 1 
#	-----------------------------------------------------------------------------------------------------------
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n -p$p

#	Crear Paleta de Colores. Paleta Maestra (-C), Definir rango (-Tmin/max/intervalo), CPT continuo (-Z)
	gmt makecpt -Cdem4 -T0/7000

#	Crear Imagen a partir de grilla con sombreado y diferentes cpt maestros
	gmt grdimage -p $GRD -I -C

#	Agregar escala vertical a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -p -DJRM+o0.3c/0+w11/0.618c -C -Ba+l"Elevaciones (km)" -I -W0.001

#	Pintar areas húmedas: Oceanos (-S) y Lagos (-Cl/)f
	gmt coast -p -Sdodgerblue2

#	Dibujar limite paises y provincias
	gmt coast -p -N1/thinner -N2/thinnest,-
	
#	Dibujar frame
	gmt basemap -p -Baf

#	-----------------------------------------------------------------------------------------------------------
#	Transicion entre mapas. Subir 2º mapa 7,5 cm.
	gmt basemap -B+n -Y3.5c     # Subir 3.5 cm
	#gmt basemap -B+n -Yh+0.3c # Subir la altura de la figura + 0,3 cm
	#gmt basemap -B+n -Xw+0.3c  # Correr el ancho de la figura + 0,3 cm

#	-----------------------------------------------------------------------------------------------------------

#	Dibujar mapa 2
#	-----------------------------------------------------------------------------------------------------------
#	Ubicar Imagen satelital
	gmt grdimage -p $SAT

#	Dibujar limite paises y provincias
	gmt coast -p -N1/thinner -N2/thinnest,-

#	Dibujar frame
	gmt basemap -p -Baf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt end

	rm gmt.*

#	Ejercicios Sugeridos:
#	1. Cambiar el espacio entre ambas imagenes (-Y linea 51).
#	2. Agregar distintos datos culturales (limites de paises, provincias, ciudades, rutas, etc) a ambos mapas.