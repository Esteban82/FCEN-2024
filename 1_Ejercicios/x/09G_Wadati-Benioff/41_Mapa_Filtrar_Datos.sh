#!/usr/bin/env bash
export http_proxy="http://proxy.fcen.uba.ar:8080"
gmt set GMT_DATA_SERVER Brasil

clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=41_Mapa_Filtrar_Datos
	title=$(basename $0 .sh)
	echo $title
 
#	Region Geografica y Proyeccion
	REGION=AR.J				# Region de San Juan
	REGION=-76/-61/-36/-28
	PROJ=M15c

#	Base de datos de GRILLAS
#	DEM=@earth_relief_02m
	DEM=@earth_relief

#	Definir Perfil
#	Coordendas iniciales (1)
#	Long1=-74
#	Lat1=-29
	Long1=-75.02
	Lat1=-33.5
#	Coordenadas finales (2)
#	Long2=-64
#	Lat2=-33
	Long2=-63.65
	Lat2=-31

#	Distancia perpendicular al perfil para filtrar
	DISTANCIA=100k

# 	Nombre archivo de salida
	CUT=tmp_$title.nc
	PERFIL=tmp_perfil.txt
	SISMOS_FILTRADOS=tmp_sismos_filtrados.txt
	MECANIMOS_FILTRADOS=tmp_mecanismos_focales_filtrados.txt

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
	gmt plot Datos/query_*.csv -h1 -i2,1 -Sc0.05c -Gdimgray

#	Mecanismos_Focales. Datos Global CMT. Tamaño Proporcional a la magnitud (-M: Tamaño Homogeneo)
#	gmt meca Mecanismos_Focales/CMT_*.txt -Sd0.12/0 -Gblack

#	Filtrar Sismos y Mecanismos Focales segun distancia a un perfil
#	********************************************************************
#	Definir Perfil A - A'
	cat > $PERFIL <<- END
	$Long1 $Lat1 A
	$Long2 $Lat2 A'
	END

#	Filtrar datos a hasta 100 km del perfil.
	gmt select Datos/query_*.csv -h1 -i2,1,3 -fg -L$PERFIL+d$DISTANCIA+p > ${SISMOS_FILTRADOS}
#	gmt select Mecanismos_Focales/CMT_*.txt  -fg -L$PERFIL+d$DISTANCIA+p > ${MECANIMOS_FILTRADOS}

#	Filtrar datos a un punto
#	--------------------------------
	# Coordenadas de San Juan
	LONG=-68.536389
	LAT=-31.5375
	DISTANCIA=50k
	gmt select Datos/query_*.csv -h1 -i2,1,3 -fg -C$LONG/$LAT+d$DISTANCIA > tmp_punto.txt

#	Crear cpt para sismos 
	gmt makecpt -Crainbow -T0/300 -I

#	Plotear
	gmt plot ${SISMOS_FILTRADOS}    -C -Sc0.05
	#gmt meca ${MECANIMOS_FILTRADOS} -C -Sd0.12/0

#	Dibujar Perfil
	gmt plot $PERFIL -W
	gmt plot $PERFIL -Sc0.2c -Gblack

#	Poner texto del perfil
	gmt text $PERFIL -D0/0.3c -F+f9


#	*********************************

#	Dibujar Escala en -Lg Lon0/Lat0, calculado en meridiano (+c), ancho (+w), elegante(+f)
	gmt basemap -Ln0.9/0.06+w200k+l+f

#	Dibujar frame
	gmt basemap -Bxaf -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

rm	tmp_* gmt.*
