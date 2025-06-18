# Día 06 - Introducción a Ansible: Automatización de Infraestructura

📅 **Fecha:** 12/06/2025

## ✅ Tema del día

Hoy dimos un salto fundamental en el mundo de DevOps con la **introducción a Ansible**. Exploramos qué es Ansible, por qué es una herramienta de automatización de infraestructura tan popular, y cómo utilizar su Interfaz de Línea de Comandos (CLI) para aprovisionar y gestionar servidores de forma declarativa. El objetivo central fue aprender a orquestar y configurar múltiples máquinas de manera eficiente y repetible, **enfocándonos en la superación de desafíos al usar Windows como sistema operativo anfitrión y la implementación de Ansible en una máquina virtual para gestionar otra.**

## 🧠 Lo que aprendí

Este día estuvo cargado de conceptos y configuraciones prácticas para sentar las bases de la automatización con Ansible:

* **¿Qué es Ansible?**
  * Comprendí que Ansible es una herramienta de automatización, configuración de gestión y orquestación que utiliza un modelo **sin agente**. Esto significa que solo necesita SSH para comunicarse con los nodos gestionados, simplificando enormemente su instalación y mantenimiento en comparación con otras herramientas.
  * Entendí su filosofía de **"infraestructura como código"**, permitiendo definir el estado deseado de los sistemas en archivos YAML (Playbooks).
* **Componentes Clave de Ansible:**
  * **Control Node:** La máquina donde se ejecuta Ansible y desde donde se gestionan los demás nodos.
  * **Managed Nodes (o Nodos Clientes):** Los servidores remotos que Ansible configura.
  * **Inventario (`inventory.ini`):** El archivo que define los hosts y grupos de hosts que Ansible va a gestionar.
  * **Playbooks:** Archivos YAML que describen las tareas a ejecutar en los nodos gestionados.
  * **Módulos:** Unidades de código reutilizables que Ansible ejecuta en los nodos (ej. `apt`, `service`, `copy`, `user`).
  * **Roles:** Una forma estructurada de organizar playbooks, variables, tareas, handlers, etc., para proyectos complejos y reutilizables.
* **Flujo de Trabajo Básico con Ansible:**
  * **Conectividad SSH:** La base de Ansible. Aprendí la importancia de configurar la autenticación SSH sin contraseña (con `ssh-copy-id`) y asegurar los permisos de `sudo NOPASSWD` para el usuario de conexión.
  * **Archivo de Inventario:** Cómo definir grupos de servidores y especificar el usuario de conexión (`ansible_user`).
  * **Comandos Ad-Hoc:** Ejecutar comandos de Ansible directamente desde la línea de comandos para tareas rápidas y sencillas (`ansible all -m ping`).
  * **Playbooks:** Escribir y ejecutar Playbooks YAML para automatizar secuencias de tareas complejas (`ansible-playbook`).
* **Preparación de Entornos Virtuales (VirtualBox):**
  * **Configuración de Red:** La experiencia práctica de configurar redes internas (Host-only o Internal Network) y NAT en VirtualBox para asegurar la comunicación entre el nodo de control y los nodos clientes, además de acceso a internet.
  * **Configuración de IP Estática:** Cómo asignar IPs estáticas en Ubuntu usando Netplan.
  * **Precauciones de Seguridad:** Asegurar permisos correctos en archivos de configuración (`chmod 600`) y configurar `ufw` para permitir SSH.
  * **Creación de Usuarios y Sudo:** Preparar usuarios en los nodos gestionados con permisos `sudo NOPASSWD` para que Ansible pueda ejecutar comandos con privilegios elevados sin intervención manual.

## ⚙️ Preparación del Laboratorio (Paso a Paso)

Para practicar con Ansible, configuré un entorno de laboratorio con dos máquinas virtuales en VirtualBox: un **Nodo de Control** y un **Nodo Cliente**.

### 1\. Configuración de Máquinas Virtuales en VirtualBox

* **Creación de Nodos:** Creé dos VMs con Ubuntu 24.04. La creación de la segunda VM fue un pequeño desafío, ya que la instalación se "congelaba", lo que requirió crear un nuevo archivo de instalación. ¡Pequeños percances que demuestran la importancia de la paciencia en DevOps\!

* **Instalación de Guest Additions:** Fundamental para una mejor experiencia (copiar/pegar, redimensionar pantalla). Previamente, necesité instalar `bzip2`.

* **Configuración de Red en VirtualBox:**

  * Establecí el **Adaptador 1 como NAT** (para internet) y el **Adaptador 2 como Red Interna** (`ansible-lab`) para la comunicación entre los nodos.
  * *Anécdota:* Inicialmente, tuve la configuración al revés (Adaptador 1 como Red Interna y Adaptador 2 como NAT) lo que me generó horas de depuración hasta darme cuenta de que el orden importaba para el acceso a internet y la red interna simultáneamente. ¡Una lección de persistencia\!

