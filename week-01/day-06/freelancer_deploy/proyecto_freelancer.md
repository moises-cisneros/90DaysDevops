# Proyecto Ansible: Despliegue de Plantilla Web Freelancer con Vagrant y Ansible Local

Este proyecto explora el uso combinado de **Vagrant** y **Ansible (en modo `ansible_local`)** para automatizar el despliegue de la plantilla web "StartBootstrap Freelancer" en una máquina virtual recién creada. Es un escenario común para configurar entornos de desarrollo o pruebas de manera reproducible.

## 📁 Estructura del Proyecto

```txt
freelancer-deploy/
├── Vagrantfile            # Configuración de la VM
├── playbook.yml           # Playbook principal de Ansible
└── files/
    └── nginx.conf         # Configuración personalizada de Nginx
```

## ⚙️ Pasos y Componentes

Aquí se detalla el contenido de cada archivo y el propósito de cada componente.

### 1\. **Prerrequisitos:**

Para ejecutar este proyecto, asegúrate de tener instalados en tu máquina local:

* **Vagrant:** `vagrant --version`
* **Ansible:** `ansible --version`
* **VirtualBox:** `virtualbox --version` (el proveedor de virtualización por defecto de Vagrant).

### 2\. **Creación de la Estructura de Directorios:**

```bash
mkdir -p ~/freelancer-deploy/files
cd ~/freelancer-deploy
```

### 3\. **`Vagrantfile` (Configuración de la Máquina Virtual):**

Este archivo define la VM (Ubuntu 22.04), su configuración de red y, lo más importante, cómo **Ansible se provisionará localmente** dentro de esa VM una vez que se inicie. Esto significa que Vagrant instalará Ansible en la VM y luego ejecutará el `playbook.yml` desde allí.

```ruby
Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-22.04"
    config.vm.network "private_network", ip: "192.168.33.10"

    # Aumenta el tiempo de espera para el arranque de la VM
    config.vm.boot_timeout = 600

    # Provisionamiento con Ansible LOCAL (se instala en la VM)
    config.vm.provision "ansible", type: "ansible_local" do |ansible|
        ansible.playbook = "playbook.yml"
        ansible.verbose = "v" # Habilita la salida detallada de Ansible
    end
end
```

### 4\. **`playbook.yml` (Playbook de Ansible):**

Este playbook contiene todas las tareas necesarias para descargar la plantilla de Freelancer, configurar Nginx para servirla y limpiar los archivos temporales. Incluye un `handler` para reiniciar Nginx solo cuando su configuración haya cambiado.

```yaml
---
- name: Despliegue Fullstack Freelancer
  hosts: all
  become: yes # Ejecutar tareas con privilegios de sudo

  vars:
    repo_url: "https://github.com/startbootstrap/startbootstrap-freelancer/archive/gh-pages.zip"
    web_root: "/var/www/freelancer"

  tasks:
    - name: Instalar dependencias (nginx, unzip, wget)
      apt:
        name: ["nginx", "unzip", "wget"]
        state: present
        update_cache: yes

    - name: Crear directorio web para la aplicación
      file:
        path: "{{ web_root }}"
        state: directory
        mode: '0755'

    - name: Descargar template de Freelancer
      get_url:
        url: "{{ repo_url }}"
        dest: "/tmp/freelancer.zip"
        mode: '0644'

    - name: Descomprimir template
      unarchive:
        src: "/tmp/freelancer.zip"
        dest: "/tmp/"
        remote_src: yes # Indicar que el archivo zip está en la máquina remota

    - name: Mover contenido del subdirectorio descomprimido al directorio web
      shell: |
        cd /tmp/startbootstrap-freelancer-gh-pages
        cp -r * "{{ web_root }}/"
        chown -R www-data:www-data "{{ web_root }}" # Asegurar permisos correctos para Nginx

    - name: Limpiar archivos temporales
      file:
        path: "{{ item }}"
        state: absent
      loop:
        - "/tmp/freelancer.zip"
        - "/tmp/startbootstrap-freelancer-gh-pages"

    - name: Configurar Nginx para servir la aplicación Freelancer
      template:
        src: files/nginx.conf # Apunta al archivo local en 'files/'
        dest: /etc/nginx/sites-available/freelancer
      notify: Restart Nginx # Notificar al handler para reiniciar Nginx

    - name: Habilitar el sitio (crear enlace simbólico)
      file:
        src: /etc/nginx/sites-available/freelancer
        dest: /etc/nginx/sites-enabled/freelancer
        state: link

    - name: Eliminar el sitio Nginx por defecto
      file:
        path: /etc/nginx/sites-enabled/default
        state: absent

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```

### 5\. **`files/nginx.conf` (Configuración de Nginx):**

Este es un archivo de configuración básico para Nginx que le indica cómo servir los archivos de la plantilla Freelancer desde el directorio `/var/www/freelancer`.

```nginx
server {
    listen 80;
    server_name _; # Escucha en cualquier nombre de host
    root /var/www/freelancer; # Directorio raíz de los archivos web
    index index.html; # Archivo índice por defecto

    location / {
        try_files $uri $uri/ =404; # Intenta servir el archivo o directorio, si no 404
    }
}
```

## ✅ Ejecución y Verificación

### **Ejecución del Proyecto:**

Desde el directorio `~/freelancer-deploy/` en tu máquina local:

```bash
vagrant up
```

Este comando iniciará la máquina virtual, instalará Ansible dentro de ella y luego ejecutará el playbook para desplegar la aplicación.

* **Anécdota:** La configuración de entornos con Vagrant y Ansible puede ser un poco "rebelde" al principio. Yo mismo pasé **más de 6 horas** configurando, "armando, rompiendo, volviendo a armar y volver a romper" hasta que funcionó. ¡Pero esos momentos son los que más enseñan\! Aunque mi SO es Windows y no puedo ejecutar Ansible directamente en él para gestionar VirtualBox, la opción de `ansible_local` fue la solución perfecta para seguir practicando.

### **Verificación de Resultados:**

1. **Acceso a la Aplicación Web:** Una vez que `vagrant up` haya finalizado exitosamente, abre tu navegador web en tu máquina local y ve a `http://192.168.33.10`. Deberías ver la plantilla de StartBootstrap Freelancer desplegada y funcionando.

   * **Captura de pantalla**
![Proyecto Freelancer](/assets/day-06/ejercicio_ngingx.png "Proyecto Freelancer")

2. **Conexión SSH a la VM:** Puedes conectarte a la máquina virtual para verificar los archivos y servicios.

    ```bash
    vagrant ssh # Te conectará como el usuario 'vagrant' por defecto
    ```

    Una vez dentro, puedes verificar el estado de Nginx: `sudo systemctl status nginx` y el contenido en `/var/www/freelancer`.
