# Anthem

## Escaneo de puertos

Ejecutamos un escaneo con`nmap`a los puertos abiertos y a los servicios de la máquina vulnerable:

```
nmap -sV -p- 10.10.215.95
```

Después de unos minutos, obtenemos los siguientes resultados:

![Escaneo de puertos](images/Pasted%20image%2020250222160043.png)

Tenemos el puerto 80 del servicio HTTP y el 3389 para acceso con control remoto al servidor.

## Inspeccionando el sitio web

Accedemos al sitio web con la IP desde nuestro navegador.

![Sitio web](images/Pasted%20image%2020250222160235.png)

Comprobamos el fichero de`robots.txt`y obtenemos la primera flag.

![robots.txt](images/Pasted%20image%2020250222160325.png)

```
UmbracoIsTheBest!
```

Y llegamos a la conclusión del que el CMS que se está utilizando en la página es`Umbraco`.

El dominio de la página es`anthem.com`.

![Dominio](images/Pasted%20image%2020250222162955.png)

Lo añadimos el fichero de Kali de`/etc/hosts`.

![Fichero /etc/hosts](images/Pasted%20image%2020250222163118.png)

## Fuzzing web

Buscamos directorios con`dirbuster` en el sitio web.

![Dirbuster](images/Pasted%20image%2020250222170200.png)

Obtenemos varios directorios que pueden ser importantes:

![Directorios](images/Pasted%20image%2020250222170424.png)

## Flags

Volviendo al blog anterior, vemos que el texto es un poema.

![Poema](images/Pasted%20image%2020250222171313.png)

Lo buscamos en google.

Encontramos que es un poema llamado Solomon Grundy.

https://en.wikipedia.org/wiki/Solomon_Grundy_(nursery_rhyme)

También encontramos el email de Jane Doe.

![Email](images/Pasted%20image%2020250222171546.png)

Asumimos que todos los demas emails usan el mismo formato, por tanto, el otro email será`SG@anthem.com`.

### Flag 1

En el post de "We are hiring", encontramos la primera flag en el código fuente.

![Flag 1](images/Pasted%20image%2020250222171821.png)

```
THM{L0L_WH0_US3S_M3T4}
```

### Flag 2

Esta se encuentra en el código fuente de la página principal.

![Flag 2](images/Pasted%20image%2020250222171949.png)

```
THM{G!T_G00D}
```

### Flag 3

Esta la encontramos en la página de autores.

```
http://anthem.com/authors
```

![Flag 3](images/Pasted%20image%2020250222172219.png)
```
THM{L0L_WH0_D15}
```

### Flag 4

La última flag la tenemos en el código fuente del post del blog de IT.

![Flag 4](images/Pasted%20image%2020250222172427.png)
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

![Acceso remoto](images/Pasted%20image%2020250222172826.png)

![Escritorio remoto](images/Pasted%20image%2020250222172914.png)

Obtenemos la flag del`user.txt`.

![Flag user.txt](images/Pasted%20image%2020250222173032.png)
```
THM{N00T_NO0T}
```

Navegamos sobre los demás archivos del sistema por si encontramos la contraseña del admin.

![Acceso denegado](images/Pasted%20image%2020250222173222.png)

Nos dice que no tenemos acceso a esa carpeta como es obvio. Probamos a darle a "Continue".

![Continuar](images/Pasted%20image%2020250222173259.png)

No tenemos la contraseña.

Ahora vamos a permitir que se vean los archivos ocultos en el sistema en el panel de control.

![Archivos ocultos](images/Pasted%20image%2020250222173953.png)

Le damos a "View" y "Show hidden files, folders, and drivers".

![Mostrar archivos](images/Pasted%20image%2020250222174056.png)

Podemos visualizar ahora la carpeta`backup`en el disco local C.

![Backup](images/Pasted%20image%2020250222174146.png)

No tenemos permisos para ver el fichero de`restore.txt`.

![Sin permisos](images/Pasted%20image%2020250222174226.png)

Así que hacemos clic derecho sobre él y nos dirigimos a la pestaña de "Seguridad" y luego "Advanced". Añadimos el usuario`SG`.

![Seguridad](images/Pasted%20image%2020250222174449.png)

Y obtenemos la contraseña del admin.

```
ChangeMeBaby1MoreTime
```

Ahora sí introducimos la contraseña para acceder a la carpeta del administrador.

![Acceso a carpeta admin](images/Pasted%20image%2020250222174744.png)

![Escritorio del admin](images/Pasted%20image%2020250222174946.png)

En el escritorio del admin está la flag del root.

![Flag root](images/Pasted%20image%2020250222175016.png)
```
THM{Y0U_4R3_1337}
```





