* **Captura de pantalla**
![Nodos Virtuales](/assets/day-06/nodos_ansible.png "Nodos virtuales")

### 2\. Configuración de IP Estática en Nodos (Control y Cliente)

* **Edición de Netplan:** En ambos nodos, configuré una IP estática para el adaptador de Red Interna (`enp0s8`).

    ```yaml
    # /etc/netplan/01-netcfg.yaml
    network:
      ethernets:
        enp0s8:
          dhcp4: no
          addresses: [192.168.56.10/24] # .10 para Control, .11 para Cliente
          nameservers:
            addresses: [8.8.8.8, 8.8.4.4]
      version: 2
    ```

* **Permisos de Seguridad:** Ajusté los permisos de los archivos Netplan a `600` para mayor seguridad:

    ```bash
    sudo chmod 600 /etc/netplan/01-netcfg.yaml
    sudo chmod 600 /etc/netplan/01-network-manager-all.yaml
    ```

* **Aplicación de Cambios:** `sudo netplan apply` para activar la nueva configuración de red.

* **Verificación de Conectividad:** Realicé pings entre el Nodo de Control (192.168.56.10) y el Nodo Cliente (192.168.56.11) para confirmar la comunicación.

### 3\. Preparación del Nodo Cliente (192.168.56.11)

* **Actualización y SSH Server:**

    ```bash
    sudo apt update
    sudo apt install openssh-server -y
    sudo systemctl enable --now ssh # Iniciar y habilitar SSH
    sudo ufw allow ssh              # Permitir SSH en el firewall
    sudo ufw enable                 # Habilitar firewall
    ```

* **Creación de Usuario `admin` con Sudo NOPASSWD:**
  * Creé el usuario `admin` y le di permisos de `sudo` sin contraseña. Esto es crucial para que Ansible no pida contraseña en cada operación que requiera privilegios.
  * Modificación de `/etc/sudoers` (usando `sudo visudo`):

    ```Markdown
    admin ALL=(ALL) NOPASSWD: ALL
    ```

### 4\. Configuración del Nodo de Control (192.168.56.10)

* **Generación y Copia de Clave SSH:**
  * Generé la clave SSH (`ssh-keygen -t rsa -b 4096`).
  * Copié la clave pública al Nodo Cliente (`ssh-copy-id admin@192.168.56.11`).
  * Verifiqué la conexión SSH sin contraseña (`ssh admin@192.168.56.11`).
* **Estructura de Directorios para Ansible:**

    ```bash
    mkdir ~/ansible_projects
    cd ~/ansible_projects
    ```

* **Archivo de Inventario (`inventory.ini`):**

    ```ini
    # ~/ansible_projects/inventory.ini
    [webservers]
    192.168.56.11 ansible_user=admin

    [all:vars]
    ansible_python_interpreter=/usr/bin/python3
    ```

* **Archivo de Configuración de Ansible (`ansible.cfg`):**

    ```ini
    # ~/ansible_projects/ansible.cfg
    [defaults]
    inventory = ./inventory.ini
    ```

### 5\. Verificación de Conectividad con Ansible

* Realicé un `ping` ad-hoc para verificar que Ansible pudiera comunicarse con el nodo cliente:

    ```bash
    ansible all -m ping
    ```

* Salida esperada: Un `SUCCESS` con `"ping": "pong"` para `192.168.56.11`.

* **Captura de pantalla**
![Ansible inicia](/assets/day-06/ansible_ini.png "Ansible inicia")

### 6\. Ejecución de Comandos Ad-Hoc

* Probé la instalación de Nginx y el reinicio del servicio con comandos ad-hoc. Estos son útiles para tareas rápidas sin necesidad de un playbook completo.

    ```bash
    ansible webservers -m apt -a "name=nginx state=present" --become --become-user=root
    ansible all -m service -a "name=nginx state=restarted" --become
    ```

  * Si los comandos resultaron en cambios (`changed=true`) o no hubo errores, significa que Ansible configuró exitosamente Nginx en el nodo cliente.

### 7\. Mi Primer Playbook

* Creé un `primer-playbook.yml` para automatizar la instalación de herramientas esenciales, la creación de un usuario `deploy` y la configuración básica del firewall.

    ```yaml
    # ~/ansible_projects/primer-playbook.yml
    - name: Configuración básica de servidor
      hosts: webservers
      become: yes

      tasks:
        - name: Instalar paquetes esenciales
          apt:
            name: ["git", "tree", "htop"]
            state: present
            update_cache: yes

        - name: Crear usuario deploy
          user:
            name: deploy
            groups: sudo
            append: yes
            password: "{{ 'miPassword123' | password_hash('sha512') }}"

        - name: Habilitar firewall
          ufw:
            rule: allow
            port: "22,80,443"
            proto: tcp
    ```

