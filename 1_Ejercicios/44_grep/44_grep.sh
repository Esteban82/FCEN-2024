# GREP: 
# Herramienta para hacer búsquedas globales (g) de expresiones regulares (re) e imprimirlas (p).
# Ideal para buscar/filtrar archivos.
# Analiza el archivo completo (incluyendo encabezados)

# Sintaxis
# grep '<texto-buscado>' <archivo/archivos>


# Archivo de prueba
# ---------------------------------------------
ARCHIVO=ejemplo.txt

cat > $ARCHIVO <<-   EOF
1. hola
2. mundo
3. Esta es la linea tres.
4. Esta es la ultima linea.
5. Nueva linea.
EOF
# ---------------------------------------------

# A. Registro con el texto "linea"
#grep linea $ARCHIVO

# B. Inversa (-v, --invert-match)
#grep linea $ARCHIVO -v

# C. -c (--count): Imprimir el número de líneas de coincidencias 
# Contar la cantidad de registros con el texto linea:
#grep linea $ARCHIVO -c

# D. -A (--after-context): - imprimir las líneas después del patrón coincidente
# 3 regitros posteriores:
#grep tres $ARCHIVO -A 1

# E. -B (--before-context) - imprimir las líneas antes del patrón coincidente
# 2 regitros anteriores:
#grep "la linea" $ARCHIVO -B 2

# F. -C (--context): es igual a -A + -B.
#echo Incluye 1 registro anterior y 1 posterior:
#grep "la linea" $ARCHIVO -C 1

# Borrar archivo de ejemplo
rm $ARCHIVO -f

# Ejemplo Practico
# ----------------------------------------------------------------------------
# Filtrar depositos segun modelo pero con grep
ARCHIVO=../43_awk/e250K.DepositMetalif.csv 

# 1. Buscar registros que contengan el texto:
grep "04c Cu-Au" $ARCHIVO

# 2. Contar la cantidad de depositos:
echo Contar la cantidad de depositos:
grep "04c Cu-Au" $ARCHIVO -c


# Fuente 
# https://www.freecodecamp.org/espanol/news/grep-command-tutorial-how-to-search-for-a-file-in-linux-and-unix-with-recursive-find/
