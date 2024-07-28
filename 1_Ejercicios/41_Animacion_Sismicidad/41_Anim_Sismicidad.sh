#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Hacer animación de sismos
#	2. Definir unidades temporales.
#	3. Ver modulo events.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=41_Sismicidad
	title=$(basename $0 .sh)
	echo $title
	
	DATOS=../33_Heatmap/Datos/query_*

#	0. Combinar archivos con datos de sismicidad en un unico archivo.
	cat $DATOS | gmt convert -i2,1,3,4+s2,0 -hi1 -N4+a -s -fi4T > SISMOS_ORDENADOS.txt

#	1. Crear script in.sh que incluye las variables para la animacion.
#	***********************************************************************************************
cat << 'EOF' > in.sh
#	Fechas de la animacion
	#INICIO=1920-01-01T
	#INICIO=2000-01-01T
	INICIO=2010-01-01T
	FIN=2021-11-01T
	INTERVALO=1o		# dias (d), semanas (w), meses (o), años (y)

#	Resolucion de la imagen/grilla del mapa base
	RES=04m

#	Proyeccion del mapa y ancho del mapa
	W=17.64c
	PROJ=M$W
		
#	Region geografica del mapa (W/E/S/N)
	REGION=-79/-20/-63/-20
	
#	Offset en X/Y
	X=5p
	Y=4.02c
EOF

#	1. Crear script pre.sh que hace la figura base
#	***********************************************************************************************
cat << 'EOF' > pre.sh

#	Dibujar mapa base
	gmt set COLOR_HSV_MIN_V 0
	gmt set FONT_LABEL 10p
	gmt set FONT_ANNOT_PRIMARY 8p
	gmt set MAP_FRAME_PEN thin,black
	
gmt begin
#	Crear lista de fechas para la animacion
	gmt math -o0 -T$INICIO/$FIN/$INTERVALO T = times.txt

#   Setear variables mapa de fondo
	gmt basemap -R$REGION -J$PROJ -B+n -Y$Y -X$X

#	Crear CPT Mapa Fondo
	gmt makecpt -T-11000,0,9000 -Cdodgerblue2,white -H > fondo.cpt

#	Crear Imagen a partir de grilla con sombreado
	gmt grdimage @earth_relief_$RES -Cfondo.cpt -I+nt1.2

#	Dibujar limites paises
	gmt coast -Df -N1/0.30

#	Borde
	gmt basemap -Bxf5 -Byf5

# 	Crear CPT para la sismicidad
	gmt makecpt -Crainbow -T0/650 -I -H > CPT
	
#	Sismos. Dibujar su escala y dibujar eventos
	gmt colorbar -CCPT -DjMR+o1.8/2/+w-8c/0.618+m -F+gwhite+s+p+r -Bxa+l"Profundidad Sismos (km)"

# 	Crear y dibujar Leyenda
#	-----------------------------------------------------------------------------------------------
	cat > tmp_leyenda.txt <<- END
	H 16p,Helvetica-Bold Sismos de mangnitud mayor a 2,5 ocurridos entre 1920 y 2021
	D 0 1p
	N 7
	S 0.25c c 0.15c - 0.25p 0.75c M 3
	S 0.25c c 0.20c - 0.25p 0.75c M 4
	S 0.25c c 0.25c - 0.25p 0.75c M 5
	S 0.25c c 0.30c - 0.25p 0.75c M 6
	S 0.25c c 0.35c - 0.25p 0.75c M 7
	S 0.25c c 0.40c - 0.25p 0.75c M 8
	S 0.25c c 0.45c - 0.25p 0.75c M 9
	D 0 1p
	N 1
	G 0.25l
	P
	L 10p,Times-Italic RB Elaborado por Federico D. Esteban
	L 10p,Times-Italic RB a partir de datos del USGS y con 
	L 10p,Times-Italic RB el software Generic Mapping Tools. 
	G 0.9c
	END

	# Dibujar leyenda
	gmt legend -DJBC+o0/0.3c+w17.64c/3.5c -F+p+gwhite+s+r tmp_leyenda.txt
	gmt image "Logos/logos.eps" -Dx0.2/-3.6+w10.8c
gmt end
EOF

#	2. Crear script principal (main.sh) que dibuja los eventos
#	***********************************************************************************************
cat << 'EOF' > main.sh
gmt begin
	gmt set COLOR_HSV_MIN_V 0
	gmt set FONT_LABEL 10p
	gmt set FONT_ANNOT_PRIMARY 8p

#   Setear variables mapa de fondo
	gmt basemap -R$REGION -J$PROJ -B+n -Y$Y -X$X

#   Graficar sismos como eventos
	gmt events SISMOS_ORDENADOS.txt -Scp -CCPT --TIME_UNIT=o -T${MOVIE_COL0} \
	-Es+r2+d6 -Ms3+c0.5 -Mi1+c0.5 -Mt+c0 -Wfaint
gmt end
EOF

# 	3. Crear animacion
#	***********************************************************************************************
#	Agregar fecha de cada frame (-Lc0, línea 124)
	gmt movie main.sh -Sbpre.sh -Iin.sh -C18cx22.5cx60 -Ttimes.txt -N$title -Ml,png -Zs -W -D14 -Vi \
	-Lc0+jTR+o0.4/0.4+s+gwhite+r --FONT_TAG=16p,Helvetica,black --FORMAT_CLOCK_MAP=- \
	--FORMAT_DATE_MAP=o-yyyy --GMT_LANGUAGE=ES #-Fmp4

#	4. Borrar archivos temporales	
    rm SISMOS_ORDENADOS.txt

#   Suspender PC
#	shutdown -h
#   systemctl suspend
#   rundll32.exe powrprof.dll,SetSuspendState 0,1,0
