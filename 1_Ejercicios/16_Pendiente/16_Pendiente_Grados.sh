#!/usr/bin/env bash
#export http_proxy="http://proxy.fcen.uba.ar:8080"

#	Temas a ver
#	1. Procesar grillas (calcular mapa de pendientes)
#	2. Obtener informacion de la grilla para crear CPT (grdinfo -T)

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	#title=16_Pendiente
	title=$(basename $0 .sh)
	echo $title

#	Region: Argentina
	REGION=-72/-64/-35/-30
	#REGION=AR+r2

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Grilla de entrada
	GRD=@earth_relief_15s

# 	Archivos temporales
	CUT=tmp_$title.nc

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n 

#	Calcular grilla de pendientes (en grados)
#	---------------------------------------------
#	Recortar Grilla
	gmt grdcut $GRD -G$CUT -R$REGION -J$PROJ

#	Calcular Grilla con modulo del gradiente (-D) para grilla con datos geograficos (-fg)
	gmt grdgradient $CUT -D -S$CUT -fg

#	Convertir modulo del gradiente a inclinacion (pendiente) en grados (ATAND).
	gmt grdmath $CUT ATAND = $CUT

#	Crear CPT
#	---------------------------------------------
#	Metodo 0. Definir rango personalizado
#	gmt makecpt -Crainbow -I -T0/30      # Escala continua
#	gmt makecpt -Crainbow -I -T0/30   -D # -D: usar color del valor 30 para valores mayores
#	gmt makecpt -Crainbow -I -T6/30/2 -D # Escala discreta

#	Metodo 1. Obterner el máximo
#	max=$(gmt grdinfo $CUT -Cn -o5)
#	gmt makecpt -Crainbow -I -T0/$max

#	Metodo 2. Obtener rango de valores (min y max) con grdinfo -T
#	gmt grdinfo $CUT -T
#	T=$(gmt grdinfo $CUT -T)

#	Metodo 3. Obtener rango pero filtrar valores extremos (segun alfa)
#	gmt grdinfo $CUT -T+a0.5
#	gmt grdinfo $CUT -T+a1
#	gmt grdinfo $CUT -T+a2
#	gmt grdinfo $CUT -T+a3
	T=$(gmt grdinfo $CUT -T+a3)

#	Crear Paleta de Colores. Paleta Maestra (-C)
	echo $T  # Mostrar variable T (usada pra makecpt)
	gmt makecpt -Crainbow -D -I $T

#	Crear Imagen a partir de grilla con sombreado
	gmt grdimage $CUT
#	gmt grdimage $CUT -I+a270+nt1

#	Agregar escala de color. Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -DJRM+o0.3c/0+w95%/0.618c+ef -Ba+l"Inclinaci\363n pendiente (@.)"   # en grados
#	gmt colorbar -DJRM+o0.3c/0+w95%/0.618c    -Ba+l"Inclinaci\363n pendiente (@.)"   # en grados

#	Dibujar frame
	gmt basemap -Bxaf -Byaf -BWesN

#	Pintar areas húmedas: Oceanos (-S) y Lagos (-C+l)
	gmt coast -Da -Sdodgerblue2

#	Dibujar Linea de Costa (W1)
	gmt coast -Da -W1/faint

#	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano (+c), 
	gmt basemap -Ln0.88/0.075+c+w100k+f+l

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida
gmt end

	rm tmp_*

#	Ejercicios sugeridos
#	1. Cambiar el valor máximo de la escala de colores.