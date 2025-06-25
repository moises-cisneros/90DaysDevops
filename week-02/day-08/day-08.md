# Día 08 - Conceptos básicos de contenedores Docker

📅 **Fecha:** 22/06/2025

## ✅ Tema del día

Hoy nos zambullimos en el mundo de los **contenedores Docker**, una tecnología fundamental en el panorama DevOps. Comprendimos qué es Docker, su arquitectura, y cómo nos permite empaquetar aplicaciones con todas sus dependencias para que se ejecuten de manera consistente en cualquier entorno. La meta es decir adiós al famoso "en mi máquina funciona" y adoptar la portabilidad y eficiencia que ofrecen los contenedores. Exploraremos cómo ejecutar nuestros primeros contenedores y sentaremos las bases para la contenerización de aplicaciones más complejas.

## 🧠 Lo que aprendí

Este día marcó el inicio de una nueva era en la forma de desplegar aplicaciones:

* **¿Qué es Docker y por qué es crucial?**
  * Comprendí que Docker es una plataforma open-source que facilita el desarrollo, envío y ejecución de aplicaciones en **contenedores aislados y ligeros**.
  * La promesa de **portabilidad y consistencia** ("build once, run anywhere") es la clave, eliminando los problemas de dependencias y entornos inconsistentes entre desarrollo, testing y producción.
* **Arquitectura de Docker:**
  * **Docker Engine:** El motor central que permite crear y correr contenedores.
  * **Docker Daemon (`dockerd`):** El servicio en segundo plano que administra las imágenes y contenedores.
  * **CLI (`docker`):** La interfaz de línea de comandos para interactuar con el Daemon.
  * **Docker Hub:** El registro público para almacenar y compartir imágenes.
* **Componentes Internos de Docker:**
  * **Imágenes:** Plantillas inmutables y de solo lectura que contienen el código, runtime, librerías y dependencias de una aplicación. Son la base de los contenedores.
  * **Contenedores:** Instancias ejecutables (en tiempo de ejecución) de una imagen. Son aislados, ligeros y efímeros por naturaleza.
  * **Volúmenes:** Mecanismos para persistir datos fuera del ciclo de vida del contenedor, asegurando que la información no se pierda al eliminar o recrear un contenedor.
  * **Redes:** Docker facilita la comunicación segura entre contenedores a través de redes virtuales, permitiendo que servicios como una base de datos y una aplicación web se comuniquen eficientemente.
* **Contenedores vs. Máquinas Virtuales:**
  * Entendí las diferencias fundamentales: los contenedores son más **ligeros, rápidos de iniciar y más eficientes en el uso de recursos** (comparten el kernel del host), mientras que las VMs ofrecen un **aislamiento total** al tener su propio sistema operativo completo. Docker es ideal para empaquetar aplicaciones, mientras que las VMs son más para virtualizar hardware o sistemas operativos completos.

### 💡 Lecciones Clave

* La **consistencia** que ofrece Docker es un cambio de juego para los equipos DevOps.
* La separación entre **imágenes (blueprint) y contenedores (instancia)** es fundamental para comprender Docker.
* Los **volúmenes** son críticos para datos persistentes.

## ⚙️ Ejercicios realizados

### 1\. Preparación del Entorno (VM Ubuntu)

Dado que ya en anteriores ejercicios he utilizado la VM Ubuntu (la misma que use como nodo de control Ansible), la instalación de Docker se realizó directamente allí, aprovechando que ya tengo un entorno Linux estable y accesible.

* **Instalación de Docker Engine:**

    ```bash
    # Actualizar índices de paquetes e instalar dependencias necesarias
    sudo apt install gnome-terminalx
    sudo apt upgrade
    sudo apt-get update

    # Añadir la clave GPG oficial de Docker
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Añadir el repositorio de Docker a las fuentes de APT
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Instalar Docker Engine, CLI, containerd y plugins
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Opcional pero recomendado: Añadir tu usuario al grupo docker para evitar usar sudo
    sudo usermod -aG docker $USER
    sudo usermod -aG docker moises

    # Cierra y vuelve a abrir tu sesión SSH o reinicia tu VM:
    ```

* **Verificación de la instalación:**

    ```bash
    docker --version
    sudo systemctl status docker # Verificar que el servicio Docker esté corriendo
    ```

  * **Captura de pantalla**
