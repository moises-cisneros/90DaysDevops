# Día 09 - Construye, ejecuta y entiende tu primer contenedor

📅 **Fecha:** 23/06/2025

## ✅ Tema del día

Hoy nos sumergimos de lleno en la **construcción y gestión avanzada de contenedores Docker**, dejando atrás los conceptos básicos del Día 8 para enfocarnos en la práctica. El objetivo fue aprender a interactuar de forma profunda con los contenedores, entender su ciclo de vida, manipular su contenido y explorar las capas que componen una imagen. Esta jornada nos prepara para el control total sobre nuestras aplicaciones empaquetadas.

## 🧠 Lo que aprendí

Este día fue sobre control y comprensión detallada del comportamiento de los contenedores:

* **Ciclo de Vida del Contenedor:**
  * Comprendí los diferentes estados que un contenedor puede tener: `created` (creado pero no iniciado), `running` (ejecutándose), `paused` (suspendido) y `exited` (detenido o finalizado). Entender estos estados es clave para la gestión efectiva.
* **Interacción Avanzada con Contenedores:**
  * Aprendí a **reingresar** a un contenedor interactivo previamente detenido (`docker start` y `docker attach`), lo cual es útil para continuar un trabajo.
  * Dominé el comando **`docker exec`** para ejecutar comandos específicos *dentro* de un contenedor que ya está en ejecución sin necesidad de "entrar" en él, ideal para depuración o tareas rápidas.
* **Inspección Detallada:**
  * Descubrí el poder de **`docker inspect`** para obtener una visión profunda y estructurada (JSON) de cualquier contenedor. Esta herramienta revela información crítica sobre su configuración de red, volúmenes, comandos de inicio (`Entrypoint`), variables de entorno, y más, siendo indispensable para la depuración.
* **Gestión Eficiente de Recursos:**
  * Conocí el comando **`docker container prune`**, una herramienta vital para limpiar de forma masiva los contenedores que han terminado su ejecución y están ocupando espacio innecesariamente.
* **Composición de Imágenes (Capas):**
  * Exploré el **`docker history`** de una imagen (ej. NGINX), lo que me permitió ver cómo se construyen las imágenes capa por capa y los comandos utilizados en cada paso. Este concepto es fundamental para entender la eficiencia de Docker en el almacenamiento y para optimizar futuras imágenes.
* **Persistencia y Manipulación de Contenido:**
  * Aprendí a servir contenido web **personalizado** desde mi máquina VM dentro de un contenedor NGINX existente. Esto demostró cómo se puede "inyectar" o actualizar archivos dentro de un contenedor en ejecución, utilizando el comando **`docker cp`**. Esta capacidad es muy útil para el desarrollo y las pruebas rápidas.

### 💡 Lecciones Clave

* **`docker exec`** es tu mejor amigo para depurar un contenedor sin interrumpir su servicio principal.
* **`docker inspect`** es como una radiografía completa de tu contenedor, invaluable para entender su configuración interna.
* La comprensión de las **capas de una imagen** con `docker history` te abre las puertas a la optimización del tamaño y la velocidad de construcción de tus propias imágenes.
* **`docker cp`** es un atajo práctico para transferir archivos entre el host y el contenedor en escenarios específicos, aunque para producción se prefieren los volúmenes.

## ⚙️ Ejercicios realizados

Los ejercicios de hoy se centraron en ir más allá del "hello-world" y manipular activamente contenedores.

### 1\. Despliegue de un Servidor Web NGINX y Verificación

Como base para los ejercicios de interacción, primero lancé un servidor web NGINX, haciendo hincapié en el mapeo de puertos y la ejecución en segundo plano.

* **Comandos:**

    ```bash
    docker pull nginx # Descargar la imagen
    docker run -d -p 8080:80 --name mi-servidor-web nginx
    ```

  * **Explicación:** El comando `docker pull nginx` asegura que tengamos la imagen base. Luego, `docker run` inicia el contenedor: `-d` lo ejecuta en segundo plano, `-p 8080:80` mapea el puerto 80 del contenedor al 8080 de mi VM (y si mi VM está forwardeando, también a mi host Windows), y `--name mi-servidor-web` le asigna un nombre fácil de recordar.
