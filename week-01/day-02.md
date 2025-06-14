# Día 02 - Comandos, estructura, usuarios y permisos

📅 Fecha: 08/06/2025

## ✅ Tema del día

Hoy profundicé en los fundamentos del sistema operativo Linux desde la terminal: comandos esenciales para DevOps, la estructura del sistema de archivos, gestión de usuarios y permisos, además de manejar servicios y paquetes con `apt`.

## 🧠 Lo que aprendí

* Comandos esenciales: `ls`, `cd`, `mkdir`, `cp`, `mv`, `rm`, `whoami`, `chmod`, `chown`, `systemctl`, entre muchos otros.
* Cómo navegar por la estructura jerárquica del sistema de archivos (FHS).
* Diferencia entre `/`, `/etc`, `/var`, `/home`, `/proc`, etc.
* Cómo gestionar usuarios y permisos (lectura, escritura, ejecución para dueño, grupo y otros).
* Qué hace el comando `chmod u=rwx,g=rx,o= hola.txt`:

  > Le otorga al usuario propietario permisos de lectura, escritura y ejecución (`rwx`), al grupo solo lectura y ejecución (`rx`), y ningún permiso a los demás (`o=`).
* Comandos de gestión de servicios con `systemctl` y `service`.
* Instalación de software usando `apt`.

## ⚙️ Ejercicios realizados

* 🖥️ Instalé y ejecuté **Nginx**, accediendo a la página de bienvenida.

  * Comando usado: `sudo apt install nginx && sudo systemctl start nginx`
  * *Captura de terminal:
  ![Instalar Ngix](/assets/day-02/terminal_ngix.png "Instalar Ngix")*
* 🔧 Instalé **Apache**, personalicé la página principal y como reto mostré la hora actual.

  * Comando: `sudo apt install apache2 && sudo systemctl start apache2`
  * *Captura de terminal:
  ![Instalar Apache](/assets/day-02/terminal_apache.png "Instalar Apache")*
* 📂 Creé una carpeta `day-02`, dentro practiqué:

  * Crear archivo: `echo "Hola Moises DevOps!" > saludos.txt`
  * Copiarlo: `cp archivo.txt copia.txt`
  * Modificar: `mv copia.txt hola.txt`
  * Eliminar: `rm saludos.txt`
  * *Captura de terminal:
  ![Terminal Day 2](/assets/day-02/terminal_day2.png "Terminal Day 2")*
* 👤 Creé un usuario y modifiqué permisos para el archivo `hola.txt`:

  * Crear usuario: `sudo adduser invitado`
  * Crear grupo: `sudo groupadd roxsdevs`
  * Asignar usuario al grupo: `sudo usermod -aG roxsdevs invitado`
  * Otorgar permisos para leer/escribir/ejecutar`chmod 740 hola.txt`
  * `ls -l hola.txt`
  * *Captura de terminal:
  ![Terminal new user](/assets/day-02/terminal_new_user.png "Terminal new user")*

## 💭 Reflexiones y lecciones clave

Fue un día bastante completo y retador. Me costó un poco al principio recordar cómo funciona la jerarquía de permisos en Linux, pero practicar con `chmod` y `chown` me ayudó bastante. Lo más interesante fue ver en acción la diferencia entre Nginx y Apache, y cómo los servicios se gestionan con `systemctl`.

## 📎 Recursos

* 🧠 [Artículo del reto Día 2](https://90daysdevops.295devops.com/semana-01/dia2#-desplegando-un-hola-mundo-en-apache)
* 📄 [Documentación de comandos Linux](https://linux.die.net/man/)
* 📄 [Documentación oficial de Nginx](https://nginx.org/en/docs/)
* 📄 [Documentación oficial de Apache](https://httpd.apache.org/docs/)

---
