#!/usr/bin/env bash

# Temas a ver:
# 1. Usar archivo con distintos simbolos y colores

#	Variables del Mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo de la figura
	title=Van_Krevelen
	title=$(basename $0 .sh)
	echo $title

#	Dominio de datos (eje X e Y)
	REGION=0/100/0/1000

#	Proyeccion Lineal (X). Ancho y alto (en cm)
	PROJ=X7c/10c

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt set	FONT_TITLE 16,4,Black
	gmt set	FONT_LABEL 10p,19,Red
	gmt set	FONT_ANNOT_PRIMARY 8p,Helvetica,Blue

	gmt set PS_CHAR_ENCODING ISOLatin1+
	gmt set IO_SEGMENT_MARKER B

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Tìtulo de la figura (-B+t)
	gmt basemap -B+t"Pseudo Van Krevelen"

#	Color de fondo del grafico (-B+g"color")
	gmt basemap -B+g200

#	Titulo de los ejes (X Y) por separado: (a)notacion), (f)rame y (l)abel. @- Inicio/Fin Subindice. 
	gmt basemap -Bxaf+l"Hydrogen Index (mg-HC/g-TOC)" -Bya100f+l"Oxygen Index (mg-CO@-2@-/g-TOC)" -BWeSn
 
#	Graficar Lineas del Grafico
	gmt plot -Wthin+s <<- END 
	20,900
	10,700
	5,80
	
	50,650
	10,500
	5,400
	5,80
	
	2,0.005
	2,1
	
	5,0.005
	5,1
	END



#	Poner Nombre de los Campos
	gmt text -F+f12 <<-END
	20,920,TYPE I
	#3.75,0.20,PSD
	#10.00,0.10,SP+SD
	#15.00,0.01,MD
	END

#	Graficar Datos como símbolos. Color (-G), Borde (-W) y forma (-S)
#	**************************************************************
	#gmt plot "Datos.txt" -: -Wthinnest -S0.2 -Ccategorical
		
#	---------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

	rm gmt.*
