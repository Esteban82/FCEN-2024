#!/bin/bash

# Tutorial de como usar el nombre del propio script como variable

#	Obtener nombre del script
#	1. Mostrar nombre completo
	echo "Nombre del Script:"
	echo $0

#	2. Usar basename para quitar el extension .sh	
	echo "Nombre del Script sin extension (.sh):"
	basename $0 .sh

#	3. Asignar nombre a una variable y usarla 
	title=$(basename $0 .sh)
	echo "Valor de la variable title:"	
	echo $title

# Ejercicio sugerido:
# 1. Cambiar el nombre del script y ver como cambia la información volcada en la terminal.