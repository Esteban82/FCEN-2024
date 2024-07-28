# Ejemplos de AWK

# AWK es una lenguaje de programación para procesar datos.
# Muy util para trabajar con tabla de datos.

# Archivo de prueba
# ---------------------------------------------
# Archivo txt (campos separado espacios)
ARCHIVO=sismos.txt

# ---------------------------------------------
# 0. Inspeccionar archivo
# gmt info permite ver que GMT lea bien el archivo
#gmt info $ARCHIVO

# 1. Imprimir todos los registros (o lineas) completas ($0)
#awk '{print $0}' $ARCHIVO
# El mismo resultados que:
#cat $ARCHIVO

# 2. Imprimir solo algunas columnas
# A. Imprimir columna 1 ($1).
#awk '{print $1}' $ARCHIVO

# B. Columna Final ($NF)
#awk '{print $NF}' $ARCHIVO

# C. Columna 2 y final (separadas en columnas)
#awk '{print $2,$NF}' $ARCHIVO

# C. Columna 2 y final (juntos en una misma columna)
#awk '{print $2$NF}' $ARCHIVO

# D. Agregar el Numero de Registro ()
#awk '{print NR, $2}' $ARCHIVO 

# E. Lo mismo pero agregando texto.
#awk '{print "El numero de registro es el " NR " y su valor es: "$2}' $ARCHIVO 


# 3. Usar un CSV (comma separated values)
# -----------------------------------------------------------------
# Archivo CSV
#CSV=../../42_sed/query.csv
CSV=query.csv

# A. Imprimo columna 1 pero obtengo todo el archivo! 
#awk '{print $1}' $CSV
#echo "Imprime TODAS las columnas. No identifica a la coma como separador de campo (FS)"

# B. Especificar la , como FS (-F",")
#awk -F"," '{print $5}' $CSV

# C. Realizar operaciones matematica
#awk -F"," '{print $5*10}' $CSV

# -----------------------------------------------------------------
# 3. Filtrar datos
# A. Sismos con magnitud (campo 5) mayor o igual a 7
#awk -F"," '$5>=7' $CSV

# Filtrar y solo mostrar un campo
#awk -F"," '$5>=7 {print $5}' $CSV
#awk -F"," '$5>=7 {print $1}' $CSV

# ... y luego usar sed para borrar linea 1
#awk -F"," '$5>=7 {print $5}' $CSV | sed '1d'

# ... y luego usar sort para ordenar
awk -F"," '$5>=6.5 {print $5}' $CSV | sed '1d' | sort

# Fuente 
# https://sio2sio2.github.io/doc-linux/03.scripts/06.misc/04.awk.html
# https://www.youtube.com/watch?v=YFlEY_4gUVs
