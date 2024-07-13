# Cambiar carpeta de usuario (GMT_USERDIR)

Para usar otra carpeta hay que setear la "Variable de Entorno" en windows (de forma permanente). Por ejemplo, para poner los datos en una carpeta llamada ".gmt" ubicada en el disco E: puedo hacer lo siguiente:

## Con interfaz gráfica (GUI):
1. Apretar boton de windows y escribir "Advanced system settiings". hacer click.
2. Hacer click en "Environment Variables".
3. En la parte de "System variables" (la mitad de abajo), hacer click en "New ..."
4. En la ventana que se abre escribir en Variable name: GMT_USERDIR y en Variable value buscar el directorio.

## Con CLI (Command line interface):
1. Abrir CMD como superusuario y ejecutar el comando.

setx GMT_USERDIR "E:/.gmt" \M