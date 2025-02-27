### Ice
#### nmap
Después de esperar unos minutos a que inicie la máquina, escaneamos los puertos.
![Escaneo de puertos](images/Pasted%20image%2020250221122600.png)
Y estos son los resultados del script:
![Resultados del script](images/Pasted%20image%2020250221122646.png)
El puerto 8000 es el de Icecast y el hostname es DARK-PC.
![Puerto Icecast](images/Pasted%20image%2020250221123829.png)
Verificamos si hay vulnerabilidades mediante el script de nmap. Tardará unos minutos en completarse.
Se ha detectado una vulnerabilidad ms17-010cuyo CVE es CVE-2017-0143 además de CVE-2007-6750-
![Vulnerabilidad MS17-010](images/Pasted%20image%2020250221125732.png) ![Vulnerabilidades](images/Pasted%20image%2020250221125321.png)

Buscamos la vulnerabilidad de Icecast también.
https://www.cvedetails.com/cve/CVE-2004-1561/
#### Obtener acceso
Abrimos la consola de metasploitable:
Buscamos el exploit de Icecast:
Cargamos el exploit:
![Cargar exploit Icecast](images/Pasted%20image%2020250221130420.png)
Configuramos las opciones.
![Configurar opciones exploit](images/Pasted%20image%2020250221130610.png)
Ejecutamos el exploit:
![Ejecutar exploit](images/Pasted%20image%2020250221130948.png)
#### Escalada de privilegios
Introducimos el siguiente comando para ver el server username:
![Server username](images/Pasted%20image%2020250221131452.png)
Para ver la información del sistema:
![Información del sistema](images/Pasted%20image%2020250221131546.png)
Ahora que conocemos la arquitectura de los procesos, vamos a hacer un reconocimiento más avanzado de los mismos:
![Reconocimiento de procesos](images/Pasted%20image%2020250221132008.png)
Ponemos el proceso en el background:
Usamos el siguiente exploit:
![Usar exploit](images/Pasted%20image%2020250221132232.png)
Vemos las opciones y asignamos la sesión:
Hay que asegurarse bien de qué sesión es con el comando sessions.
Iniciamos el exploit:
![Iniciar exploit](images/Pasted%20image%2020250221132414.png)
Ahora lo ejecutamos con una interfaz disntinta:
Ejecutamos el siguiente comando una vez obtenemos acceso:
![Ejecutar comando](images/Pasted%20image%2020250221132709.png)
El permiso de SeTakeOwnershipPrivilegees el que permite obtener la propiedad de una archivo.
#### Looting
Visualizamos los procesos del sistema con el comando ps:
![Procesos del sistema](images/Pasted%20image%2020250221133657.png)
Migramos el proceso con el siguiente comando:
![Migrar proceso](images/Pasted%20image%2020250221133807.png)
Confirmamos que ahora somos NT Authority.
![Confirmar NT Authority](images/Pasted%20image%2020250221133907.png)
Ahora que tenemos todos los permisos, vamos a usar el comando kiwi. Escribimos el comando help que muestra todas las funciones de la herramienta.
![Comando kiwi help](images/Pasted%20image%2020250221134221.png)
![Funciones de kiwi](images/Pasted%20image%2020250221134301.png)
Para obtener todos los credenciales usaremos el siguiente comando:
![Obtener credenciales](images/Pasted%20image%2020250221134352.png)
También podemos usar hashdumpy crackear los hashes.
![Crackear hashes](images/Pasted%20image%2020250221134431.png)
En la siguient página podemos crackearlos.
https://crackstation.net/
Este es el de Dark:
![Hash de Dark](images/Pasted%20image%2020250221134641.png)
La contraseña es Password01!.
#### Post-Exploitation
*  ¿Qué comando nos metire dumpear todas los hashes de las contraseñas del sistema?
**hashdump** [1]
*  ¿Qué comando nos permite ver el escritorio remoto del usuario en tiempo real?
**Screenshare** [1]
*  Si quisiéramos grabar desde un micrófono conectado al equipo, ¿qué comando nos lo permitiría?
**record_mic** [1]
*  Podemos modificar las marcas de tiempo de los archivos del sistema. ¿Qué comando nos permite hacerlo?
**timestomp** [1]
*  Mimikatz nos permite crear lo que se denomina un «ticket dorado», que nos permite autenticarnos en cualquier lugar con facilidad. ¿Qué comando nos permite hacer esto?
**golden_ticket_create** [1
