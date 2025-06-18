# Día 05 - Automatizando Tareas con Bash Scripting

📅 **Fecha:** 11/06/2025

## ✅ Tema del día

Hoy exploré el poder del **Bash scripting** para la automatización de tareas en entornos Linux. Aprendí a escribir scripts desde cero, utilizando variables, condicionales y bucles, y a aplicarlos en escenarios reales de administración de sistemas y DevOps, desde el monitoreo hasta la gestión de servicios y el despliegue de aplicaciones. Entender Bash es crucial para un ingeniero DevOps, ya que permite transformar procesos manuales y repetitivos en flujos de trabajo eficientes y consistentes.

## 🧠 Lo que aprendí

Este día fue una inmersión profunda en la programación con Bash, cubriendo desde los fundamentos hasta técnicas más avanzadas:

* **Fundamentos de Bash Scripting:**
  * Cómo crear un script Bash (`#!/bin/bash`), darle permisos de ejecución (`chmod +x`), y ejecutarlo (`./script.sh`).
  * Uso de **variables** (sin `let` ni `var`, asignación directa `NOMBRE="valor"`) y cómo interpolarlas (`$NOMBRE`).
  * Interacción con el usuario mediante `read` para capturar entradas.
  * Implementación de **condicionales (`if`, `elif`, `else`, `fi`)** para lógica de decisión (`[ "$VAR" == "valor" ]`, `[ $NUM -gt 5 ]`, `[ -f archivo ]`, `[ -d carpeta ]`).
  * Uso de **bucles (`for`, `while`)** para automatizar tareas repetitivas.
* **Buenas Prácticas en Bash:**
  * Siempre incluir `#!/bin/bash` al inicio.
  * Usar `set -e` para que el script se detenga inmediatamente si un comando falla (evitando errores silenciosos).
  * Comentar el código (`#`) para mejorar la legibilidad y mantenimiento.
  * Probar los scripts en entornos controlados (como Vagrant).
* **Técnicas Avanzadas de Bash:**
  * **Funciones:** Modularizar scripts para organizar y reutilizar bloques de código (`saludar_usuario() { ... }`).
  * **Manejo de Arrays:** Almacenar y procesar listas de elementos (`archivos=("a.txt" "b.txt")`, `for archivo in "${archivos[@]}"`).
  * **Manejo de Errores:** Validar la existencia de archivos (`if [[ -f $archivo ]]`) y usar `exit 1` para indicar fallos.
  * **Programación con Cron:** Automatizar la ejecución de scripts en horarios específicos (`crontab -e`).
  * **Depuración (`set -x`):** Ver cada comando ejecutado en la terminal para identificar problemas.
  * **Validación de Entradas:** Verificar el número de argumentos de un script (`if [[ $# -ne 1 ]]`).
  * **Integración con Herramientas Externas:** Uso de `jq` para procesar JSON en scripts, demostrando la versatilidad de Bash para interactuar con otras herramientas.
  * **Scripts Modulares (`source`):** Dividir la lógica en múltiples archivos y cargarlos según sea necesario.
* **Aplicaciones Prácticas de Automatización:**
  * Monitoreo de uso de disco y recursos del sistema (CPU, memoria).
  * Verificación y reinicio automático de servicios (e.g., Apache/Nginx).
  * Automatización de backups y limpieza de logs.
  * Gestión automatizada de usuarios.
  * **Despliegue completo de aplicaciones:** Un desafío clave fue automatizar el despliegue de una aplicación Flask con Gunicorn y Nginx, lo que me permitió consolidar muchos conceptos en un flujo de trabajo real.

## ⚙️ Ejercicios realizados

A continuación, la lista de todos los scripts realizados, organizados por nivel de complejidad. Haz clic en cada uno para ver el código:

### Ejercicios Básicos

* [variables_saludo.sh](./day-05/ejercicios_basicos/variables_saludo.sh)
* [pregunta.sh](./day-05/ejercicios_basicos/pregunta.sh)
* [bucle_for.sh](./day-05/ejercicios_basicos/bucle_for.sh)
* [condicional_sed.sh](./day-05/ejercicios_basicos/condicional_sed.sh)
* [existe_archivo.sh](./day-05/ejercicios_basicos/existe_archivo.sh)
* [mi_status.sh](./day-05/ejercicios_basicos/mi_status.sh)
* [hello_devops.sh](./day-05/ejercicios_basicos/hello_devops.sh)