* **Ejecución:**

    ```bash
    ansible-playbook primer-playbook.yml
    ```

* **Captura de pantalla**
![Primer playbook](/assets/day-06/primer_playbook.png "Primer playbook")

### Proyecto 1: Despliegue de un Servidor Nginx Básico

Este proyecto se centró en la configuración y despliegue fundamental de un servidor web Nginx, sirviendo como una introducción práctica a la automatización de la configuración de servicios.

* [**`proyecto_nginx.md`**](/week-01/day-06/ansible_apache/proyecto_apache.md)

### Proyecto 2: Despliegue y Gestión de Servidor Apache con Monitorización

Aquí se exploró la gestión de un servidor Apache, incluyendo la instalación, configuración de sitios web y una introducción a la monitorización básica, todo automatizado con Ansible.

* [**`proyecto_apache.md`**](/week-01/day-06/ansible_apache/proyecto_apache.md)

### Proyecto 3: Despliegue de Plantilla Web Freelancer con Vagrant y Ansible Local

Este fue un proyecto crucial que combinó Vagrant para la creación de la VM y **Ansible ejecutándose localmente dentro de esa VM (ansible\_local)** para desplegar una plantilla web HTML estática. Esta implementación fue clave para superar los desafíos de compatibilidad de Ansible en mi entorno Windows.

* [**`proyecto_freelancer.md`**](/week-01/day-06/freelancer_deploy/proyecto_freelancer.md)

### Proyecto 4: Desafío Día 6 - Despliegue con Vagrant y Roles

El desafío del día consolidó la integración de Vagrant y Ansible, permitiéndome orquestar el despliegue de un entorno con múltiples servicios y configuraciones complejas, utilizando la estructura de roles para una gestión eficiente.

* [**`proyecto_desafio_day6.md`**](/week-01/day-06/desafio_ansible_day6/proyecto_desafio_day6.md)

## 💭 Reflexiones y lecciones clave

El Día 6 fue, sin duda, uno de los más **desafiantes pero gratificantes**. La configuración inicial del laboratorio con VirtualBox y la red me llevó **unas horas** de configurar y depurar. La anécdota de invertir la configuración de los adaptadores de red (NAT vs. Red Interna) es un claro ejemplo de cómo pequeños detalles pueden consumir mucho tiempo y la importancia de la paciencia y la depuración metódica.

### Superando el Desafío del Entorno Windows

Uno de los mayores aprendizajes de este día fue la **adaptación del flujo de trabajo de Ansible a mi sistema operativo Windows**. Inicialmente, intenté instalar y ejecutar Ansible directamente en Windows o a través de WSL, lo cual presentó diversas incompatibilidades y frustraciones. La lección clave aquí fue la **capacidad de Pivotar:** en lugar de forzar la instalación directa, opté por una solución más robusta y habitual en el mundo DevOps: **crear una máquina virtual (VM) en VirtualBox y usarla como mi "nodo de control" de Ansible**. Esto me permitió:

* Tener un entorno Linux nativo y estable para Ansible.
* Evitar problemas de PATH, permisos de Windows y compatibilidad de Python.
* Aprender a usar **`ansible_local` en Vagrant**, una técnica poderosa para aprovisionar la propia VM donde reside el Vagrantfile. Esta fue la solución para los proyectos más complejos, como el despliegue de la plantilla Freelancer y el Desafío del Día 6.

### El Poder de Ansible y los Roles

Ansible es una herramienta **increíblemente potente y flexible**. La capacidad de describir el estado deseado de la infraestructura en archivos YAML y dejar que Ansible se encargue de la implementación es un cambio de paradigma total respecto a la configuración manual. Los **roles** son esenciales para organizar proyectos grandes y hacer el código reutilizable, algo que valoro mucho para mantener una "infraestructura como código" limpia y escalable.

La práctica con los comandos ad-hoc y, especialmente, la creación y ejecución de **playbooks complejos** para Nginx y Apache, demostraron el verdadero poder de Ansible para automatizar despliegues de aplicaciones, configuración de firewalls y hasta la gestión de usuarios. Es una habilidad fundamental que me acerca un paso más a ser un ingeniero DevOps competente.

## 📎 Recursos

* 🧠 [Artículo del reto Día 6](https://90daysdevops.295devops.com/semana-01/dia6)
* 🌐 [Sitio oficial de Ubuntu](https://ubuntu.com/download/desktop)
* 📄 [Documentación oficial de Ansibl](https://docs.ansible.com/)
* 🌐 [Solución a problemas de sudo en Ansible (Stack Overflow)](https://stackoverflow.com/questions/16408877/jenkins-fails-while-restarting-my-sql-sudo-no-tty-present-and-no-askpass-progr)
* 🌐 [Link donde consegu iconos (Ansible)](https://github.com/benc-uk/icon-collection)