* **Verificación:**
  * Accedí a `http://localhost:8080` desde mi navegador en la VN para confirmar que la página de bienvenida de NGINX se mostraba correctamente, indicando que el contenedor estaba sirviendo el contenido.

  * **Captura de pantalla**
    ![Mi servidor web](/assets/day-09/mi_servidor_web.png "Mi servidor web")

### 2\. Interacción Avanzada con Contenedores

Exploré cómo reengancharme a un contenedor, ejecutar comandos dentro de él y obtener información detallada.

* **Ejecutar un contenedor interactivo (Ubuntu):**

    ```bash
    docker run -it --name mi-ubuntu ubuntu bash
    ```

  * **Explicación:** Lanzamos un contenedor `ubuntu` y, gracias a `-it`, obtuvimos una terminal (`bash`) para interactuar directamente con él. Esto es ideal para probar comandos o explorar un ambiente aislado. Para salir, simplemente escribe `exit`.
* **Reingresar a un contenedor después de salir:**

    ```bash
    docker start mi-ubuntu
    docker attach mi-ubuntu
    ```

  * **Explicación:** Si saliste del shell interactivo (dejando el contenedor en estado `exited`), `docker start` lo vuelve a poner en `running`, y `docker attach` te conecta de nuevo a su terminal.
* **Ejecutar un comando directo en un contenedor en ejecución (`docker exec`):**

    ```bash
    docker exec mi-servidor-web ls /etc/nginx/conf.d/
    docker exec mi-ubuntu echo "Este comando se ejecuta dentro del contenedor."
    ```

  * **Explicación:** Este comando es muy potente. `docker exec` permite ejecutar cualquier comando *dentro* de un contenedor que ya está en estado `running`, sin necesidad de entrar en su shell interactiva. Es perfecto para verificaciones rápidas o tareas de administración sin interrumpir el proceso principal del contenedor.

* **Captura de pantalla**
    ![Imagen de Ubuntu](/assets/day-09/ubuntu_docker.png "Imagen de Ubuntu")

### 3\. Inspección Detallada de Contenedores

Utilicé `docker inspect` para obtener una visión completa de la configuración de un contenedor.

* **Comando:**

    ```bash
    docker inspect mi-servidor-web
    ```

  * **Explicación:** Este comando arroja una gran cantidad de detalles técnicos sobre el contenedor `mi-servidor-web` en formato JSON, incluyendo su ID, estado, configuración de red, mapeos de puertos, variables de entorno y más. Resulta invaluable para la depuración y para entender cómo Docker configura internamente el contenedor.

### 4\. Tu Primer Sitio Web Personalizado en un Contenedor

Este ejercicio fue fundamental para aprender a servir contenido estático propio y entender la interacción de archivos.

* **Preparar el contenedor NGINX (si no está ya corriendo en 9999):**

    ```bash
    docker run -d --name bootcamp-web -p 9999:80 nginx
    ```

  * **Explicación:** Se inicia un NGINX mapeando el puerto 80 del contenedor al 9999 de la VM.
* **Clonar el repositorio con la web estática:**

    ```bash
    git clone -b devops-simple-web https://github.com/roxsross/devops-static-web.git
    ```

  * **Explicación:** Descarga los archivos del sitio web de ejemplo a un directorio llamado `devops-static-web` en mi VM.
* **Copiar el contenido al contenedor (`docker cp`):**

    ```bash
    docker cp devops-static-web/bootcamp-web/. bootcamp-web:/usr/share/nginx/html/
    ```

  * **Explicación:** El comando `docker cp` es la clave aquí. Copia todo el contenido del directorio local `devops-static-web/bootcamp-web/` (el `.` al final indica "todo el contenido del directorio") al directorio `/usr/share/nginx/html/` dentro del contenedor `bootcamp-web`. NGINX está configurado por defecto para servir archivos desde esta ruta.
