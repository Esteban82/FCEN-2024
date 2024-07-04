# Tarea 1

**Objetivo**: Instalar GMT y comprobar que todo está correctamente configurado en su PC.

Mira el siguiente video con las indicaciones para la instalación de los programas necesarios
y la comprobación de su correcto funcionamiento.

Siga los siguientes pasos para ejecutar algunos scripts de GMT y comprobar
que obtiene el mapa y la animación correctos.


## Instalar los programas

1. Siga las [instrucciones de instalación](Instalacion.MD).


## Descargar repositorio

1. Seleccione la carpeta de su computadora donde quiere descargar el material de este repositorio. 
2. Abra una terminal (Mac: abre el app "Terminal"; Windows: abre "Git Bash").
   Los siguientes pasos deben hacerse en la terminal.
   Para correr un comando, escribelo y luego presiona *Enter*.
3. Corra este comando para descargar el material del curso usando [git](https://en.wikipedia.org/wiki/Git):

   ```
   git clone https://github.com/Esteban82/FCEN-2024.git
   ```

   Esto creará una carpeta llamada `FCEN-2024` en su computadora.

4. Ejecutar el siguiente comando para ingresar a la carpeta con los scripts:

   ```
   cd FCEN-2024/0_Instalacion
   ```

5. Ejecute el script [`prueba_0.sh`](prueba_0.sh):

   ```
   bash prueba_0.sh
   ```

   Al finalilzar, una ventana con el siguiente mapa de sudamérica debería abrirse (en Mac puede verse mas suave):

   ![`FCEN-2024/0_Instalacion/salida/prueba_0.png`](salida/prueba_0.png)

6. Ejecute el script [`prueba_1.sh`](prueba_1.sh):

   ```
   bash prueba_1.sh
   ```

   Esto debe producir los siguientes archivos en la carpeta `FCEN-2024/0_Instalacion`:
   
   *`prueba_1.mp4`
   *`prueba_1.gif`

   El resultado es una animación con números contando de 0 a 24 que luce como:

   ![`FCEN-2024/0_Instalacion/salida/prueba_1.mp4`](salida/prueba_1.gif)

7. Si tuvo algún problema para obtener los archivos, por favor avisenos a traves de slack.

## Actualizar repositorio

El material del curso (todo lo includio en este repositorio) se actualizará con el paso de las clases. 

Para actualizarlo en tu pc sigue los siguientes pasos:


1. Ve a la carperta `FCEN-2024` previamente descargada en su computadora.

2. Abre una terminal (Mac: abre el app "Terminal"; Windows: abre "Git Bash").
   Los siguientes pasos deben hacerse en la terminal.
   Para correr un comando, escribelo y luego presiona *Enter*.

3. Finalmente corra el siguiente comando para actualizar su carpeta (repositorio local). Esto puede sobrescribir los scripts originales si los modificó. Se sugiere trabajar en otra carpeta fuera de la carpeta original.

   ```
   git pull
   
   ```
