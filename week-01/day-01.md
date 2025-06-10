# Día 01 - DevOps y la Importancia de Linux

📅 Fecha: 10/06/2025

## ✅ Tema del día

Hoy desentrañamos **DevOps**, una filosofía que revoluciona cómo los equipos de desarrollo y operaciones colaboran para entregar software más rápido y mejor. Además, nos sumergimos en el **mundo de Linux**, el sistema operativo esencial que impulsa casi todo en el universo DevOps.

-----

## 🧠 Lo que aprendí

### ¿Qué es DevOps? El Puente entre Desarrollo y Operaciones

Imagina que **Dave** (desarrollador) crea software, pero su código tarda mucho en llegar a los usuarios y, a veces, falla en producción. Esto pasa porque su entorno no es idéntico al de **Anna** (operaciones), quien mantiene los sistemas y le cuesta adaptar el nuevo código, programando lanzamientos muy espaciados. Ambos quieren clientes felices, ¡pero trabajan "por separado"\!

**DevOps** es una filosofía que une a Dave y Anna, haciéndolos trabajar juntos. ¿Cómo lo logran?

* **Automatizan todo:** Desde probar el código hasta configurar servidores.
* **Crean en "pedacitos":** Lanzan nuevas funciones muy rápido (horas, no meses).
* **Igualan entornos:** Lo que funciona para Dave, funciona para Anna.
* **Escriben la infraestructura como código:** Para construir sistemas grandes de forma rápida y consistente.
* **Monitorean en tiempo real:** Saben al instante cómo funciona el software y si algo falla.

**El resultado:** La empresa de Dave y Anna lanza productos mucho más rápido (días en vez de meses), se enfoca más en lo que importa al negocio y tiene clientes y equipos más felices.

Para lograr esto, necesitan un **cambio de mentalidad** (trabajar en equipo) y **nuevas herramientas** (como Jenkins para pruebas, GitHub para el código, Chef para automatizar servidores y New Relic para monitorear).

DevOps es clave para que las empresas innoven velozmente y respondan a lo que el mercado necesita, mejorando la calidad y la frecuencia de sus lanzamientos de software.

-----

### ¿Por qué Linux es CLAVE en DevOps?

Si DevOps es el cerebro, **Linux es el corazón**. Este sistema operativo es indispensable en el 90% de los servidores de producción y la base de casi todas las herramientas DevOps.

**Linux es esencial por:**

* **Rey de los servidores:** Nube (AWS, Google Cloud, Azure) = Linux por defecto. ¡Es el estándar\!
* **Open-Source = Libertad:** Herramientas como Docker, Kubernetes, Jenkins y Ansible funcionan mejor en Linux.
* **Terminal = Poder:** La línea de comandos de Linux (Bash) permite automatizar cualquier tarea.
* **Contenedores:** Docker y Kubernetes (las bases de los contenedores) están profundamente integrados con el kernel de Linux.
* **Seguridad:** Ofrece un control robusto con permisos, SELinux e iptables.
* **La nube lo ama:** Herramientas de Infraestructura como Código (IaC) como Terraform y Ansible brillan en entornos Linux.

**En resumen, un Ingeniero DevOps *debe* dominar Linux** para operar la terminal, automatizar con scripts, entender contenedores y tener control total sobre los servidores.

-----

### Reflexión Personal

Después de esta lección, DevOps para mí significa **la sinergia necesaria entre desarrollo y operaciones para crear un flujo continuo de valor**, donde la automatización y la colaboración son el pilar. Ya conocía GitHub (para control de versiones) y la existencia de Linux, pero herramientas como Jenkins, Chef, Puppet y New Relic son nuevas para mí en este contexto DevOps. Me emociona aprender cómo todas estas piezas encajan.

-----

## ⚙️ Ejercicios realizados

### 🖥️ Primeros Pasos en Linux

Para empezar, me aseguré de tener **WSL2 (Windows Subsystem for Linux)** instalado, ya que es la forma más eficiente de trabajar con Linux desde Windows sin una máquina virtual completa.

* **Instalación de WSL:** Confirmé mi instalación de WSL2, que permite acceder a la potencia de Linux directamente en Windows. (Comando: `wsl --install` si no lo tuviera).
  
  * *Captura de terminal: ![Status WSL](/assets/day-01/wsl_status.png "Status WSL")*

Probé los siguientes comandos básicos para familiarizarme con la terminal:

```bash
whoami         # Muestra mi nombre de usuario actual
pwd            # Imprime el directorio de trabajo actual
ls -lah        # Lista el contenido del directorio con detalles y tamaños legibles
mkdir day-01 # Crea un nuevo directorio llamado 'day-01'
cd day-01   # Entra en el directorio 'day-01'
echo "Hola DevOps" > hola.txt # Crea un archivo 'hola.txt' con el texto "Hola DevOps"
cat hola.txt   # Muestra el contenido del archivo 'hola.txt'
```

* *Captura de terminal: ![Comandos Linux en Terminal](/assets/day-01/comandos_linux.png "Comandos Linux")*

-----

## 💭 Reflexiones

Hoy fue un día fundamental. Entender la problemática entre Dev y Ops me hizo ver la **razón de ser de DevOps**, no solo como un conjunto de herramientas, sino como una **transformación cultural**. Dar mis primeros pasos con Linux en WSL me confirmó por qué es la base de todo lo que haré en este camino DevOps. Aunque los comandos fueron básicos, sentí el "poder" de la terminal que el artículo mencionaba. ¡Me entusiasma seguir explorando\!

-----

## 📎 Recursos

* **Video original que inspiró este resumen:** [What is DevOps? - Rackspace Technology](https://youtu.be/_I94-tJlovg?si=hCYGE-unV8DE6wdJ)
* **Artículo del reto (Día 1):** [Enlace al artículo "DevOps en 90 Días con Roxs - Día 1"](https://90daysdevops.295devops.com/semana-01/dia1/)
* **Guía de instalación de WSL:** [Instalación de Linux en Windows con WSL](https://learn.microsoft.com/es-es/windows/wsl/install)

-----
