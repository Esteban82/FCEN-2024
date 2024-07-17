#!/usr/bin/env bash

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
#	title=Pendiente
	title=$(basename $0 .sh)
	echo $title

#	Region: Argentina
	REGION=-72/-64/-35/-30

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Grilla 
	GRD=@earth_relief_30s

# 	Nombre archivo de salida
	CUT=tmp_$title.nc

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n 

#	Calcular grilla de pendientes
#	---------------------------------------------
#	Recortar Grilla
	gmt grdcut $GRD -G$CUT -R$REGION

#	Calcular Grilla con modulo del gradiente (-D) con datos geograficos (-fg)
	gmt grdgradient $CUT -D -S$CUT -fg

#	Convertir modulo del gradiente a inclinacion (porcentaje)
	gmt grdmath $CUT 100 MUL = $CUT
#	---------------------------------------------

#	Crear Paleta de Colores. Paleta Maestra (-C)
	gmt makecpt -Crainbow -D -I -T0/40

#	Crear Imagen
	gmt grdimage $CUT -I+a270+nt1

#	Agregar escala de color. Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -DJRM+o0.3c/0+w95%/0.618c+ef -Ba+l"Inclinación pendiente (\045)"  # en %

#	Dibujar frame
	gmt basemap -Bxaf -Byaf -BWesN

#	Pintar areas húmedas
	gmt coast -Da -Sdodgerblue2

#	Dibujar Linea de Costa (W1)
	gmt coast -Da -W1/faint

#	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano (+c), 
	gmt basemap -Ln0.88/0.075+c-32:00+w100k+f+l

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

	rm tmp_*
