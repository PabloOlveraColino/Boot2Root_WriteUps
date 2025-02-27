# Retro

## Escaneo de puertos

Ejecutamos el siguiente comando de`nmap`para identificar los puertos abiertos de la máquina vulnerable.

```
nmap -sV -sC 10.10.148.134
```

Tenemos dos servicios funcionando en la máquina obtenido: El puerto 80 de HTTP y el 3389 de RDP.

![[Pasted image 20250221173916.png]]

## Fuzzing web

Accedemos a la página web.

![[Pasted image 20250221173954.png]]

Hacemos un ataque de fuerza bruta a los directorios con la herramienta`dirbuster`.

![[Pasted image 20250221174050.png]]

Obtenemos el directorio de `/retro`y una consola de administración de WordPress`/wp-admin`.

![[Pasted image 20250221174405.png]]

![[Pasted image 20250221174657.png]]

Accedemos al directorio de`/retro`.

http://10.10.148.134/retro/

![[Pasted image 20250221175021.png]]

Hacemos clic en el usuario`Wade`.

![[Pasted image 20250221175100.png]]

Vemos que `Wade`ha comentado recientemente en el blog de "Ready Player One".

![[Pasted image 20250221175159.png]]

Encontramos la posible contraseña de`Wade`: `parzival`

![[Pasted image 20250221175329.png]]

Accedemos a través del servicio de RDP con las credenciales.

```
xfreerdp /u:wade /p:parzival /v:10.10.148.134
```

![[Pasted image 20250221175503.png]]

Se nos abre el acceso remoto al cliente de Wade.

![[Pasted image 20250221175529.png]]

Obtenemos el`user.txt`.

![[Pasted image 20250221175613.png]]

```
3b99fbdc6d430bfb51c72c651a261927
```

## Escalada de privilegios

Entramos a Chrome y en las bookmarks tenemos el CVE.

![[Pasted image 20250221175806.png]]

```
CVE-2019-1388
```

En la papelera de reciclaje también hay un programa llamado`hhupd`.

![[Pasted image 20250221175940.png]]

Lo restauramos y lo ejecutamos.

Nos solicita las credenciales del administrador pero le hacemos clic en "Show more details".

![[Pasted image 20250221180056.png]]

Y luego "Show Information about the publisher's certificate".

![[Pasted image 20250221180139.png]]

Vamos al enlace hacia el navegador donde pone "Issued by: ...".

![[Pasted image 20250221180221.png]]

Como la máquina no funciona bien, introducimos la URL manualmente en Internet Explorer.

![[Pasted image 20250221180609.png]]

No podemos acceder a la página que es lo normal.

![[Pasted image 20250221180706.png]]

En en engranaje de arriba, le damos a "File" y luego "Save as" para intentar guardar la página.

![[Pasted image 20250221180816.png]]

Escribimos lo siguiente arriba:

```
C:\Windows\System32
```

Y también en "File name":

```
*.*
```

![[Pasted image 20250221180851.png]]

Buscamos el cmd y lo ejecutamos (clic derecho y "Open").

![[Pasted image 20250221181127.png]]

Debido a que no funciona correctamente el exploit.

![[Pasted image 20250221183134.png]]

Nos lo descargamos de la siguiente URL de github.

https://github.com/SecWiki/windows-kernel-exploits/tree/master/CVE-2017-0213

Lo descargamos y lo descomprimimos.

![[Pasted image 20250221183236.png]]

Luego, simplemente, lo pegamos directamente en la sesión abierta de antes.

![[Pasted image 20250221183329.png]]

Abrimos el cmd y lo ejecutamos.

```
CVE-2017-0213_x64.exe
```

![[Pasted image 20250221183358.png]]

La escalada de privilegios ha tenido éxito.

![[Pasted image 20250221183445.png]]

La última flag se encuentra aquí.

![[Pasted image 20250221183638.png]]

```
7958b569565d7bd88d10c6f22d1c4063
```
























