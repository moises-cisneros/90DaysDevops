# 🚀 Guía de Scripts Bash - Día 05

¡Bienvenido a la colección de scripts Bash del Día 05\! Aquí encontrarás una variedad de ejemplos, desde los más básicos hasta proyectos completos, diseñados para automatizar tareas en entornos de desarrollo y operaciones.

## ⚙️ Requisitos y Ejecución

Estos scripts están diseñados para **Linux o WSL (Windows Subsystem for Linux)**. En Windows puro, algunas funcionalidades de sistema (`systemctl`, `apt`, `/var/log`) pueden no ser compatibles.

### Cómo ejecutar un script

1. **Dale permisos de ejecución:**

    ```bash
    chmod +x nombre_del_script.sh
    ```

2. **Ejecútalo:**

    ```bash
    ./nombre_del_script.sh
    ```

    *(Si necesita `sudo` estará especificado en la descripción o ejemplo de uso.)*

## 📚 Contenido de los Scripts

Haz clic en la categoría para ir directamente a la sección.

<ul>
    <li><a href="#scripts-basicos">🔵 Scripts Básicos</a></li>
    <li><a href="#scripts-intermedios">🟢 Scripts Intermedios</a></li>
    <li><a href="#scripts-avanzados">🟠 Scripts Avanzados</a></li>
    <li><a href="#proyectos-complejos">🟣 Proyectos Complejos</a></li>
</ul>

-----

<h3 id="scripts-basicos">🔵 Scripts Básicos</h3>

Estos scripts son ideales para familiarizarse con la sintaxis y los conceptos fundamentales de Bash. Simplemente ejecútalos como se describe en la sección de **Requisitos**.

| Script             | Descripción                                       | Uso Básico                      |
| :----------------- | :------------------------------------------------ | :------------------------------ |
| `hello_devops.sh`  | Otro saludo simple, enfocado en DevOps.           | `./hello_devops.sh`             |
| `variables_saludo.sh` | Muestra el uso de variables en un saludo.         | `./variables_saludo.sh`         |
| `pregunta.sh`      | Pide una entrada al usuario y la muestra.         | `./pregunta.sh`                 |
| `bucle_for.sh`     | Demuestra un bucle `for` simple.                  | `./bucle_for.sh`                |
| `condicional_sed.sh`| Ejemplo de condicional usando `sed`.               | `./condicional_sed.sh`          |
| `existe_archivo.sh`| Verifica si un archivo existe.                    | `./existe_archivo.sh`           |
| `mi_status.sh`     | Muestra un mensaje de estado básico.             | `./mi_status.sh`                |

-----

<h3 id="scripts-intermedios">🟢 Scripts Intermedios</h3>

Estos scripts introducen interacciones más complejas, uso de argumentos y lógica condicional.

#### `presentacion.sh`

* **Descripción:** Pide tu nombre y edad, luego muestra un saludo personalizado.
* **Uso:**

    ```bash
    ./presentacion.sh
    ```

* **Ejemplo de Salida:**

    ```bash
    ¿Cómo te llamás?
    > Moises
    ¿Cuántos años tenés?
    > 20
    Hola Moises, tenés 20 años. ¡Bienvenid@ al mundo Bash!
    ```

#### `multiplicar.sh`

* **Descripción:** Multiplica dos números pasados como **argumentos**.
* **Uso:**

    ```bash
    ./multiplicar.sh 2 3
    ```

* **Ejemplo de Salida:**

    ```text
    El resultado de 2 x 3 es 6
    ```

#### `tabla_5.sh`

* **Descripción:** Imprime la tabla de multiplicar del 5.
* **Uso:**

    ```bash
    ./tabla_5.sh
    ```

* **Ejemplo de Salida:**

    ```text
    Tabla del 5:
    5 x 1 = 5
    5 x 2 = 10
    ...
    5 x 10 = 50
    ```

#### `buscar_palabra.sh`

* **Descripción:** Busca una palabra específica dentro de un archivo.
* **Uso:**

    ```bash
    ./buscar_palabra.sh archivo.txt DevOps
    ```

* **Ejemplo de Salida:**

    ```text
    ¡Encontrado!
    ```

    *(Si la palabra no se encuentra, mostrará "No encontrado.")*

#### `mostrar_archivo.sh`

* **Descripción:** Muestra el contenido de un archivo. Si el archivo no existe, notifica.
* **Uso:**

    ```bash
    ./mostrar_archivo.sh archivo.txt
    ```

* **Ejemplo de Salida:**

    ```text
    (contenido del archivo)
    ```

    *(Si no existe, mostrará "El archivo archivo.txt no existe.")*

#### `check_site.sh`

* **Descripción:** Verifica si un sitio web específico está accesible.
* **Uso:**

    ```bash
    ./check_site.sh
    ```

* **Ejemplo de Salida:**

    ```text
    El sitio https://roxs.295devops.com está accesible.
    ```

-----

<h3 id="scripts-avanzados">🟠 Scripts Avanzados</h3>

Estos scripts realizan tareas de administración de sistema, monitoreo y automatización de procesos comunes en DevOps. Algunos pueden requerir permisos de `sudo`.

#### `backup_logs.sh`

* **Descripción:** Crea un backup comprimido de los logs del sistema y elimina los backups antiguos para ahorrar espacio.
* **Uso:**

    ```bash
    ./backup_logs.sh
    ```

