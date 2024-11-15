#!/usr/bin/env bash

#	Temas a ver:
#	1. Definir regiones del mapa con codigos ISO 3166
#	2. Proyecciones cilìndricas (UTM, Mercator)
#	3. Simbolos, lineas y poligonos en GMT (color, ancho, estilo).

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=04_MapaPolitico_Argentina
	echo $title

#	Region: Argentina
#	Region: codigos ISO
	REGION=AR
	
#	Proyecciones Cilindricas: 
#	C(y)lindrical equal area: Lon0/lat0/Width
#	Miller cylindrical (J): Lon0/Width
#	(M)ercartor, E(q)udistant cilindrical, (T)ransverse Mercator: (Lon0(/Lat0/))Width
#	(U)TM: Zone/Width
#	PROJ=J-65/13c
	PROJ=T-60/-30/13c
#	PROJ=M15c
#	PROJ=U-20/13c

#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Pintar areas húmedas: Oceanos (-S) y Lagos (-C+l) y Rios-Lagos (-C+r)
	color=dodgerblue2
	gmt coast -Da -S$color -Cgreen+l -Cred+r

#	Resaltar paises DCW (AR: Argentina soberana, FK: Malvinas, GS: Georgias del Sur y Sandwich del Sur)
	gmt coast -EAR,FK,GS+grosybrown2+p

#	Dibujar Bordes Administrativos. N1: paises. N2: Provincias, Estados, etc. N3: limites marítimos (Nborder[/pen])
	gmt coast -Da -N1/0.75
#	gmt coast -Da -N2/0.25,-.

#	Dibujar Linea de Costa (level/, where level is 1-4 and represent coastline, lakeshore, island-in-lake shore, and lake-in-island-in-lake shore)
	gmt coast -Da -W1/0.25

#	Datos Instituto Geografico Nacional Argentino (IGN)
#	-----------------------------------------------------------------------------------------------------------
#	Descripcion plot: Lineas (-Wpen), Puntos (-Ssímbolo/size), Relleno simbolos o polígonos (-Gfill).
#	-G: pinta el area definida por los puntos.
#	-G y -W: Pinta el área y dibuja las lineas del borde
#	-W: Dibuja las lineas del borde 
#	-S: dibuja los simbolos sin relleno
#	-S -G: dibuja simbolos con relleno
#	-S -W -G: dibuja simbolos con relleno y borde

#	Cursos y Cuerpos de Agua
	#URL="https://dnsg.ign.gob.ar/apps/api/v1/capas-sig/Hidrograf%C3%ADa+y+oceanograf%C3%ADa/Aguas+continentales/lineas_de_aguas_continentales_perenne/shp"
	#gmt which -Gc $URL
	#gmt plot "IGN/areas_de_aguas_continentales_perenne.shp" -G$color
	#gmt plot "IGN/lineas_de_aguas_continentales_perenne.shp" -Wfaint,blue  # Descargar archivo desde el IGN

#	Limites Interprovincial
	gmt plot "IGN/linea_de_limite_070111.shp" -Wthinner,black,-.

# 	Red vial y ferroviaria
	gmt plot "IGN/RedVial_Autopista.gmt"        		   -Wthinnest,black
	gmt plot "IGN/RedVial_Ruta_Nacional.gmt"    		   -Wthinnest,black
	gmt plot "IGN/RedVial_Ruta_Provincial.gmt"  		   -Wfaint,black
	gmt plot "IGN/lineas_de_transporte_ferroviario_AN010.shp"  -Wthinnest,darkred

#	Pueblos y Ejidos Urbanos. -SsimboloTamaño. Simbolos: A (star), C (Círculo), D (Diamante), G (octagono), H (hexagono), I (triangulo invertido), N (pentagono), S (cuadrado), T (triangulo).
#	Tamaño: diámetro del círculo (Mayuscula: misma área que el circulo; Minúscula (diámetro del círculo que abarca a las símbolos)
	gmt plot "IGN/puntos_de_asentamientos_y_edificios_localidad.shp" -Sc0.04 -Ggray19
	gmt plot "IGN/areas_de_asentamientos_y_edificios_020105.shp"     -Wfaint -Ggreen

#	Dibujar frame
	gmt basemap -Baf
	gdalwarp -s_srs +proj=merc cara.tif carageo.tiff

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end #show

#	Ejercicios Sugeridos:
#	1. Ejercicio de combinación de argumentos -S -G -W para dibujar símbolos, líneas y áreas (lineas 77 a 83).
#	2. Dibujar los pueblos con distintos símbolos (estrella, cuadrado, círculo).
#	3. Descargar otro shp del IGN (o de otro repositorio) y graficarlo. 
#	Sitio Web: https://www.ign.gob.ar/NuestrasActividades/InformacionGeoespacial/CapasSIG