#!/usr/bin/env bash
clear

# Temas a ver: 
# 1. Dibujar perfil con texto en un mapa.
# 2. Filtrar datos segun distintos criterios.
# 3. Dibujar simbolos personalizados (custom)

#export http_proxy="http://proxy.fcen.uba.ar:8080"
#gmt set GMT_DATA_SERVER Brasil

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=39_Mapa_Filtrar_Datos
	title=$(basename $0 .sh)
	echo $title

#	Distancia perpendicular al perfil para filtrar
	DISTANCIA=100k

#	Region Geografica y Proyeccion
	REGION=-76/-61/-36/-28
	PROJ=M15c

#	Base de datos de GRILLAS
#	DEM=@earth_relief_02m
	DEM=@earth_relief
	SISMOS=../33_Heatmap/Datos/query_*.csv 

# 	Nombre archivo de salida
	CUT=tmp_$title.nc
	PERFIL=tmp_perfil.txt
	PUNTO=tmp_puntos.txt
	SISMOS_FILTRADOS=tmp_sismos_filtrados.txt


#	-----------------------------------------------------------------------------------------------------------
#	Abrir archivo de salida (ps)
gmt begin $title png

#	Recortar Grilla
	gmt grdcut $DEM -G$CUT -R$REGION -J$PROJ

#	Crear CPT Mapa Fondo 
	gmt makecpt -T-11000,0,9000 -Cdodgerblue2,white

#	Crear Imagen a partir de grilla con sombreado
	gmt grdimage $CUT -I

#	Dibujar Bordes Administrativos
	gmt coast -Da -N1/0.30
	gmt coast -Da -N2/0.25,-.

#	Mapear todos los datos
#	********************************************************************
#	Dibujar. Tamaño fijo. Color según profundidad o color fijo
	gmt plot $SISMOS -h1 -i2,1 -Sc0.05c -Gdimgray

#	1. Filtrar Sismos segun distancia a un perfil
#	********************************************************************
#	Definir Perfil A - A'
	cat > $PERFIL <<- END
	-75 -33.5 A
	-64 -30 A'
	END

#	Filtrar datos a hasta 100 km del perfil.
	gmt select $SISMOS -h1 -i2,1 -fg -L$PERFIL+d$DISTANCIA+p > ${SISMOS_FILTRADOS}

#	Plotear
	gmt plot ${SISMOS_FILTRADOS} -Gred -Sc0.05

#	Dibujar Perfil en el mapa
	gmt plot $PERFIL -Wthicker,violet
	gmt plot $PERFIL -Sc0.2c -Gviolet

#	Poner texto del perfil
	gmt text $PERFIL -D0/0.3c -F+f9

#	2. Filtrar datos a un punto
#	********************************************************************
#	Definir ciudades
	cat > $PUNTO <<- END
	-70.65 -33.4375 Santiago
	-68.536389 -31.5375 San Juan
	END

	DISTANCIA=100k

#	Seleccionar y graficar sismos	
	gmt select $SISMOS -h1 -i2,1 -fg -C$PUNTO+d$DISTANCIA | gmt plot -Ggreen -Sc0.05

#	Dibujar puntos
	gmt plot $PUNTO -Skcity/0.5c -Ggreen -W
	gmt text $PUNTO -D0/0.5c -F+f9
#	*********************************

#	3. Filtrar datos a un poligoono
#	********************************************************************
	gmt coast -EAR.M -M > tmp_poligono # Mendoza

#	Seleccionar y graficar sismos	
	gmt select $SISMOS -h1 -i2,1,3 -fg -Ftmp_poligono | gmt plot -Gblue -Sc0.05

#	4. Filtrar datos segun rasgo geografico (-N)
#	********************************************************************
# 	Datos en tierra
#	gmt select $SISMOS -h1 -i2,1 -fg -Ns/k | gmt plot -Gred -Sc0.05
# 	Datos en agua
	gmt select $SISMOS -h1 -i2,1 -fg -Nk/s | gmt plot -Gorange -Sc0.05	

#	Dibujar Escala en -Lg Lon0/Lat0, calculado en meridiano (+c), ancho (+w), elegante(+f)
	gmt basemap -Ln0.9/0.06+w200k+l+f

#	Dibujar frame
	gmt basemap -Bxaf -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

# Borrar archivos temporales
rm	tmp_* gmt.* -f

# Simbolos personalizados

# Ejercicios sugeridos
# 1. Cambiar los simbolos personalizados para las ciudades
# https://docs.generic-mapping-tools.org/dev/reference/custom-symbols.html#app-custom-symbols
 