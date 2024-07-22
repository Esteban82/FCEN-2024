#!/bin/bash
clear

#	Temas a ver
#	1. Dibujar perfil sobre el mapa (wiggle).

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
#	title=27_Mapa_Perfil
	title=$(basename $0 .sh)
	echo $title

#	Region y Proyección del mapa
	REGION=-78/-44/-38/-29
	PROJ=M15c

#	Resolucion de la grilla (y del perfil)
	RES=15s

#	Grilla para el mapa
	DEM=@earth_relief

# 	Grilla para extraer los datos
	GRD=@earth_relief_$RES	# Misma grilla topografica
#	GRD=@earth_faa_01m		# Anomalias de Aire Libre

# 	Nombre archivo de salida
	CUT=tmp_$title.nc
	PERFIL=tmp_data.txt

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Mapa Base
#	********************************************************************
#	Crear Imagen a partir del DEM con sombreado
	gmt grdimage $DEM -Cgeo -I

#	Agregar escala vertical a partir de CPT (-C). Posicion (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -DJRM+o0.3c/0+w95%/0.618c -C -Ba+l"Elevaciones (km)" -I -W0.001

#	Dibujar frame
	gmt basemap -Bxaf -Byaf

#	********************************************************************
#	Perfil 
#	-----------------------------------------------------------------------------------------------------------
#	Perfil: Crear archivo para dibujar perfil (Long Lat)
	cat > tmp_line.txt <<- END
	-76 -32
	-46 -32
	>
	-76	-35
	-46 -35
	END

#	Interpolar: agrega datos en el perfil segun resolucion de la grilla.
	gmt sample1d tmp_line.txt -I$RES -fg     > tmp_sample1d.txt
#	gmt sample1d tmp_line.txt -I$RES -fg -Am > tmp_sample1d.txt

#	Crear variable con region geografica del perfil
#	Si se trabaja con datos remotos con alta resolucion, conviene definir
#	la region. Caso contrario, se descargan todos los datos disponibles.	
	REGION=$(gmt info tmp_sample1d.txt -I+e0.1)
	echo $REGION

#	Agregar columna con datos extraidos de la grilla
	gmt grdtrack tmp_sample1d.txt -G$GRD $REGION > $PERFIL

#	Dibujar Perfil
#	gmt plot $PERFIL -W0.5,black

#	Dibujar Perfil en el mapa. Z: Escala (metros/cm).
#	Menor escala (Z), mayor Exageracion vertical
#	gmt wiggle $PERFIL -Z10000c -W                    								# Dibujar solo linea
#	gmt wiggle $PERFIL -Z5000c -W                    								# Dibujar solo linea
#	gmt wiggle $PERFIL -Z5000c -W -Gred			  									# Pintar areas positivas (-G+p)
#	gmt wiggle $PERFIL -Z5000c -W -Gred+p    -Gblue+n     							# Pintar también negativas (-G+n)
#	gmt wiggle $PERFIL -Z5000c -W -Gred+p    -Gblue+n    -T  						# Agregar linea base (-T)
#	gmt wiggle $PERFIL -Z5000c -W -Gred+p    -Gblue+n    -T -DjRB+o0.1/0.1+w500+lm 	# Agregar escala
	gmt wiggle $PERFIL -Z5000c -W -Gred@50+p -Gblue@50+n -T -DjRB+o0.1/0.1+w500+lm  # Agregar transaparencia.
#	********************************************************************

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

	rm tmp_* gmt.* -f

# 	Ejercicios sugeridos
#	1. Cambiar las coordenadas de inicio y fin del perfil.
#	2. Cambiar a la grilla de anomalias de aire libre (faa en linea 25)
#	3. Ajustar los parametros del perfil wiggle para que se observen bien las anomalias de Aire Libre