### Ejercicios Intermedios

* [presentacion.sh](./day-05/ejercicios_intermedios/presentacion.sh)
* [multiplicar.sh](./day-05/ejercicios_intermedios/multiplicar.sh)
* [tabla_5.sh](./day-05/ejercicios_intermedios/tabla_5.sh)
* [buscar_palabra.sh](./day-05/ejercicios_intermedios/buscar_palabra.sh)
* [mostrar_archivo.sh](./day-05/ejercicios_intermedios/mostrar_archivo.sh)
* [check_site.sh](./day-05/ejercicios_intermedios/check_site.sh)

### Ejercicios Avanzados

* [backup_logs.sh](./day-05/ejercicios_avanzados/backup_logs.sh)
* [monitor_disco.sh](./day-05/ejercicios_avanzados/monitor_disco.sh)
* [monitor_sistema.sh](./day-05/ejercicios_avanzados/monitor_sistema.sh)
* [servicio_status.sh](./day-05/ejercicios_avanzados/servicio_status.sh)
* [listar_procesos.sh](./day-05/ejercicios_avanzados/listar_procesos.sh)
* [instalar_paquetes.sh](./day-05/ejercicios_avanzados/instalar_paquetes.sh)
* [monitor_cpu_mem.sh](./day-05/ejercicios_avanzados/monitor_cpu_mem.sh)
* [limpiar_logs.sh](./day-05/ejercicios_avanzados/limpiar_logs.sh)
* [crear_usuario_devops.sh](./day-05/ejercicios_avanzados/crear_usuario_devops.sh)
* [extraer_errores.sh](./day-05/ejercicios_avanzados/extraer_errores.sh)
* [backup_cron.sh](./day-05/ejercicios_avanzados/backup_cron.sh)

> Para más detalles, consulta el archivo [`README_SCRIPTS.md`](./day-05/README_SCRIPTS.md), donde se explica cada script, su propósito, funcionamiento y ejemplos de ejecución.

## 🚀 Proyectos

### Despliegue de Aplicación Flask con Gunicorn y Nginx

* [desplegar_app.sh](./day-05/proyectos/desplegar_app.sh): Script completo para automatizar el despliegue de una aplicación Flask (Book Library) usando Gunicorn y Nginx. Incluye instalación de dependencias, clonado, entorno virtual, arranque de Gunicorn, configuración de Nginx y verificación de servicios.

  * *Captura de terminal:
  ![Desplegar App](/assets/day-05/desplegar_app.png "Desplegar App")*

## 💭 Reflexiones y lecciones clave

Este día de Bash scripting fue increíblemente **práctico y revelador**. Al principio, la sintaxis de Bash, especialmente los condicionales y el manejo de argumentos, puede parecer un poco peculiar y desafiante. Sin embargo, al seguir los ejemplos y, sobre todo, al **practicar con los ejercicios y los retos**, la lógica se vuelve mucho más natural.

Lo más valioso fue darme cuenta de cómo un simple script puede **automatizar tareas que, de otro modo, consumirían mucho tiempo y serían propensas a errores manuales**. La capacidad de crear scripts para monitorear el sistema, gestionar servicios o incluso desplegar una aplicación completa es donde reside el verdadero poder de Bash en un contexto DevOps.

La importancia de las **buenas prácticas** como `set -e`, los comentarios, y la **modularidad** con funciones y archivos separados (`source`) se hizo evidente. Scripts bien estructurados son más fáciles de mantener, depurar y escalar. El desafío de desplegar la aplicación Flask fue un excelente cierre, uniendo muchos conceptos y mostrando un caso de uso real de la automatización en un despliegue de desarrollo.

## 📎 Recursos

* 🧠 [Artículo del reto Día 5](https://90daysdevops.295devops.com/semana-01/dia5)
* 📄 [Documentación oficial de Bash](https://www.gnu.org/software/bash/manual/bash.html)
* 📚 [Recopilación de recursos de Bash](https://github.com/awesome-lists/awesome-bash)
