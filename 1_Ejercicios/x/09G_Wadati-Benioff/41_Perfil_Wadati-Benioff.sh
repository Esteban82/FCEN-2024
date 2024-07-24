#!/usr/bin/env bash
export http_proxy="http://proxy.fcen.uba.ar:8080"
gmt set GMT_DATA_SERVER Brasil

#	Temas a ver:
#	1. Hacer perfil topografico.
#	2. Proyectar datos (sismos) en el perfil.
#	3. Graficar mecanismos focales en el perfil.
#	4. Combinar dos perfiles en una figura.

#	Define map
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=41_Perfil_Wadati-Benioff
	title=$(basename $0 .sh)
	echo $title
	
#	Resolucion de la imagen/grilla del mapa base
	RES=01m
	RES=15s

#	Dimensiones del Grafico (en cm): Ancho (L), Altura inferior (H1) y arriba (H2)
	L=15
	H1=5
	H2=2.5

#	Coordendas iniciales (1) y finales del perfil (2)
#	Long1=-74
#	Lat1=-29
	Long1=-75.02
	Lat1=-33.5

#	Long2=-64
#	Lat2=-33
	Long2=-63.65
	Lat2=-31

#	Distancia perpendicular al perfil (en km) y rango de profundidades del perfil (en km)
	Dist_Perfil=500
	DepthMin=0
	DepthMax=300
#	DepthMax=400

#	Base de datos de GRILLAS
	DEM=@earth_relief_${RES}

#	Archivos temporales
	SISMOS_PROYECTADOS=tmp_sismos_proyectados.txt
	PERFIL=tmp_perfil.txt

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
	gmt set FONT_ANNOT_PRIMARY 8,Helvetica,black
	gmt set FONT_LABEL 8,Helvetica,black
	gmt set GMT_VERBOSE w

#	*********************************************************************************************************
#	GRAFICO INFERIOR
#	*********************************************************************************************************
gmt begin $title png

#	Calcular largo (en km) del perfil y crear variable
	KM=$(echo $Long1 $Lat1 | gmt mapproject -G$Long2/$Lat2+uk -o2)
	echo $KM

#	Grafico inferior (Longitud vs Profundidad) con sismos y mecanismos focales
#	-----------------------------------------------------------------------------------------------------------
#	Crear Grafico
	gmt basemap -R0/$KM/$DepthMin/$DepthMax -JX$L/-$H1 -B+n

#	Ejes X (Sn) e Y
	gmt basemap -Bxaf+l"Distancia (km)" -Byaf+l"Profundidad (km)" -BwESn

#	Filtrar Sismos y Mecanismos Focales por Region2
#	********************************************************************
#	Filtrar y Proyectar los Sismos al perfil/circulo maximo. 
#		-W: Distancia hacia los costados. 
#		-Lw: Solo incluye datos hacia los costados. 
#		-Q: Datos de -C y -E en coordenadas geograficas
#		-S: Ordena los datos. 
	gmt project Datos/query_*.csv -h1 -i2,1,3 -C$Long1/$Lat1 -E$Long2/$Lat2 -Q -W-$Dist_Perfil/${Dist_Perfil}k -Lw -S > ${SISMOS_PROYECTADOS}

#	Crear paleta de colores para magnitud de sismos
	gmt makecpt -Crainbow -T$DepthMin/$DepthMax -I

#	Plotear Sismos en perfil distancia vs profundidad
	gmt plot ${SISMOS_PROYECTADOS} -C -Sc0.05c -i3,2,2

#	Plotear Mecanismos Focales en un perfil
#	-Aa: Definir perfil
#	-Q: NO produce archivos de informacion.
	gmt coupe Mecanismos_Focales/CMT_* -Sd0.15/0 -Gred -M -Aa$Long1/$Lat1/$Long2/$Lat2+w$Dist_Perfil+z$DepthMin/$DepthMax -Q

#	*********************************************************************************************************
#	GRAFICO SUPERIOR
#	*********************************************************************************************************
#	Perfil: Crear archivo para dibujar perfil (Long Lat)
	cat > tmp_line <<- END
	$Long1 $Lat1
	$Long2 $Lat2
	END

#	Interpolar: agrega datos en el perfil cada 0.2 km (-I).
	gmt sample1d tmp_line -I$RES > tmp_sample1d -fg

#	Crear variable con region geografica del perfil
	REGION=$(gmt info tmp_sample1d -I+e0.1)
	echo $REGION

#	Distancia: Agrega columna (3a) con distancia del perfil en km (-G+uk)
	gmt mapproject tmp_sample1d -G+uk > tmp_track

#	Agrega columna (4) con datos extraidos de la grilla -G (altura) sobre el perfil
	gmt grdtrack tmp_track -G$DEM $REGION > $PERFIL

#	Datos para el perfil:
#	-------------------------------------------------
#	Altura (km) minima y maxima:
#	Min=-6.2
#	Max=5.3

#	Obtener minimo y maximo (en la terminal)
#	gmt info $PERFIL -C -o6
#	gmt info $PERFIL -C -i3 -o0
#	gmt info $PERFIL -C -i3+d1000 -o0

#	Crear variables con minimo y maximo (valores dividos por 1000)
	Min=$(gmt info $PERFIL -C -i3+d1000 -o0)
	Max=$(gmt info $PERFIL -C -i3+d1000 -o1)
	
#	Crear Grafico con desplazamiento en Y
	gmt basemap -R0/$KM/$Min/$Max -JX$L/$H2 -B+n -Y$H1

#	Dibujar Ejes XY
	gmt basemap -Bxf -Byaf+l"Elevaciones (km)" -BwESn

#	Dibujar datos de Distancia y elevaciones (pasado de m a km) (columnas 3 y 4; -i2,3)
	gmt plot $PERFIL -W0.5,darkblue -i2,3+d1000

#	Coordenadas Perfil (A, A')
	echo A  | gmt text -F+cTL+f12p -Gwhite -W1
	echo A\'| gmt text -F+cTR+f12p -Gwhite -W1

#   ----------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end


# Mapa auxiliar
Dist=100k
REGION=-75.2/-63/-34.44/-30.35	# Map Region

# Filter Focal Mechanism. Create file with data Inside/Outside.
gmt select Mecanismos_Focales/*.txt -Ltmp_line+d$Dist+p -fg > coupe_I.gmt
#gmt select @GCMT_1976-2017_meca.gmt -Ltmp_profile+d$Dist+p -fg > coupe_O.gmt -Il
gmt select Datos/query_*.csv -h1 -i2,1,3 -Ltmp_line+d$Dist+p -fg > Sismos_dentro.gmt


gmt begin mapa png
	gmt grdimage $DEM -Coleron -I+nt1.2 -R$REGION -JM15c -Baf
	gmt coast -Df -N1/0.5p -Bf
	gmt makecpt -T0/$DepthMax -Chot -I
	gmt plot Datos/query_*.csv -h1 -i2,1 -Sc0.05c -Ggray
	gmt plot Sismos_dentro.gmt -Sc0.05c -C
	gmt plot tmp_line -W2p,red
	gmt plot tmp_line -Sc0.25c -Gred
	gmt colorbar -C -DjBR+o0.75c/0.4c+w60%/0.4c+r -Baf+l"Depth (km)" -F+p+gwhite+s+r
	gmt meca Mecanismos_Focales/CMT_*.txt   -Sd0.15/0
	gmt meca coupe_I.gmt                    -Sd0.15/0 -Gorange
gmt end

	rm tmp_* gmt.*