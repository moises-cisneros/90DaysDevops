# Proyecto Ansible: Despliegue de Servidor Nginx Básico

Este proyecto demuestra cómo utilizar Ansible para automatizar el despliegue de un servidor web Nginx con una página HTML personalizada en un nodo gestionado. Se sigue una estructura de roles para mayor modularidad.

## 📁 Estructura del Proyecto

```txt
desafio_ansible_basico/
├── inventories/
│   └── dev/
│       └── hosts.ini
├── playbooks/
│   └── deploy_web_server.yml
├── roles/
│   ├── common/
│   │   └── tasks/main.yml
│   ├── nginx/
│   │   ├── tasks/main.yml
│   │   └── files/
│   │       └── index.html
│   └── firewall/
│       └── tasks/main.yml
└── ansible.cfg
```

## ⚙️ Pasos y Componentes

Aquí se detalla el contenido de cada archivo y el propósito de cada rol.

### 1\. **Creación de la Estructura de Directorios:**

```bash
mkdir -p ~/desafio_ansible_basico/inventories/dev
mkdir -p ~/desafio_ansible_basico/playbooks
mkdir -p ~/desafio_ansible_basico/roles/common/tasks
mkdir -p ~/desafio_ansible_basico/roles/nginx/tasks
mkdir -p ~/desafio_ansible_basico/roles/nginx/files
mkdir -p ~/desafio_ansible_basico/roles/firewall/tasks
cd ~/desafio_ansible_basico
```

### 2\. **`inventories/dev/hosts.ini` (Inventario):**

Define el grupo `webservers` con la IP del nodo cliente y el usuario `admin` para la conexión SSH.

```ini
[webservers]
192.168.56.11 ansible_user=admin
```

### 3\. **`ansible.cfg` (Configuración de Ansible):**

Configura el inventario por defecto y especifica que no se pida contraseña SSH ni se verifique la clave del host (útil en entornos de laboratorio, pero no recomendado en producción).

```ini
[defaults]
inventory = ./inventories/dev/hosts.ini
remote_user = admin
ask_pass = False
host_key_checking = False
roles_path = ./roles
```

### 4\. **`roles/common/tasks/main.yml` (Rol Común):**

Este rol se encarga de crear un usuario general (`devops`) en el servidor, con privilegios de `sudo`.

```yaml
- name: Crear usuario 'devops' con acceso sudo
  user:
    name: devops
    groups: sudo
    append: yes
    state: present
    shell: /bin/bash
    password: "{{ 'devops_password' | password_hash('sha512') }}"
```

### 5\. **`roles/nginx/tasks/main.yml` (Rol Nginx):**

Instala Nginx y copia la página HTML personalizada.

```yaml
- name: Instalar Nginx
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Copiar página HTML personalizada
  copy:
    src: index.html
    dest: /var/www/html/index.html
    mode: '0644'

- name: Asegurar que Nginx esté corriendo y habilitado al inicio
  service:
    name: nginx
    state: started
    enabled: yes
```

### 6\. **`roles/nginx/files/index.html` (Página Web Personalizada):**

El contenido de la página web que Nginx servirá.

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Primera Página Nginx con Ansible</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; background-color: #f0f0f0; }
        h1 { color: #333; }
        p { color: #666; }
        .container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); display: inline-block; }
    </style>
</head>
<body>
    <div class="container">
        <h1>¡Hola DevOps!</h1>
        <p>Esta página fue desplegada automáticamente usando Ansible.</p>
        <p>¡Reto completado con Roxs!</p>
    </div>
</body>
</html>
```

### 7\. **`roles/firewall/tasks/main.yml` (Rol Firewall UFW):**

Configura el firewall UFW para permitir el tráfico necesario (SSH, HTTP, HTTPS).

```yaml
- name: Asegurar que UFW esté activo
  ufw:
    state: enabled
    policy: deny

- name: Permitir acceso SSH (puerto 22)
  ufw:
    rule: allow
    port: '22'
    proto: tcp

- name: Permitir acceso HTTP (puerto 80)
  ufw:
    rule: allow
    port: '80'
    proto: tcp

- name: Permitir acceso HTTPS (puerto 443)
  ufw:
    rule: allow
    port: '443'
    proto: tcp
```

### 8\. **`playbooks/deploy_web_server.yml` (Playbook Principal):**

Este playbook orquesta la ejecución de los roles en el orden deseado.

```yaml
---
- name: Despliegue de servidor web Nginx con configuracion basica
  hosts: webservers # Apunta al grupo 'webservers' de tu inventario
  become: yes       # Ejecutar con privilegios de sudo

  roles:
    - common         # Primero el rol común (crear usuario)
    - nginx          # Luego el rol de Nginx (instalar, copiar página)
    - firewall       # Finalmente el rol de firewall
```

-----

## ✅ Ejecución y Verificación

### **Ejecución del Playbook:**

Desde el directorio `~/desafio_ansible_basico/`:

```bash
ansible-playbook playbooks/deploy_web_server.yml
```

-----

##

### **Verificación de Resultados:**

1. ## **Acceso a la Página Web:** Abre tu navegador en tu nodo Cliente y navega a `http://192.168.56.11`. Deberías ver la página web personalizada desplegada por Ansible

   * **Captura de pantalla**
![Apache básica](/assets/day-06/ngix_basico.png "Nginx básico")

2. **Conexión SSH con Nuevo Usuario:** Desde el Nodo de Control, intenta conectarte vía SSH con el usuario `devops` creado por Ansible.

    ```bash
    ssh devops@192.168.56.11
    ```

    Debería pedirte la contraseña que estableciste en el playbook (`devops_password`).
3. **Verificación de Servicios y Firewall (en Nodo Cliente):**

    ```bash
    sudo systemctl status nginx
    sudo ufw status
    ```

    Ambos deberían mostrar que Nginx está activo y el firewall configurado correctamente.