* **Verificar los archivos copiados dentro del contenedor:**

    ```bash
    docker exec bootcamp-web ls /usr/share/nginx/html
    ```

  * **Explicación:** Con `docker exec`, confirmo que los archivos (`index.html`, etc.) están presentes en el destino dentro del contenedor.

* **Acceder al sitio en el navegador:**
  * Abrí `http://localhost:9999` en mi navegador (en el host Windows). Pude ver el sitio web estático personalizado, demostrando que el contenido se había cargado correctamente en el NGINX del contenedor.

  * **Captura de pantalla**
    ![Configuracion de una Web Personalizada](/assets/day-09/config_web.png "Configuracion de una Web Personalizada")

### 5\. Explorar el Historial de Imágenes

Comprendí la composición de una imagen viendo sus capas.

* **Comando:**

    ```bash
    docker history nginx
    ```

  * **Explicación:** Este comando es fascinante porque muestra cómo la imagen `nginx` fue construida paso a paso. Cada línea representa una **capa** y el comando de Dockerfile que la creó. Entender esto es el primer paso para optimizar nuestras propias imágenes y aprovechar la eficiencia de las capas de Docker.

  * **Captura de pantalla**
    ![Docker History](/assets/day-09/docker_history.png "Docker History")

### 6\. Limpieza de Recursos (Buena Práctica)

Al finalizar los ejercicios, aprendí a limpiar los contenedores detenidos para liberar espacio.

* **Comando:**

    ```bash
    docker container prune
    ```

  * **Explicación:** Elimina todos los contenedores que no están en ejecución. Es una excelente práctica para mantener el sistema limpio y evitar el consumo innecesario de disco.

## 💭 Reflexiones y lecciones clave

El Día 9 fue una inmersión profunda en la **manipulación de contenedores**. Más allá de simplemente "correr" un contenedor, la capacidad de interactuar con ellos, copiar archivos y examinarlos en detalle abre un mundo de posibilidades para el desarrollo y la depuración.

* **Del "Correr" al "Controlar":** La diferencia entre los comandos básicos y los aprendidos hoy es el paso de ser un usuario pasivo a un administrador activo de contenedores. `docker exec`, `docker inspect` y `docker cp` son herramientas que rápidamente se sienten indispensables.
* **Entendiendo las Capas:** `docker history` fue una revelación. Ver la genealogía de una imagen y cómo cada comando construye una nueva capa es fundamental para la optimización futura. Esto me hizo pensar en la importancia de cómo se construyen las imágenes para hacerlas lo más ligeras y eficientes posible.
* **Resolución de Problemas en el Momento:** Saber cómo "entrar" a un contenedor o ejecutar un comando específico para verificar configuraciones internas sin parar el servicio, es una habilidad de depuración muy valiosa.
* **Flexibilidad en el Despliegue:** El ejercicio de la web estática me demostró la flexibilidad de Docker para adaptar imágenes existentes a mis necesidades, ya sea inyectando contenido o reconfigurando servicios.

Estoy cada vez más entusiasmado con el potencial de Docker para simplificar y estandarizar los despliegues de aplicaciones. El siguiente paso, construir mis propias imágenes, será sin duda un gran desafío, pero también una gran oportunidad de aprendizaje.

## 📎 Recursos

* 🧠 [Artículo del reto Día 9](https://90daysdevops.295devops.com/semana-02/dia9)
* 📘 [Documentación oficial de Docker (CLI)](https://docs.docker.com/reference/cli/docker/)
* 📘 [Documentación oficial de Docker: `docker exec`](https://docs.docker.com/engine/reference/commandline/exec/)
* 📘 [Documentación oficial de Docker: `docker inspect`](https://docs.docker.com/engine/reference/commandline/inspect/)
* 📘 [Documentación oficial de Docker: `docker cp`](https://docs.docker.com/engine/reference/commandline/cp/)
* 📘 [Documentación oficial de Docker: `docker history`](https://docs.docker.com/engine/reference/commandline/history/)
