# Día 10 - Gestión de contenedores Docker

📅 **Fecha:** 24/06/2025

## ✅ Tema del día

Hoy profundizamos en la **gestión avanzada de contenedores Docker**, dominando su ciclo de vida y aprendiendo a interactuar con ellos de formas más sofisticadas. Nos enfocamos en comandos para monitorear logs, gestionar estados (pausar, reiniciar), inspeccionar detalles específicos con filtros, y configurar contenedores mediante variables de entorno. El objetivo es tener un control total sobre nuestras aplicaciones empaquetadas, preparándonos para entornos de desarrollo y producción más complejos.

## 🧠 Lo que aprendí

Este día fue crucial para obtener un control más granular sobre los contenedores:

* **Monitoreo de Logs:**
  * Aprendí a ver la salida estándar de un contenedor en tiempo real con `docker logs <nombre_contenedor>` y a seguirla continuamente con `docker logs -f`. Esto es indispensable para depurar y observar el comportamiento de las aplicaciones.
* **Gestión Completa del Ciclo de Vida:**
  * Más allá de iniciar y detener, ahora sé cómo **pausar (`docker pause`)** y **reanudar (`docker unpause`)** un contenedor, lo cual congela sus procesos sin detenerlo por completo.
  * También aprendí a **reiniciar (`docker restart`)** un contenedor, que es un atajo para detenerlo y volver a iniciarlo.
  * Descubrí la opción **`-f` (force)** con `docker rm` para eliminar un contenedor directamente sin necesidad de detenerlo primero, útil en situaciones donde un contenedor no responde.
* **Inspección Detallada con Filtros:**
  * Amplié el uso de `docker inspect` para extraer información específica del JSON de salida utilizando la opción `--format` y la sintaxis de plantillas Go. Esto me permite obtener rápidamente datos como el ID, la imagen usada, variables de entorno, comandos ejecutados y la dirección IP asignada a un contenedor.
* **Configuración con Variables de Entorno:**
  * Comprendí la importancia y el uso del flag **`-e`** (`--env`) al ejecutar un contenedor para pasar variables de entorno. Estas variables son fundamentales para configurar aplicaciones dentro del contenedor sin modificar la imagen, lo que permite reutilizar la misma imagen en diferentes entornos (desarrollo, producción).
  * Practiqué con ejemplos reales, como la configuración de una base de datos MariaDB, donde las variables de entorno son obligatorias para su inicialización.
* **Visualización de Procesos Internos:**
  * Aprendí a usar **`docker top`** para ver los procesos que se están ejecutando *dentro* de un contenedor específico, similar a cómo `top` o `ps` funcionan en un sistema operativo normal. Esto es muy útil para verificar si los procesos esperados están corriendo.

### 💡 Lecciones Clave

* Los **logs** son tu ventana al interior del contenedor; `docker logs -f` es una herramienta de depuración esencial.
* Las **variables de entorno (`-e`)** son el método estándar y más flexible para configurar aplicaciones en contenedores, permitiendo la reutilización de imágenes.
* **`docker inspect --format`** transforma una salida JSON compleja en información precisa y útil para scripts o verificaciones rápidas.
* **`docker top`** te da visibilidad sobre los procesos internos, ayudando a confirmar que tu aplicación está funcionando como esperas.

## ⚙️ Ejercicios realizados

Los ejercicios de hoy se enfocaron en la gestión avanzada y la configuración de contenedores.

### 1\. Ejecución y Monitoreo de Contenedores en Segundo Plano

Puse en práctica la ejecución de contenedores persistentes y el monitoreo de su actividad.

* **Ejecutar un contenedor que imprime "hello world" cada segundo:**

    ```bash
    docker run -d --name contenedor-logs ubuntu bash -c "while true; do echo hello world $(date +"%T"); sleep 1; done"
    ```

  * **Explicación:** Se lanza un contenedor Ubuntu en modo *detached* (`-d`) que ejecuta un bucle infinito imprimiendo "hello world" junto con la hora actual cada segundo.
