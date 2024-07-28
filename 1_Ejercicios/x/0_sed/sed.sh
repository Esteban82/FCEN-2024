# Ejemplos de SED
ARCHIVO=ejemplo.txt

cat > $ARCHIVO <<-   EOF
1. hello
2. world
3. This is line three.
4. Here is the final line.
5. Nueva linea
EOF

echo Archivo original:
cat $ARCHIVO

# 1. Imprimir lineas (p)
#echo '1p' -n Imprimir primera linea 
#sed -n '1p' example.txt

echo -n '$p' Imprimir ultima linea:
sed -n '$p' $ARCHIVO

echo -n '1,4p' Imprimir 4 primeras lineas:
sed -n '1,4p' $ARCHIVO

echo -n '1~2p' Imprime 1 linea de cada 2.
sed -n '1~2p' $ARCHIVO

echo -n '2,+2p' Imprime linea 2, junto con las 2 siguientes
sed -n '2,+2p' $ARCHIVO

# 2. Borrar lineas
#echo '1d' Borra la primera linea 
#sed '1d' $ARCHIVO

#echo '2,3d' Borra las lineas 2 y 3
#sed '2,3d'$ARCHIVO

#echo '1!d' Borra todo excepto la primera linea (o sea solo deja la primera)
#sed '1!d' $ARCHIVO

# -i: trabaja en el mismo archivo de entrada. 

# 3. Buscar y reemplazar patrones
#sed -i 's/hello/hola/g' $ARCHIVO
#echo sed 's/hello/hola/g'
#sed 's/hello/hola/g' $ARCHIVO
echo sed 's/is/es/'
sed 's/is/es/' $ARCHIVO

echo sed 's/is/es/g'
sed 's/is/es/g' $ARCHIVO

rm $ARCHIVO

echo Reemplazar puntos por comas sed 's/./,/g'
sed 's/./,/g' example.txt 
echo Da mal. El "." es un comodin que significa cualquier caracter. Por eso reemplaza todas las letras, incluidos los espacios por ,.
sed 's/\./,/g' example.txt



#sed -i "s/^ *//;s/ *$//;s/ \{1,\}/ /g" *.txt
