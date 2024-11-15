#!/usr/bin/env bash
clear

#	Temas a ver
#	1. Agregar efecto de sombreado a una imagen satelital.
#	2. Usar auto-resolution de los datos remotos.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=18_Satelital_Sombreado
	title=$(basename $0 .sh)
	echo $title

#	Proyeccion y Region
	PROJ=M15c
	PROJ=N15c
#	REGION=-85/-54/9/26
	REGION=BR
#	REGION=-73/-65/-35/-30
#	REGION=AR.A
	REGION=d

#	Datos
	RELIEVE=@earth_relief
	IMG=@earth_day	# Imagen satelital
	#IMG=@earth_faa	# Anomalias de Aire Libre

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Descargar DEM para la region. Resolucion definida automaticamente.
	gmt grdcut $RELIEVE -Gtmp_cut.nc -R$REGION -J$PROJ  # Agrego -R y -J para que automaticamente elija la resolución ideal.

#	Sombreado a partir del DEM
	gmt grdgradient tmp_cut.nc -Nt0.8 -A45 -Gtmp_intes -R$REGION

#	Graficar Imagen Satelital
#	gmt grdimage @earth_day
	gmt grdimage $IMG -Itmp_intes

#	Dibujar Paises (1 paises, 2 estados/provincias en America, 3 limite maritimo)
	gmt coast -N1/0.2,- 

#	Dibujar Linea de Costae
	gmt coast -W1/ 

#	Dibujar marco del mapa 
	gmt basemap -Bxaf -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end #show

# Borrar archivos temporales
rm tmp_* -f