* **Verificar que está corriendo:**

    ```bash
    docker ps
    ```

  * **Explicación:** Confirma que `contenedor-logs` aparece en la lista de contenedores activos.
* **Ver los logs del contenedor:**

    ```bash
    docker logs -f contenedor-logs
    ```

  * **Explicación:** Muestra la salida estándar del contenedor en tiempo real, permitiéndome ver el "hello world" y la hora actual actualizándose. Para detener la visualización, presiona `Ctrl+C`.

* **Captura de pantalla**
    ![Docker logs](/assets/day-10/docker_logs.png "Docker logs")

### 2\. Gestión del Ciclo de Vida del Contenedor

Exploré los comandos para controlar el estado de un contenedor.

* **Preparar un contenedor para pruebas de ciclo de vida:**

    ```bash
    docker run -d --name hora-container ubuntu bash -c 'while true; do echo $(date +"%T"); sleep 1; done'

    docker logs -f hora-container # Observar los logs en una terminal
    ```

  * **Explicación:** Se inicia un contenedor que imprime la hora cada segundo. Los logs se monitorean en una terminal para observar los efectos de los comandos de gestión.
* **Detener el contenedor:**

    ```bash
    docker stop hora-container
    ```

  * **Explicación:** El contenedor se detiene y los logs dejan de actualizarse.
* **Iniciar el contenedor:**

    ```bash
    docker start hora-container
    ```

  * **Explicación:** El contenedor vuelve a su estado `running` y los logs se reanudan.
* **Reiniciar el contenedor:**

    ```bash
    docker restart hora-container
    ```

  * **Explicación:** Detiene y vuelve a iniciar el contenedor en un solo comando.
* **Pausar el contenedor:**

    ```bash
    docker pause hora-container
    ```

  * **Explicación:** El contenedor se congela. Los logs dejan de actualizarse, pero el contenedor sigue en estado `running` (aunque pausado).
* **Reanudar el contenedor:**

    ```bash
    docker unpause hora-container
    ```

  * **Explicación:** El contenedor se reanuda y los logs vuelven a fluir.
* **Eliminar un contenedor forzadamente (sin detenerlo primero):**

    ```bash
    docker rm -f hora-container # Usando el contenedor del primer ejercicio
    ```

  * **Explicación:** El flag `-f` permite eliminar un contenedor incluso si está en ejecución, forzando su terminación.

* **Captura de pantalla**
    ![Detener contenedor reloj](/assets/day-10/stop_logs.png "Detener contenedor reloj")

### 3\. Copia de Archivos y Ejecución de Comandos Internos

Practiqué la interacción de archivos y la ejecución de comandos dentro de contenedores.

* **Crear un contenedor que guarda la hora en un archivo:**

    ```bash
    docker run -d --name hora-container2 ubuntu bash -c 'while true; do date +"%T" >> hora.txt; sleep 1; done'
    ```

  * **Explicación:** Este contenedor escribe la hora actual en un archivo `hora.txt` cada segundo.
* **Verificar el contenido del archivo dentro del contenedor:**

    ```bash
    docker exec hora-container2 ls
    docker exec hora-container2 cat hora.txt
    ```

  * **Explicación:** `docker exec` me permite listar el contenido del directorio y ver el archivo `hora.txt` creciendo.
* **Copiar un archivo del host al contenedor:**

    ```bash
    echo "Curso DevOps con Roxs" > mi_archivo_host.txt
    docker cp mi_archivo_host.txt hora-container2:/tmp/
    docker exec hora-container2 cat /tmp/mi_archivo_host.txt
    ```

  * **Explicación:** Se crea un archivo en el host y luego se copia al directorio `/tmp` dentro del contenedor `hora-container2`. Se verifica su contenido con `docker exec`.
* **Copiar un archivo del contenedor al host:**

    ```bash
    docker cp hora-container2:hora.txt .
    cat hora.txt
    ```

  * **Explicación:** El archivo `hora.txt` generado dentro del contenedor se copia al directorio actual (`.`) en mi máquina virtual. Luego, puedo ver su contenido en el host.

