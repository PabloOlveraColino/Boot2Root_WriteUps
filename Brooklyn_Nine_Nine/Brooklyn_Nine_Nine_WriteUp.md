# Brooklyn Nine Nine

## Escaneo de puertos

Lanzamos un mapeo de puertos y servicios con `nmap`:

```bash
sudo nmap -sV -T4 -p- 10.10.93.36
```

Los puertos abiertos son:

* 21: FTP (vsftpd)
* 22: SSH (OpenSSH)
* 80: HTTP (Apache httpd)

![](images/image.png)

## Acceso por FTP

Nos conectamos al FTP como `anonymous` y encontramos una nota para Jake:

![](images/image-1.png)

Descargamos el archivo:

```bash
get note_to_jake.txt
```

![](images/image-2.png)

Revisamos el contenido, que sugiere credenciales débiles para Jake:

![](images/image-3.png)

## Ataque de fuerza bruta

Ejecutamos `hydra` contra SSH con el usuario `jake`:

```bash
hydra -l jake -P /usr/share/wordlists/rockyou.txt ssh://10.10.93.36
```

La contraseña es **987654321**.

![](images/image-4.png)

## Acceso por SSH

Accedemos como `jake`:

```bash
ssh jake@10.10.93.36
```

![](images/image-5.png)

Inspeccionamos los usuarios y vemos que `holt` tiene la flag:

![](images/image-6.png)

```
ee11cbb19052e40b07aac0ca060c23ee
```

## Escalada de privilegios

Comprobamos los comandos sudo permitidos:

```bash
sudo -l
```

![](images/image-7.png)

Vemos que podemos usar `less` sin contraseña. Según GTFObins, `less` puede ejecutar un shell.

![](images/image-8.png)

Obtenemos la flag de root:

```bash
sudo less /root/root.txt
```

![](images/image-9.png)

```
63a9f0ea7bb98050796b649e85481845
```
