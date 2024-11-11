# Temas a ver. Ejemplos basicos con SED (Stream Editor)
# SED (stream editor) es una herramienta para buscar, reemplazar, insertar y borrar lineas de texto.

# Ejemplos de SED
ARCHIVO=ejemplo.txt

# 0. Ejemplo de ARCHIVO
cat > $ARCHIVO <<-   EOF
1. hola
2. mundo
3. Esta es la linea tres.
4. Esta es la ultima linea.
5. Nueva linea.
EOF

# 1. Ver contenido original en terminal
# cat $ARCHIVO

# 2. Imprimir lineas (p)
# -----------------------------------------------------------------------------
# A. Imprimir primera linea y resto del archivo 
#sed '1p' $ARCHIVO

# A. Solo imprimir primera linea 
# -n: suprime imprimir automaticamente el archivo.
#sed -n '1p' $ARCHIVO

# B. Imprimir ultima linea
#sed -n '$p' $ARCHIVO
# En todos los ejemplos, el resultado se puede guardar en un archivo con >
#sed -n '$p' $ARCHIVO > nuevo_archivo.txt

# C. Imprimir 4 primeras lineas:
#sed -n '1,4p' $ARCHIVO

# D. Imprimir 1 de cada 2 lineas:
#sed -n '1~2p' $ARCHIVO

# E. Imprimir la linea 2, junto con las 2 siguientes:
#sed -n '2,+2p' $ARCHIVO

# 2. Borrar lineas
# -----------------------------------------------------------------------------
# A. Borrar la primera linea
#sed '1d' $ARCHIVO

# B. Borrar las lineas 2 y 3
#sed '2,3d' $ARCHIVO

# C. Borrar todo excepto la primera linea (o sea solo deja la primera)
#sed '1!d' $ARCHIVO

# 3. Buscar y reemplazar patrones
# -----------------------------------------------------------------------------
# A. Reemplaza "es" por "is" la PRIMERA VEZ que aparece en CADA LINEA
#sed 's/es/is/' $ARCHIVO

# 4. Ejemplos practicos
# -----------------------------------------------------------------------------
# A. Reemplazar comas por puntos

# Crear ejemplo
cat > coordenadas.txt <<- END
-70,65 -33,44 Santiago
-68,54 -31,54 San Juan
END

# A. Reemplazar comas por puntos.
#sed 's/,/./' coordenadas.txt  # Reemplaza solo la primera aparación en cada linea.

# B. Reemplazar TODAS las comas por puntos
# g: reemplazo global (o sea TODAS las veces que aparece en la linea)
#sed 's/,/./g' coordenadas.txt 

# C. Reemplazar en el mismo arhivo de entrada (-i)
# -i: trabaja en el mismo archivo de entrada. 
#sed -i 's/,/./g' coordenadas.txt 

# C. Reemplazar puntos por comas
#echo 3.14 1.618 | sed 's/./,/g'

# Da mal. El "." es un comodin que significa cualquier caracter. 
# Por eso reemplaza todo (letras, numeros, simbolos, espacios) por comas.
# Hay que usar una \ para NO usar el comodín
#echo 3.14 1.618 | sed 's/\./,/g'

# D. Reemplaza las , por ;
#sed 's/,/;/g' query.csv

# D. Reemplaza las , por tabulaciones:
#sed 's/,/\t/g' query.csv

# B. Reemplaza una o más instancias de espacios en blanco consecutivos dentro de una línea por un solo espacio.

# Crear ejemplo
echo "Esta es una     línea con espacios.    ">  espacios.txt
echo "    Otra  línea   con   más espacios. ">> espacios.txt

# Mostrar archivo en terminal
#cat espacios.txt

# C. Elimina los espacios en blanco al inicio de cada línea.
#sed 's/^ *//' espacios.txt

# D. Elimina los espacios en blanco al final de cada línea.
#sed 's/ *$//' espacios.txt

# E. Reemplaza múltiples espacios en blanco consecutivos con un solo espacio.
#sed 's/ \{1,\}/ /g' espacios.txt

# F. Combina las 3 opciones anteriores
#sed 's/^ *//;s/ *$//;s/ \{1,\}/ /g' espacios.txt > espacios2.txt

# G. Reemplazar tabulaciones por espacios en un archivo
#sed 's/\t/ /g' tab.txt > espacios.txt

# Borrar arhivos
 rm -f coordenadas.txt $ARCHIVO espacios*.txt

# Comodines:
# ^ = Inicio de una linea
# $ = coincide con el final de linea
# * = coincide con 0 o mas ocurrencias del caractér previo.
# + = coincide con 1 o mas currencias del caractér previo.
# ? = coincide con 0 o 1 ocurrencia del caractér previo.
# . = coincide exactamente con un caractér.