* **Captura de pantalla**
    ![Copiar contenido de archivo](/assets/day-10/copiar_archivo_contenido.png "Copiar contenido de archivo")

### 4\. Inspección Detallada con Filtros (`--format`)

Aprendí a extraer información específica de la salida JSON de `docker inspect`.

* **Comandos de inspección con formato:**

    ```bash
    docker inspect --format='{{.Id}}' hora-container2
    docker inspect --format='{{.Config.Image}}' hora-container2
    docker container inspect -f '{{range .Config.Env}}{{println .}}{{end}}' hora-container2
    docker inspect --format='{{range .Config.Cmd}}{{println .}}{{end}}' hora-container2
    docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hora-container2
    ```

  * **Explicación:** Cada comando utiliza una plantilla Go para extraer un campo específico del objeto JSON devuelto por `docker inspect`. Esto es increíblemente útil para automatización y para obtener datos precisos rápidamente.

* **Captura de pantalla**
    ![Docker inspect](/assets/day-10/docker_inspect.png "Docker inspect")

### 5\. Configuración de Contenedores con Variables de Entorno

Puse en práctica la configuración dinámica de contenedores usando variables de entorno.

* **Ejecutar contenedor Ubuntu con variables de entorno:**

    ```bash
    docker run -it --name prueba-env -e USUARIO=moises -e AMBIENTE=desarrollo ubuntu bash
    ```

  * **Explicación:** Se lanza un contenedor interactivo de Ubuntu, pasándole las variables `USUARIO` y `AMBIENTE` con el flag `-e`.
* **Comprobar los valores dentro del contenedor:**

    ```bash
    # Dentro del contenedor:
    echo $USUARIO
    echo $AMBIENTE
    env | grep USUARIO
    ```

  * **Explicación:** Verifiqué que las variables de entorno estaban disponibles y accesibles dentro del shell del contenedor.

* **Captura de pantalla**
    ![Prueba de variables de entorno](/assets/day-10/prueba_env.png "Prueba variables de entorno")

* **Configurar un contenedor MariaDB con variables de entorno:**

    ```bash
    docker run -d --name mi-mariadb -p 3306:3306 \
      -e MARIADB_ROOT_PASSWORD=mi_clave_secreta \
      -e MARIADB_USER=devops_user \
      -e MARIADB_PASSWORD=devops_pass \
      -e MARIADB_DATABASE=mi_app_db \
      mariadb
    ```

  * **Explicación:** Se inicia un contenedor MariaDB. Las variables de entorno son cruciales aquí para configurar la contraseña de root, crear un usuario y una base de datos inicial, siguiendo la documentación de la imagen `mariadb`.
* **Verificar variables dentro del contenedor MariaDB:**

    ```bash
    docker exec -it mi-mariadb env | grep MARIADB
    ```

  * **Explicación:** Con `docker exec`, accedí al entorno del contenedor MariaDB y filtré las variables relacionadas con MariaDB para confirmar que se habían aplicado correctamente.

* **Captura de pantalla**
    ![Contenedor de MariaDB](/assets/day-10/mariadb.png "Contenedor de MariaDB")

* **Acceder a MariaDB desde el host (requiere cliente `mysql`):**

    ```bash
    mysql -u root -p -h 127.0.0.1 -P 3306
    # Ingresar 'mi_clave_secreta' cuando se solicite la contraseña.
    ```

* **Captura de pantalla**
    ![Conectar MariaDB](/assets/day-10/mariadb_connect.png "Conectar MariaDB")

  * **Explicación:** Demostré cómo conectarse a la base de datos MariaDB que corre en el contenedor desde mi máquina virtual, usando el mapeo de puertos (`-p 3306:3306`).

### 6\. Reto del Día

Este reto integró varios conceptos aprendidos.

* **Crear un contenedor personalizado que escribe mensajes en `mensajes.txt`:**

    ```bash
    docker run -d --name reto-container ubuntu bash -c 'COUNT=0; while true; do echo "Mensaje $COUNT: $(date)" >> mensajes.txt; COUNT=$((COUNT+1)); sleep 5; done'
    ```

  * **Explicación:** Un contenedor Ubuntu que cada 5 segundos escribe un mensaje diferente (con un contador y la fecha) en un archivo `mensajes.txt`.
