# Retro

## Escaneo de puertos

Ejecutamos el siguiente comando de`nmap`para identificar los puertos abiertos de la máquina vulnerable.

```
nmap -sV -sC 10.10.148.134
```

Tenemos dos servicios funcionando en la máquina obtenido: El puerto 80 de HTTP y el 3389 de RDP.

![Imagen](./images/Pasted_image_20250221173916.png)

## Fuzzing web

Accedemos a la página web.

![Imagen](./images/Pasted_image_20250221173954.png)

Hacemos un ataque de fuerza bruta a los directorios con la herramienta`dirbuster`.

![Imagen](./images/Pasted_image_20250221174050.png)

Obtenemos el directorio de `/retro`y una consola de administración de WordPress`/wp-admin`.

![Imagen](./images/Pasted_image_20250221174405.png)

![Imagen](./images/Pasted_image_20250221174657.png)

Accedemos al directorio de`/retro`.

http://10.10.148.134/retro/


![Imagen](./images/Pasted_image_20250221175021.png)


Hacemos clic en el usuario`Wade`.

![Imagen](./images/Pasted_image_20250221175100.png)

Vemos que `Wade`ha comentado recientemente en el blog de "Ready Player One".

![Imagen](./images/Pasted_image_20250221175159.png)

Encontramos la posible contraseña de`Wade`: `parzival`

![Imagen](./images/Pasted_image_20250221175329.png)

Accedemos a través del servicio de RDP con las credenciales.

```
xfreerdp /u:wade /p:parzival /v:10.10.148.134
```
![Imagen](./images/Pasted_image_20250221175503.png)


Se nos abre el acceso remoto al cliente de Wade.

![Imagen](./images/Pasted_image_20250221175529.png)

Obtenemos el`user.txt`.

![Imagen](./images/Pasted_image_20250221175613.png)

```
3b99fbdc6d430bfb51c72c651a261927
```

## Escalada de privilegios

Entramos a Chrome y en las bookmarks tenemos el CVE.

![Imagen](./images/Pasted_image_20250221175806.png)

```
CVE-2019-1388
```

En la papelera de reciclaje también hay un programa llamado`hhupd`.

![Imagen](./images/Pasted_image_20250221175940.png)

Lo restauramos y lo ejecutamos.

Nos solicita las credenciales del administrador pero le hacemos clic en "Show more details".

![Imagen](./images/Pasted_image_20250221180056.png)

Y luego "Show Information about the publisher's certificate".

![Imagen](./images/Pasted_image_20250221180139.png)

Vamos al enlace hacia el navegador donde pone "Issued by: ...".

![Imagen](./images/Pasted_image_20250221180221.png)

Como la máquina no funciona bien, introducimos la URL manualmente en Internet Explorer.
![Imagen](./images/Pasted_image_20250221180609.png)

No podemos acceder a la página que es lo normal.

![Imagen](./images/Pasted_image_20250221180706.png)

En en engranaje de arriba, le damos a "File" y luego "Save as" para intentar guardar la página.

![Imagen](./images/Pasted_image_20250221180816.png)

Escribimos lo siguiente arriba:

```
C:\Windows\System32
```

Y también en "File name":

```
*.*
```
![Imagen](./images/Pasted_image_20250221180851.png)

Buscamos el cmd y lo ejecutamos (clic derecho y "Open").

![Imagen](./images/Pasted_image_20250221181127.png)

Debido a que no funciona correctamente el exploit.

![Imagen](./images/Pasted_image_20250221183134.png)

Nos lo descargamos de la siguiente URL de github.

https://github.com/SecWiki/windows-kernel-exploits/tree/master/CVE-2017-0213

Lo descargamos y lo descomprimimos.

![Imagen](./images/Pasted_image_20250221183236.png)

Luego, simplemente, lo pegamos directamente en la sesión abierta de antes.
![Imagen](./images/Pasted_image_20250221183329.png)


Abrimos el cmd y lo ejecutamos.

```
CVE-2017-0213_x64.exe
```
![Imagen](./images/Pasted_image_20250221183358.png)

La escalada de privilegios ha tenido éxito.

![Imagen](./images/Pasted_image_20250221183445.png)


La última flag se encuentra aquí.

![Imagen](./images/Pasted_image_20250221183638.png)

```
7958b569565d7bd88d10c6f22d1c4063
```
























