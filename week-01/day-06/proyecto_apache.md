# Proyecto Ansible: Despliegue y Gestión de Servidor Apache con Monitorización

Este proyecto amplía las capacidades de Ansible, automatizando el despliegue de un servidor Apache con soporte PHP, incluyendo una página dinámica y herramientas de monitoreo. También se introduce el uso de `handlers` para reiniciar servicios de manera controlada.

## 📁 Estructura del Directorio

```txt
~/freelancer_deploy/
├── inventories/
│   └── dev/
│       └── hosts.ini
├── playbooks/
│   └── deploy_apache_app.yml
├── roles/
│   ├── apache/
│   │   ├── tasks/main.yml
│   │   └── handlers/main.yml
│   ├── web_content/
│   │   ├── tasks/main.yml
│   │   └── files/
│   │       └── index.php
│   ├── monitoring/
│   │   └── tasks/main.yml
│   └── maintenance/
│       └── tasks/main.yml
└── ansible.cfg
```

## ⚙️ Pasos y Componentes

Aquí se detalla el contenido de cada archivo y el propósito de cada rol.

### 1\. **Creación de la Estructura de Directorios:**

```bash
mkdir -p ~/freelancer_deploy
cd ~/freelancer_deploy
mkdir -p inventories/dev
mkdir -p playbooks
mkdir -p roles/apache/tasks roles/apache/handlers
mkdir -p roles/web_content/tasks roles/web_content/files
mkdir -p roles/monitoring/tasks
mkdir -p roles/maintenance/tasks
```

### 2\. **`inventories/dev/hosts.ini` (Inventario):**

Define el grupo `webservers` con la IP del nodo cliente y el usuario `admin`.

```ini
[webservers]
192.168.56.11 ansible_user=admin
```

### 3\. **`ansible.cfg` (Configuración de Ansible):**

Similar al proyecto Nginx, pero ubicado en el nuevo directorio `freelancer_deploy`.

```ini
[defaults]
inventory = ./inventories/dev/hosts.ini
remote_user = admin
ask_pass = False
host_key_checking = False
roles_path = ./roles
```

### 4\. **`roles/apache/tasks/main.yml` (Rol Apache - Tareas):**

Instala Apache y PHP, y asegura que Apache esté corriendo y habilitado. Utiliza `notify` para llamar a un handler si el servicio es modificado.

```yaml
- name: Actualizar caché de apt
  ansible.builtin.apt:
    update_cache: yes

- name: Instalar Apache y PHP
  ansible.builtin.apt:
    name: ["apache2", "libapache2-mod-php", "php"]
    state: present

- name: Asegurar que Apache2 esté corriendo y habilitado
  ansible.builtin.service:
    name: apache2
    state: started
    enabled: yes
  notify: Restart Apache2
```

### 5\. **`roles/apache/handlers/main.yml` (Rol Apache - Handlers):**

Define el handler `Restart Apache2` que será notificado por las tareas para reiniciar el servicio solo cuando sea necesario.

```yaml
- name: Restart Apache2
  ansible.builtin.service:
    name: apache2
    state: restarted
```

### 6\. **`roles/web_content/files/index.php` (Página Web Dinámica):**

Una página PHP simple para mostrar la fecha y hora actual del servidor.

```php
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Servidor Apache con PHP</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; background-color: #e6f7ff; }
        .container { background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); display: inline-block; }
        h1 { color: #0056b3; }
        p { color: #333; }
        strong { color: #007bff; }
    </style>
</head>
<body>
    <div class="container">
        <h1>¡Bienvenido a tu Servidor Apache!</h1>
        <p>Esta página fue desplegada por Ansible.</p>
        <p>La fecha y hora actual del servidor es: <strong><?php echo date('Y-m-d H:i:s'); ?></strong></p>
        <p>¡Todo funcionando con éxito!</p>
    </div>
</body>
</html>
```

### 7\. **`roles/web_content/tasks/main.yml` (Rol Contenido Web):**

Copia la página PHP y elimina el archivo `index.html` por defecto de Apache.

```yaml
- name: Copiar archivo index.php al directorio web de Apache
  ansible.builtin.copy:
    src: index.php
    dest: /var/www/html/index.php
    owner: www-data
    group: www-data
    mode: '0644'

- name: Borrar archivo index.html por defecto de Apache (si existe)
  ansible.builtin.file:
    path: /var/www/html/index.html
    state: absent
  ignore_errors: yes
```

### 8\. **`roles/monitoring/tasks/main.yml` (Rol Monitoreo):**

Instala herramientas de monitoreo útiles como `htop` y `glances`.

```yaml
- name: Instalar herramienta de monitorización (htop y glances)
  ansible.builtin.apt:
    name: ["htop", "glances"]
    state: present
```

### 9\. **`roles/maintenance/tasks/main.yml` (Rol Mantenimiento):**

Configura un cron job simple que registra un mensaje en un archivo de log cada minuto, demostrando la automatización de tareas programadas.

```yaml
- name: Añadir un cron job para una tarea de mantenimiento
  ansible.builtin.cron:
    name: "Registro de actividad de Ansible"
    minute: "*"
    job: "echo 'Ansible: Tarea de mantenimiento ejecutada en $(date)' >> /var/log/ansible_maintenance.log"
    user: root
    state: present
```

### 10\. **`playbooks/deploy_apache_app.yml` (Playbook Principal):**

Orquesta la ejecución de todos los roles para el despliegue de Apache.

```yaml
---
- name: Despliegue y Configuracion de Servidor Web Apache
  hosts: webservers
  become: yes

  roles:
    - apache
    - web_content
    - monitoring
    - maintenance
```

## ✅ Ejecución y Verificación

### **Ejecución del Playbook:**

1. **Detener Nginx (si está activo):** Si el proyecto Nginx ya estaba desplegado en el nodo cliente, es recomendable detenerlo para evitar conflictos de puerto 80.

    ```bash
    ansible webservers -m service -a "name=nginx state=stopped enabled=no" --become
    ```

2. **Ejecutar el Playbook Apache:**
    Desde el directorio `~/freelancer_deploy/`:

    ```bash
    ansible-playbook playbooks/deploy_apache_app.yml
    ```

### **Verificación de Resultados:**

1. **Verificar la página web:** Abre tu navegador en tu nodo Cliente y navega a `http://192.168.56.11/index.php`. Deberías ver la página de Apache con la fecha y hora actual, confirmando el despliegue de PHP

   * **Captura de pantalla**
![Apache básica](/assets/day-06/apache_basico.png "Apache básico")

2. **Verificar las herramientas de monitorización (conectando vía SSH al Nodo Cliente):**

    ```bash
    ssh admin@192.168.56.11
    ```

    Una vez dentro del cliente:
      * Ejecuta `htop`
      * Ejecuta `glances`
        Ambos comandos deberían funcionar, mostrando que las herramientas fueron instaladas.
3. **Verificar el cron job:** Espera 1-2 minutos. Verifica el contenido del archivo de log en el nodo cliente:

    ```bash
    sudo cat /var/log/ansible_maintenance.log
    ```

    Deberías ver líneas de log con la fecha y hora de ejecución, confirmando que la tarea de mantenimiento programada está funcionando.
