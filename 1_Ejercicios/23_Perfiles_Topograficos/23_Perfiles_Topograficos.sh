#!/bin/bash
clear

# 	Temas a ver:
#	1. Dibujar multiples perfiles (creando un archivo multisegmento)
#	2. Definir propiedades de la linea desde el archivo de entrada.

#	Define map
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	#title=23_Perfil_Topografico
	title=$(basename $0 .sh)
	echo $title
	
#	Dimensiones del Grafico: Longitud (L), Altura (H).
	L=15
	H=5

#	Resolucion de la grilla (y del perfil)
	RES=15s
#	RES=05m

#	Base de datos de GRILLAS
	DEM=@earth_relief_$RES

	PERFIL=tmp_perfil.txt

#	0. Crear perfil
#	-----------------------------------------------------------------------------------------------------------
#	Datos de Longitud y Latitud
	cat > tmp_line.txt <<- END
	#Long Lat
	> -Wred
	-76 -32
	-46 -32
	> -Wblack
	-76 -35
	-46 -35
	END

#	1. Pre procesar datos:
#	Calcular Distancia a lo largo de la linea y agregar datos geofisicos
#	-----------------------------------------------------------------------------------------------------------
#	1A. Interpolar: agrega datos en el perfil (-I).
#	gmt sample1d tmp_line.txt -I0.2k > tmp_sample1d.txt -fg		# Datos cada 0,2 km
	gmt sample1d tmp_line.txt -I$RES > tmp_sample1d.txt -fg		# Datos segun Resolucion

#	1B. Agrega columna (3a) con distancia del perfil en km (-G+uk)
	gmt mapproject tmp_sample1d.txt -G+uk+a > tmp_track.txt

#	1C. Agregar datos de altura al perfil:
#	1C1. Crear variable con region geografica del perfil
	REGION=$(gmt info tmp_sample1d.txt -I+e0.1)

#	1C2. Agrega columna (4) con datos extraidos de la grilla -G (altura) sobre el perfil
	gmt grdtrack tmp_track.txt -G$DEM $REGION > $PERFIL

#	Auxiliar: Mapa de ubicacion del perfil
gmt begin mapa png
	gmt grdimage $REGION @earth_relief -JM15c -Baf
	gmt plot $PERFIL -Wred
gmt end

#	2. Hacer Grafico y dibujar perfil
#	-----------------------------------------------------------------------------------------------------------
gmt begin $title png

#	Informacion para crear el grafico. 3a Columna datos en km. 4a Columna datos de Topografia.
	gmt info $PERFIL

#   Definir dominio de los datos para el perfil
    D=e         # Dominio exacto de los datos
#   D=a         # Dominio automatico (con valores redondeados ligeramente mayores)

#	Dibujar datos de columnas 3a y 4a (-i2,3)
	gmt plot $PERFIL -JX$L/$H -R$D -W0.5,blue -i2,3  

#	Dibujar Eje X (Sn)
	gmt basemap -BSn -Bxaf+l"Distancia (km)"

#   Dibujar Eje Y (eW)
	gmt basemap -BwE -Byafg+l"Altura (m)"

#	Coordenadas Perfil (E, O)
	echo O | gmt text -F+cTL+f14p -Gwhite -W1
	echo E | gmt text -F+cTR+f14p -Gwhite -W1

#	Agregar Escala (grafica)
	gmt basemap -LjCB+w200+lkm+o0/0.5		# Escala (horizontal)
	gmt basemap -LjCB+w1000+lm+o1.2/0.67+v	# Escala vertical (+v)

# 	Obtener informacion de la escala en la terminal y de la exageracion vertical.
	gmt basemap -B+n -Vi

#	Ver informacion de la exageracion vertical (E.V) en la terminal y graficarla en el perfil	
	echo E.V.: 0.08 | gmt text -F+cBR+f10p -Gwhite -W1

#   ----------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

#	Borrar archivos temporales
#	-----------------------------------------------------------------------------------------------------------
	rm tmp_* gmt.* -f

# Ejercicios sugeridos
# 1. Agregar mas perfiles.
# 2. Modificar los colores de las lineas.
# 3. Agregar otras propiedades de la linea en el archivo de entrada (ancho y estilo).