* **Copiar `mensajes.txt` del contenedor al host y verificar:**

    ```bash
    docker cp reto-container:mensajes.txt .
    cat mensajes.txt
    ```

  * **Explicación:** Se copia el archivo generado en el contenedor a mi VM y se verifica su contenido.
* **Obtener IP y nombre de imagen con `docker inspect`:**

    ```bash
    docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' reto-container
    docker inspect --format='{{.Config.Image}}' reto-container
    ```

* **Captura de pantalla**
    ![Reto del dia](/assets/day-10/reto_dia.png "Reto del dia")

  * **Explicación:** Utilicé los filtros de `docker inspect` para extraer la IP y la imagen utilizada por el contenedor.
* **Comprobar procesos activos con `docker top`:**

    ```bash
    docker top reto-container
    ```

  * **Explicación:** Verifiqué que el proceso `bash -c 'COUNT=0; while true; ...'` seguía ejecutándose dentro del contenedor.
* **Detener y eliminar el contenedor de forma forzada en un solo comando:**

    ```bash
    docker rm -f reto-container
    ```

  * **Explicación:** Se eliminó el contenedor `reto-container` de forma forzada, sin necesidad de un `docker stop` previo.

### 7\. Reto Extra: Variables de Entorno

* **Ejecutar contenedor Alpine con variables de entorno e imprimirlas:**

    ```bash
    docker run --rm -e APP_ENV=development -e APP_VERSION=1.0.0 alpine sh -c 'echo "Entorno: $APP_ENV, Versión: $APP_VERSION"'
    ```

  * **Explicación:** Se lanza un contenedor Alpine efímero (`--rm`) al que se le pasan dos variables de entorno. El comando `sh -c` dentro del contenedor las imprime, demostrando su accesibilidad.

* **Captura de pantalla**
    ![Reto extra](/assets/day-10/reto_extra.png "Reto extra")

## 💭 Reflexiones y lecciones clave

El Día 10 consolidó mi control sobre los contenedores. La capacidad de monitorear logs, gestionar el ciclo de vida de forma granular, y especialmente, configurar aplicaciones con variables de entorno, son habilidades indispensables para cualquier profesional DevOps.

* **Configuración Dinámica:** Las variables de entorno son un concepto fundamental. Me permiten usar la misma imagen para diferentes propósitos y entornos, lo cual es la base de la portabilidad y la automatización en un pipeline CI/CD.
* **Visibilidad y Depuración:** Comandos como `docker logs`, `docker top` y `docker inspect --format` son herramientas poderosas para entender qué está pasando *dentro* de un contenedor y depurar problemas de manera eficiente. Ya no es una "caja negra".
* **Automatización en Mente:** Cada comando aprendido hoy tiene un potencial enorme para ser integrado en scripts Bash o herramientas de orquestación futuras. La capacidad de obtener IPs, estados y configurar dinámicamente es clave para la automatización.
* **Práctica con MariaDB:** El ejemplo con MariaDB fue muy ilustrativo, ya que mostró cómo las imágenes de software complejo dependen fuertemente de las variables de entorno para su inicialización y configuración.

Me siento mucho más seguro y capaz de administrar contenedores Docker de manera efectiva. El camino hacia la contenerización de la Roxs Voting App se ve cada vez más claro.

## 📎 Recursos

* 🧠 [Artículo del reto Día 10](https://90daysdevops.295devops.com/semana-01/dia10)
* 📘 [Documentación oficial de Docker: `docker logs`](https://docs.docker.com/engine/reference/commandline/logs)
* 📘 [Documentación oficial de Docker: `docker pause` y `docker unpause`](https://docs.docker.com/engine/reference/commandline/pause)
* 📘 [Documentación oficial de Docker: `docker restart`](https://docs.docker.com/engine/reference/commandline/restart)
* 📘 [Documentación de la imagen MariaDB en Docker Hub](https://hub.docker.com/_/mariadb)
