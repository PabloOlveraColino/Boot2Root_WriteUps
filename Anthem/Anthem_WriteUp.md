# Anthem

## Escaneo de puertos

Ejecutamos un escaneo con`nmap`a los puertos abiertos y a los servicios de la máquina vulnerable:

```
nmap -sV -p- 10.10.215.95
```

Después de unos minutos, obtenemos los siguientes resultados:

![[Pasted image 20250222160043.png]]

Tenemos el puerto 80 del servicio HTTP y el 3389 para acceso con control remoto al servidor.

## Inspeccionando el sitio web

Accedemos al sitio web con la IP desde nuestro navegador.

![[Pasted image 20250222160235.png]]

Comprobamos el fichero de`robots.txt`y obtenemos la primera flag.

![[Pasted image 20250222160325.png]]

```
UmbracoIsTheBest!
```

Y llegamos a la conclusión del que el CMS que se está utilizando en la página es`Umbraco`.

El dominio de la página es`anthem.com`.

![[Pasted image 20250222162955.png]]

Lo añadimos el fichero de Kali de`/etc/hosts`.

![[Pasted image 20250222163118.png]]

## Fuzzing web

Buscamos directorios con`dirbuster` en el sitio web.

![[Pasted image 20250222170200.png]]

Obtenemos varios directorios que pueden ser importantes:

![[Pasted image 20250222170424.png]]

## Flags

Volviendo al blog anterior, vemos que el texto es un poema.

![[Pasted image 20250222171313.png]]

Lo buscamos en google.

Encontramos que es un poema llamado Solomon Grundy.

https://en.wikipedia.org/wiki/Solomon_Grundy_(nursery_rhyme)

También encontramos el email de Jane Doe.

![[Pasted image 20250222171546.png]]

Asumimos que todos los demas emails usan el mismo formato, por tanto, el otro email será`SG@anthem.com`.

### Flag 1

En el post de "We are hiring", encontramos la primera flag en el código fuente.

![[Pasted image 20250222171821.png]]

```
THM{L0L_WH0_US3S_M3T4}
```

### Flag 2

Esta se encuentra en el código fuente de la página principal.

![[Pasted image 20250222171949.png]]

```
THM{G!T_G00D}
```

### Flag 3

Esta la encontramos en la página de autores.

```
http://anthem.com/authors
```

![[Pasted image 20250222172219.png]]

```
THM{L0L_WH0_D15}
```

### Flag 4

La última flag la tenemos en el código fuente del post del blog de IT.

![[Pasted image 20250222172427.png]]

```
THM{AN0TH3R_M3TA}
```

## Escalada de privilegios

Tenemos actualmente la contraseña que encontramos antes`UmbracoIsTheBest!`.

Intentamos acceder por control remoto con el supuesto usuario SG a su cliente de Windows Server.

```
xfreerdp /u:SG /p:UmbracoIsTheBest! /v:anthem.com
```

Accedimos correctamente.

![[Pasted image 20250222172826.png]]

![[Pasted image 20250222172914.png]]

Obtenemos la flag del`user.txt`.

![[Pasted image 20250222173032.png]]

```
THM{N00T_NO0T}
```

Navegamos sobre los demás archivos del sistema por si encontramos la contraseña del admin.

![[Pasted image 20250222173222.png]]

Nos dice que no tenemos acceso a esa carpeta como es obvio. Probamos a darle a "Continue".

![[Pasted image 20250222173259.png]]

No tenemos la contraseña.

![[Pasted image 20250222173350.png]]

Ahora vamos a permitir que se vean los archivos ocultos en el sistema en el panel de control.

![[Pasted image 20250222173953.png]]

Le damos a "View" y "Show hidden files, folders, and drivers".

![[Pasted image 20250222174056.png]]

Podemos visualizar ahora la carpeta`backup`en el disco local C.

![[Pasted image 20250222174146.png]]

No tenemos permisos para ver el fichero de`restore.txt`.

![[Pasted image 20250222174226.png]]

Así que hacemos clic derecho sobre él y nos dirigimos a la pestaña de "Seguridad" y luego "Advanced". Añadimos el usuario`SG`.

![[Pasted image 20250222174449.png]]

Y obtenemos la contraseña del admin.

![[Pasted image 20250222174520.png]]

```
ChangeMeBaby1MoreTime
```

Ahora sí introducimos la contraseña para acceder a la carpeta del administrador.

![[Pasted image 20250222174744.png]]

![[Pasted image 20250222174946.png]]

En el escritorio del admin está la flag del root.

![[Pasted image 20250222175016.png]]

```
THM{Y0U_4R3_1337}
```





























