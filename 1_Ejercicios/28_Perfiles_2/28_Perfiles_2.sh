#!/bin/bash
clear

#	Temas a ver:
#	1. Graficar varios perfiles

#	Define map
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=26_Perfiles_2
	title=$(basename $0 .sh)
	echo $title

#	Dimensiones del Grafico: Longitud (L), Altura (H).
	L=15
	H=5

#	Resolucion de la grilla (y del perfil)
	RES=01m

#	Base de datos de GRILLAS
	GRD0=@earth_relief_${RES}_p
	GRD1=@earth_faa_01m_p		# Free Air Anomalies
#	GRD1=@earth_vgg_01m_p		# Vertical Gravity Gradient
#	GRD1=@earth_mag4km_02m_p	# EMAG2 a 4 km de altitud
#	GRD1=@earth_geoid_01m_g		# Geoide

	PERFIL=tmp_perfil.txt

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Calcular Distancia a lo largo de la linea y agregar datos geofisicos
#	-----------------------------------------------------------------------------------------------------------
#	Perfil: Crear archivo para dibujar perfil (Long Lat)
	cat > tmp_line.txt <<- END
	-76 -32
	-46 -32
	END

#	Interpolar datos (-I)
	gmt sample1d tmp_line.txt -I$RES > tmp_sample1d.txt -fg

#	Crear variable con region geografica del perfil
	REGION=$(gmt info tmp_sample1d.txt -I+e0.1)
	echo $REGION

#	Distancia: Agrega columna (3a) con distancia del perfil en km (-G+uk)
	gmt mapproject tmp_sample1d.txt -G+uk > tmp_track.txt

#	Agrega columna (4) con datos extraidos de la grilla -G (altura) sobre el perfil
#	gmt grdtrack tmp_track.txt -G$DEM $REGION >  $PERFIL
	gmt grdtrack tmp_track.txt -G$GRD0 -G$GRD1 $REGION > $PERFIL
		
#	Hacer Grafico y dibujar perfil
#	-----------------------------------------------------------------------------------------------------------
#	Informacion para crear el grafico. 3a Columna datos en km. 4a Columna datos de Topografia.
	gmt info $PERFIL

#	Crear Grafico
#	-------------------------------------------------
#	Setear dimensiones del grafico
	gmt basemap -JX$L/$H -R0/1/0/1 -B+n

#	Dibujar perfil 1
	COLOR=blue
	gmt plot -Re $PERFIL -W0.5,$COLOR -i2,3 -l"Topopgrafia"
	gmt basemap -Byag+l"Elevaciones (m)"              -BW --FONT_ANNOT_PRIMARY=8,Helvetica,$COLOR

#	Dibujar Perfil 2
	COLOR=red
	gmt plot -Re $PERFIL -W0.5,$COLOR  -i2,4 -l"Aire Libre"
	gmt basemap -Bya+l"Anomal\355a Aire Libre (mGal)" -BE --FONT_ANNOT_PRIMARY=8,Helvetica,$COLOR

#	Dibujar Eje X (Sn)
	gmt basemap -Bxaf+l"Distancia (km)" -BSn

#	Coordenadas Perfil (E, O)
	echo O | gmt text -F+cTL+f14p -Gwhite -W1
	echo E | gmt text -F+cTR+f14p -Gwhite -W1

#	Ubicar leyenda
	gmt legend -DjTR+o0.5c -F+gwhite+pthicker # --FONT_ANNOT_PRIMARY=14p,Helvetica-Bold

#   ----------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

#	Borrar achivos temporales
	rm tmp_* -f

#	Ejercicios sugeridos
#	1. Cambiar la segunda grilla y ajusta