* **Ejemplo de Salida:**

    ```text
    Backup realizado en /home/usuario/backups/log_backup_20250614_153000.tar.gz
    ```

#### `monitor_disco.sh`

* **Descripción:** Monitorea el uso del espacio en disco (incluyendo `/home`) y registra alertas en un archivo de log si el uso supera un umbral.
* **Uso:**

    ```bash
    ./monitor_disco.sh
    ```

* **Ejemplo de Salida (en log):**

    ```text
    2025-06-14 15:30:00 - ¡Alerta: Partición / al 92%!
    ```

#### `monitor_sistema.sh`

* **Descripción:** Monitorea los recursos del sistema (CPU, memoria, disco) y puede detenerse automáticamente si la utilización de CPU excede un límite varias veces consecutivas.
* **Uso:**

    ```bash
    ./monitor_sistema.sh
    ```

* **Ejemplo de Salida:**

    ```text
    Hora             Memoria   Disco (root)   CPU
    2025-06-14 ...   45%        60%            12
    ...
    CPU superó 85% tres veces seguidas. Cortando monitoreo.
    ```

#### `servicio_status.sh`

* **Descripción:** Revisa el estado de servicios específicos del sistema (ej. `nginx`, `docker`) y reporta si están activos o caídos en un log.
* **Uso:**

    ```bash
    ./servicio_status.sh
    ```

* **Ejemplo de Salida:**

    ```text
    nginx está activo.
    docker está caído.
    ```

#### `listar_procesos.sh`

* **Descripción:** Lista todos los procesos en ejecución en el sistema y guarda la salida en un archivo de texto.
* **Uso:**

    ```bash
    ./listar_procesos.sh
    ```

* **Ejemplo de Salida:**

    ```text
    Procesos listados en process_list.txt
    ```

#### `instalar_paquetes.sh`

* **Descripción:** Verifica e instala una lista predefinida de paquetes de software si aún no están presentes en el sistema.
* **Uso:**

    ```bash
    ./instalar_paquetes.sh
    ```

* **Ejemplo de Salida:**

    ```text
    git ya está instalado.
    Instalando vim...
    ```

#### `monitor_cpu_mem.sh`

* **Descripción:** Monitorea y registra el uso de CPU y memoria del sistema a intervalos regulares (cada 5 segundos), guardando la información en un archivo de log.
* **Uso:**

    ```bash
    ./monitor_cpu_mem.sh
    ```

* **Ejemplo de Salida (en log):**

    ```text
    2025-06-14 15:30:00 - CPU: 5.2% | Memoria: 800/2000MB
    ```

#### `limpiar_logs.sh`

* **Descripción:** Elimina archivos de log antiguos (mayores a 7 días) del directorio `/var/log` para liberar espacio.
* **Uso:**

    ```bash
    sudo ./limpiar_logs.sh
    ```

* **Ejemplo de Salida:**

    ```text
    Logs mayores a 7 días eliminados.
    ```

#### `crear_usuario_devops.sh`

* **Descripción:** Automatiza la creación de un nuevo usuario y lo añade a un grupo `devops` específico.
* **Uso:**

    ```bash
    sudo ./crear_usuario_devops.sh moises
    ```

* **Ejemplo de Salida:**

    ```text
    Usuario moises creado y agregado al grupo devops.
    ```

    *(Si el usuario ya existe, mostrará "El usuario ya existe.")*

#### `extraer_errores.sh`

* **Descripción:** Filtra y extrae mensajes de error específicos de un archivo de log proporcionado.
* **Uso:**

    ```bash
    ./extraer_errores.sh archivo.log
    ```

* **Ejemplo de Salida:**

    ```text
    ERROR: No se pudo conectar a la base de datos
    ...
    ```

#### `backup_cron.sh`

* **Descripción:** Script diseñado para ser programado con `cron` para realizar copias de seguridad diarias de un directorio específico a otro destino.
* **Uso:**

    ```bash
    ./backup_cron.sh /ruta/origen /ruta/destino
    ```

* **Ejemplo de Salida:**

    ```text
    Backup realizado en /ruta/destino/backup_20250614_153000.tar.gz
    ```

-----

<h3 id="proyectos-complejos">🟣 Proyectos Complejos</h3>

Estos scripts representan soluciones de automatización más completas, simulando despliegues o flujos de trabajo más elaborados.

#### `desplegar_app.sh`

* **Descripción:** Script de despliegue automatizado para una aplicación Flask (ej. "Book Library") utilizando Gunicorn como servidor de aplicación y Nginx como proxy inverso. Incluye verificación de servicios.
* **Uso:**

    ```bash
    ./desplegar_app.sh
    ```

* **Ejemplo de Salida:**

    ```text
    === Iniciando despliegue de Book Library ===
    Instalando dependencias...
    Clonando la aplicación...
    Configurando entorno virtual...
    Iniciando Gunicorn...
    Configurando Nginx...
    Verificando servicios...
    ✓ Nginx está activo
    ✓ Gunicorn está corriendo
    ✓ Puerto 8000 está en uso
    ✓ Gunicorn responde correctamente
    === Despliegue finalizado ===
    Revisá logs_despliegue.txt para detalles.
    La aplicación debería estar disponible en: http://127.0.0.1
    ```
