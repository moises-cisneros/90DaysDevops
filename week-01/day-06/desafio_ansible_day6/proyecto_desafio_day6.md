# Proyecto Ansible: Desafío Día 6 - Despliegue con Vagrant y Roles

Este proyecto es la solución al "Desafío Ansible - Día 6" del programa "90 Días de DevOps con Roxs". Su objetivo principal es automatizar la configuración de un servidor desde cero, utilizando una **estructura de roles profesional** y la integración con **Vagrant** para un despliegue reproducible.

## 🎯 Objetivo del Desafío

El objetivo es crear un playbook Ansible llamado `playbook.yml` (o `desplegar_app.yml`, como se mencionó en el desafío) que cumpla con las siguientes tareas:

* **Instalar Nginx** y desplegar una **landing page personalizada**.
* **Crear un usuario `devops`** con acceso `sudo`.
* **Configurar reglas de firewall (UFW)** para permitir el tráfico en los puertos **22 (SSH), 80 (HTTP) y 443 (HTTPS)**.
* Utilizar una **estructura profesional** basada en directorios `inventories/` y `roles/`.
* **Integrar el despliegue con Vagrant** para que la máquina virtual se configure automáticamente al iniciar.

## 📁 Estructura del Proyecto

```txt
desafio_ansible_dia6/
├── Vagrantfile            # Configuración de la VM con Vagrant
├── playbook.yml           # Playbook principal que orquesta los roles
├── inventories/
│   └── vagrant/
│       └── hosts.ini      # Inventario de hosts para Vagrant (opcional con ansible_local)
├── roles/
│   ├── nginx/             # Rol para instalar Nginx y configurar la página web
│   │   ├── tasks/main.yml
│   │   └── files/
│   │       └── index.html
│   ├── devops/            # Rol para crear el usuario 'devops'
│   │   └── tasks/main.yml
│   └── firewall/          # Rol para configurar el firewall UFW
│       └── tasks/main.yml
```

## ⚙️ Pasos y Componentes

Aquí se detalla el contenido de cada archivo y el propósito de cada rol.

### 1\. **Prerrequisitos:**

Asegúrate de tener instalados los siguientes programas en tu máquina local:

* **Vagrant:** Verifica con `vagrant --version`. Si no lo tienes, puedes instalarlo desde [vagrantup.com](https://www.vagrantup.com/downloads).
* **Ansible:** Verifica con `ansible --version`. Puedes instalarlo vía `pip` (`pip install ansible`) o con el gestor de paquetes de tu sistema operativo.
* **VirtualBox:** Verifica con `virtualbox --version`. Instálalo desde [virtualbox.org](https://www.virtualbox.org/wiki/Downloads) si no lo tienes.

### 2\. **Creación de la Estructura del Proyecto:**

Crea los directorios necesarios en tu máquina local (por ejemplo, en Windows, macOS o Linux):

```bash
mkdir -p ~/desafio_ansible_dia6/inventories/vagrant
mkdir -p ~/desafio_ansible_dia6/roles/nginx/tasks
mkdir -p ~/desafio_ansible_dia6/roles/nginx/files
mkdir -p ~/desafio_ansible_dia6/roles/devops/tasks
mkdir -p ~/desafio_ansible_dia6/roles/firewall/tasks
cd ~/desafio_ansible_dia6
```

### 3\. **`Vagrantfile` (Configuración de la Máquina Virtual):**

Este archivo configura la máquina virtual `ubuntu/jammy64` (Ubuntu 22.04 LTS), establece una IP privada para la comunicación y, crucialmente, utiliza el provisionador **`ansible_local`**. Esto significa que Vagrant instalará Ansible dentro de la propia VM y ejecutará el `playbook.yml` desde allí, lo cual es útil en entornos donde no se tiene un controlador Ansible externo.

```ruby
Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"
    config.vm.network "private_network", ip: "192.168.33.10"

    # Aumenta el tiempo de espera a 10 o 15 minutos (600 o 900 segundos)
    config.vm.boot_timeout = 600

    # Provisionamiento con Ansible LOCAL (se instala en la VM)
    config.vm.provision "ansible", type: "ansible_local" do |ansible|
        ansible.playbook = "playbook.yml"
        # ansible.inventory_path = "inventories/vagrant/hosts.ini" # Se comenta si se usa 'hosts: all' en el playbook con ansible_local
        ansible.verbose = "v" # Muestra una salida detallada de la ejecución de Ansible
    end
end
```

### 4\. **`inventories/vagrant/hosts.ini` (Inventario - Opcional):**

Este archivo define el host al que Ansible se conectará. Sin embargo, como se utiliza **`ansible_local`** con `hosts: all` en el playbook, este inventario no es estrictamente necesario en este escenario, pero se incluye para mantener la estructura profesional solicitada.

```ini
[webservers]
192.168.33.10 ansible_user=vagrant
```

### 5\. **`roles/nginx/tasks/main.yml` (Rol Nginx - Tareas):**

Este rol se encarga de la instalación y configuración básica de Nginx, incluyendo la copia de la página HTML personalizada y asegurándose de que el servicio esté activo y habilitado al inicio.

```yaml
- name: Instalar Nginx
  ansible.builtin.apt:
    name: nginx
    state: present
    update_cache: yes

- name: Copiar página HTML personalizada
  ansible.builtin.copy:
    src: index.html
    dest: /var/www/html/index.html
    mode: '0644'

- name: Asegurar que Nginx esté corriendo y habilitado
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: yes
```

### 6\. **`roles/nginx/files/index.html` (Página Web Personalizada):**

El contenido HTML de la página que Nginx servirá. Incluye logos de Ansible y Nginx para una confirmación visual del despliegue exitoso.

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>¡Bienvenido a tu Proyecto con Nginx y Ansible!</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            color: #333;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            text-align: center;
            flex-direction: column;
            padding: 20px;
            box-sizing: border-box;
        }
        .container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 800px;
            width: 100%;
        }
        h1 {
            color: #2c3e50;
            font-size: 2.5em;
            margin-bottom: 15px;
        }
        p {
            font-size: 1.1em;
            line-height: 1.6;
            margin-bottom: 10px;
        }
        .highlight {
            color: #e74c3c;
            font-weight: bold;
        }
        .footer {
            margin-top: 30px;
            font-size: 0.9em;
            color: #7f8c8d;
        }
        .logo-ansible {
            width: 100px;
            margin-right: 20px;
            vertical-align: middle;
        }
        .logo-nginx {
            width: 80px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" role="img" aria-label="Ansible Logo" class="logo-ansible"><style/><path fill="none" id="canvas_background" d="M-1-1h66v66H-1z"/><path d="M61.9 32.8c0 16.897-13.255 30.6-29.6 30.6S2.7 49.697 2.7 32.8c0-16.897 13.255-30.6 29.6-30.6s29.6 13.703 29.6 30.6" id="svg_23" fill="#c00"/><path d="M47.353 45.11L33.939 12.064c-.385-.957-1.155-1.464-2.09-1.464-.934 0-1.758.507-2.143 1.464L15 48.319h5.03l5.828-14.947 17.399 14.384c.687.59 1.21.844 1.87.844 1.319 0 2.473-1.013 2.473-2.477 0-.225-.082-.591-.247-1.013M31.877 18.003l8.714 22.04-13.167-10.64 4.453-11.4z" id="svg_24" fill="#fff"/></svg>

            ¡Felicidades!
            <img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="Nginx Logo" class="logo-nginx">
        </h1>
        <p>Tu máquina virtual de Vagrant ha desplegado exitosamente este proyecto usando <span class="highlight">Ansible</span>.</p>
        <p>Nginx está sirviendo esta página personalizada, confirmando que la automatización ha funcionado a la perfección.</p>
        <p>¡Ahora puedes empezar a construir tu aplicación!</p>
        <div class="footer">
            <p>&copy; 2025 Tu Proyecto. Desarrollado con ❤️ y Automatización.</p>
        </div>
    </div>
</body>
</html>
```

### 7\. **`roles/devops/tasks/main.yml` (Rol Usuario DevOps):**

Este rol se encarga de crear el usuario `devops`, asignarle acceso `sudo` y, si existe una clave SSH pública en tu sistema local, la copia a la VM para permitir el acceso sin contraseña.

```yaml
- name: Instalar passlib para el manejo de contraseñas de Ansible
  ansible.builtin.apt:
    name: python3-passlib
    state: present

- name: Crear usuario 'devops' con acceso sudo
  ansible.builtin.user:
    name: devops
    groups: sudo
    append: yes
    state: present
    shell: /bin/bash
    password: "{{ 'devops_password' | password_hash('sha512') }}" # ¡IMPORTANTE: Cambia esta contraseña por una segura en un entorno real!

- name: Copiar clave SSH pública para 'devops'
  ansible.posix.authorized_key:
    user: devops
    state: present
    key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
  when: lookup('file', '~/.ssh/id_rsa.pub', errors='ignore') # Esta tarea se ejecuta solo si el archivo de clave SSH existe
```

### 8\. **`roles/firewall/tasks/main.yml` (Rol Firewall UFW):**

Este rol configura el firewall `UFW` (Uncomplicated Firewall) para asegurar que solo los puertos necesarios estén abiertos, mejorando la seguridad del servidor.

```yaml
- name: Asegurar que UFW esté activo
  ansible.builtin.ufw:
    state: enabled
    policy: deny # Establece la política por defecto a denegar todo el tráfico entrante

- name: Permitir acceso SSH (puerto 22)
  ansible.builtin.ufw:
    rule: allow
    port: '22'
    proto: tcp

- name: Permitir acceso HTTP (puerto 80)
  ansible.builtin.ufw:
    rule: allow
    port: '80'
    proto: tcp

- name: Permitir acceso HTTPS (puerto 443)
  ansible.builtin.ufw:
    rule: allow
    port: '443'
    proto: tcp
```

### 9\. **`playbook.yml` (Playbook Principal):**

Este es el playbook principal que orquesta la ejecución de los diferentes roles en la máquina virtual. Apunta a `hosts: all` para que se ejecute en el host provisionado por Vagrant.

```yaml
---
- name: Desafío Dia 6 - Despliegue de Servidor Web con Roles y Vagrant
  hosts: all # Usa 'all' porque estamos provisionando localmente con Vagrant
  become: yes # Ejecutar con privilegios de sudo en la VM

  roles:
    - devops   # Primero crear el usuario devops
    - nginx    # Luego instalar y configurar Nginx
    - firewall # Finalmente configurar el firewall
```

## ✅ Ejecución y Verificación

### **Ejecución del Proyecto:**

Desde el directorio `~/desafio_ansible_dia6/` en tu máquina local:

```bash
vagrant up
```

##

* **Anécdota:** "¡Cruza los dedos\! Porque yo tuve que armar, romper, volver a armar y volver a romper, hasta que funcione. Pero como esto ya está pulido, a ti te funcionará (aunque con tu experiencia, ¡ya sabes qué hacer si algo falla\!)." Esta es una realidad común en DevOps, la perseverancia es clave.

### **Verificación de Resultados:**

1. **Acceso a la Página Web:** Una vez que `vagrant up` haya finalizado, abre tu navegador web en tu máquina local y navega a `http://192.168.33.10`. Deberías ver la página Nginx personalizada que definiste en `index.html`.

   * **Captura de pantalla**
![Desadio del Día 6](/assets/day-06/desafio_day6.png "Desafio del Día 6")

2. **Conexión SSH con el Nuevo Usuario:** Intenta conectarte a la máquina virtual utilizando el usuario `devops` que creaste con Ansible:

    ```bash
    vagrant ssh devops
    # O, si tienes problemas con la integración de Vagrant SSH:
    # ssh devops@192.168.33.10
    ```

    Se te pedirá la contraseña que configuraste para el usuario `devops` (`devops_password`).