![Docker Version](/assets/day-08/docker_version.png "Docker version")

### 2\. ¡Hola mundo desde un contenedor\

Se ejecutó el primer contenedor para verificar la funcionalidad básica de Docker.

* **Comando:**

    ```bash
    docker run hello-world
    ```

* **Captura de pantalla**
![Docker Hello World](/assets/day-08/docker_hello_world.png "Docker Hello World")

### 3\. Exploración de comandos básicos de Docker

Para familiarizarme con la CLI de Docker, utilicé varios comandos esenciales para gestionar imágenes y contenedores.

* **Ver contenedores activos:**

    ```bash
    docker ps
    ```

* **Ver todos los contenedores (activos e inactivos):**

    ```bash
    docker ps -a
    ```

* **Descargar una imagen (ej. Nginx, Alpine):**

    ```bash
    docker pull nginx:latest
    docker pull alpine:latest
    ```

* **Ver todas las imágenes descargadas:**

    ```bash
    docker images
    ```

  * **Captura de pantalla**
![imagenes de Docker](/assets/day-08/docker_image.png "Imagenes de Docker")

* **Ejecutar una imagen (ej. Nginx y Alpine):**

  * **Nginx (con mapeo de puerto para accederlo desde el navegador):**

      ```bash
      docker run -d -p 8081:80 --name my-nginx nginx
      # -d: detach mode (corre en segundo plano)
      # -p 8081:80: mapea el puerto 80 del contenedor al puerto 8081 de la VM
      # --name my-nginx: asigna un nombre al contenedor
      ```

    * **Verificación:** Abrir un navegador en tu host (Windows) e ir a `http://localhost:8081` (asumiendo que el puerto 8081 de tu VM está forwardeado a tu host, o directamente a la IP de la VM si la tienes accesible). Deberías ver la página de bienvenida de Nginx.

    * **Captura de pantalla**
    ![Imagen de Nginx](/assets/day-08/image_ngnix.png "Imagen de Nginx")

  * **Alpine (ejecutando un comando simple):**

      ```bash
      docker run --rm alpine echo "Hola desde un contenedor Alpine!"
      # --rm: elimina el contenedor automáticamente al salir
      ```

    * **Captura de pantalla**
    ![Imagen de Alpine](/assets/day-08/alpine_comando.png "Imagen de Alpine")

* **Detener un contenedor:**

    ```bash
    docker stop my-nginx
    ```

* **Eliminar un contenedor:**

    ```bash
    docker rm my-nginx
    ```

* **Eliminar una imagen:**

    ```bash
    docker rmi nginx:latest
    ```

  * **Captura de pantalla**
  ![Comandos de Docker](/assets/day-08/comandos_stop.png "Comandos de Docker")

## 💭 Reflexiones y lecciones clave

El Día 8 fue una introducción fascinante a los contenedores. La idea de empaquetar una aplicación con todas sus dependencias en una unidad portable es increíblemente poderosa y resuelve un problema fundamental en el desarrollo y la operación de software.

* **Consistencia y Portabilidad:** Comprendí por qué Docker es la solución a los "funciona en mi máquina". La capacidad de garantizar que un software se ejecute de la misma manera en cualquier entorno es un gran avance.
* **Eficiencia de Recursos:** La comparación con las VMs es reveladora; los contenedores ofrecen una forma mucho más eficiente de utilizar los recursos del servidor al compartir el kernel del host.
* **Curva de Aprendizaje:** Aunque los conceptos iniciales son claros, la gestión de volúmenes, redes complejas y la construcción de imágenes personalizadas prometen una curva de aprendizaje interesante.
* **Adaptación del Entorno:** Confirmé que mi estrategia de usar una **VM Ubuntu como nodo de control para Ansible y ahora como entorno para Docker** es la forma más efectiva de avanzar, superando las limitaciones de ejecutar estas herramientas directamente en mi entorno Windows. Esto refuerza la importancia de la flexibilidad y la resolución creativa de problemas en DevOps.

## 📎 Recursos

* 🧠 [Artículo del reto Día 8](https://90daysdevops.295devops.com/semana-02/dia8)
* 📘 [Guía oficial de instalación de Docker para Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* 📘 [Documentación oficial de Docker](https://docs.docker.com/)
* 🐳 [Play with Docker (laboratorio online)](https://labs.play-with-docker.com/)
