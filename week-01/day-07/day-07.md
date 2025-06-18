# Día 7 - Desafío Final Semana 1: Despliegue de Roxs Voting App

📅 Fecha: 17/06/2025

## ✅ Tema del día

El desafío final de la Semana 1 nos llevó a consolidar todo lo aprendido sobre **Linux, Vagrant y Ansible** a través del despliegue de una **aplicación distribuida real: la Roxs Voting App**. Esta aplicación de votación, compuesta por múltiples servicios interconectados, nos permitió aplicar conceptos de infraestructura como código para automatizar su puesta en marcha y validar el flujo de datos en un entorno local.

* 🔗 [Repositorio del Proyecto Roxs Voting App - Mi solución](https://github.com/moises-cisneros/roxs-devops-project90)

## 🎯 Arquitectura del Sistema

La Roxs Voting App se compone de los siguientes servicios, cada uno ejecutándose en la misma máquina virtual y comunicándose de la siguiente manera:

```mermaid
graph LR
    A[Vote - Flask] -->|votos| B[Redis]
    B --> C[Worker - Node.js]
    C -->|procesa| D[PostgreSQL]
    D -->|lee| E[Result - Node.js]
    E -->|muestra| F[Frontend - Socket.io]
```

* **Vote (Flask):** Frontend de votación, expuesto en el puerto 80 (mapeado a 8080 en el host para evitar conflictos). Se conecta a Redis para almacenar votos.
* **Redis:** Base de datos en memoria utilizada como broker de mensajes para almacenar los votos temporalmente (puerto 6379).
* **Worker (Node.js):** Proceso en segundo plano que consume votos de Redis y los persiste en PostgreSQL. Su servidor de métricas fue configurado en el puerto 3001 para evitar conflictos.
* **PostgreSQL:** Base de datos relacional persistente donde se almacenan los resultados finales de las votaciones (puerto 5432).
* **Result (Node.js):** Frontend de resultados en tiempo real, expuesto en el puerto 3000. Lee los datos de PostgreSQL y los muestra a los usuarios.

## 🧠 Lo que aprendí

Este desafío fue una inmersión profunda en la orquestación de servicios y la resolución de problemas en un entorno de desarrollo.

### 1\. Gestión de Infraestructura con Vagrant

* **Configuración de Red y Puertos:** Aprendí a mapear múltiples puertos (80, 3000, 3001) desde la máquina virtual (guest) a mi máquina local (host) en el `Vagrantfile`, permitiendo el acceso a las aplicaciones desde el navegador.
* **Gestión de Recursos de VM:** Configuré los recursos de la VM (2GB de RAM, 2 CPUs) para asegurar un rendimiento adecuado durante el despliegue de los diversos servicios.
* **Integración con Ansible Local (`ansible_local`):** Reforcé el uso de `ansible_local` para ejecutar playbooks directamente dentro de la VM, lo que simplifica el flujo de trabajo en entornos de desarrollo.

### 2\. Automatización con Ansible

* **Diseño de Roles Modulares:** Utilicé roles para organizar las tareas de manera lógica (`common`, `redis`, `postgresql`, `nodejs`, `python`, `app_deploy`), facilitando la legibilidad y mantenimiento del playbook.
* **Manejo de Dependencias de Software:** Automatizé la instalación de Node.js (v20+), Python (3.13+), Redis y PostgreSQL, incluyendo sus respectivos gestores de paquetes y dependencias específicas como `psycopg2` para Python y PostgreSQL.
* **Manejo de Colecciones de Ansible:** Comprendí la importancia de instalar colecciones de Ansible (ej. `community.postgresql`) dentro de la VM cuando se usa `ansible_local`, y cómo `ansible-galaxy collection install` es el comando adecuado para ello, no `pip install`.
* **Gestión de Rutas y Archivos Compartidos:** Aprendí a manejar correctamente las rutas de archivos al usar `ansible.builtin.copy` con directorios compartidos de Vagrant (`/vagrant`), utilizando `remote_src: yes` y especificando la ruta exacta dentro de la VM (ej. `/vagrant/roxs-voting-app/{{ item }}`).

### 3\. Gestión y Configuración de Servicios

* **Configuración de Bases de Datos:** Aprendí a configurar usuarios y bases de datos en PostgreSQL programáticamente a través de comandos `psql` ejecutados con `sudo -u postgres`.
* **Despliegue de Aplicaciones:** Entendí el proceso de preparar directorios y ejecutar comandos para instalar dependencias de aplicaciones Python (con `pip` y entornos virtuales) y Node.js (con `npm`).
* **Variables de Entorno para Aplicaciones:** Modifiqué directamente los archivos de la aplicación (`main.js`, `app.py`) dentro de la VM para cambiar las variables de entorno (`REDIS_HOST`, `PGHOST`) de nombres abstractos (ej. `database`, `redis`) a `localhost`, adecuándose a un entorno de una sola VM.
* **Resolución de Conflictos de Puertos:** Detecté y solucioné un conflicto donde dos servicios (`worker` y `result`) intentaban usar el mismo puerto (3000), reconfigurando el puerto del servidor de métricas del `worker` a 3001.

## ⚙️ Soluciones Implementadas

### 1\. Configuración de Vagrant para Mapeo de Puertos y Recursos

```ruby
Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"
    config.vm.network "private_network", ip: "192.168.33.10"
    config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true # Vote app
    config.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true # Result app
    config.vm.network "forwarded_port", guest: 3001, host: 3001, auto_correct: true # Worker metrics
    
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
    end

    config.vm.provision "ansible_local" do |ansible|
        ansible.install = true
        ansible.install_mode = "pip"
        ansible.playbook = "playbook.yml"
        ansible.verbose = "v"
    end
end
```

### 2\. Estructura de Roles de Ansible y Playbook Principal

La organización modular se mantuvo con roles para cada componente:

```text
roxs-devops-project90/
├── Vagrantfile
├── playbook.yml
└── roles/
    ├── common/
    ├── redis/
    ├── postgresql/
    ├── nodejs/
    ├── python/
    └── app_deploy/
```

`playbook.yml`:

```yaml
---
- name: Despliegue de Roxs Voting App
  hosts: all
  become: yes

  roles:
    - common
    - redis
    - postgresql
    - nodejs
    - python
    - app_deploy
```

### 3\. Tareas Clave de Aprovisionamiento (Ejemplos)

* **Instalación de `community.postgresql` y `psycopg2`:**

    ```yaml
    # roles/postgresql/tasks/main.yml
    - name: Instalar la colección community.postgresql
      ansible.builtin.command: ansible-galaxy collection install community.postgresql
      args:
        creates: "/home/vagrant/.ansible/collections/ansible_collections/community/postgresql"
    - name: Instalar la librería Python 'psycopg2' para PostgreSQL
      ansible.builtin.apt:
        name: python3-psycopg2
        state: present
    ```

* **Creación de Usuario y BD de PostgreSQL (Solución `fe_sendauth: no password supplied` y `chmod`):**

    ```yaml
    # roles/postgresql/tasks/main.yml
    - name: Crear base de datos 'votes'
    ansible.builtin.shell: |
        sudo -u postgres psql -c "CREATE DATABASE votes;"
    args:
        executable: /bin/bash
    register: create_db_result
    failed_when: "'already exists' not in create_db_result.stderr and create_db_result.rc != 0"
    changed_when: "'CREATE DATABASE' in create_db_result.stdout"

    - name: Asegurar que el usuario postgres tiene la contraseña correcta
    ansible.builtin.shell: |
        sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"
    ```

* **Copia de Archivos de Aplicación (Solución `Source /vagrant/vote/ not found` y `requirements.txt`):**

    ```yaml
    # roles/app_deploy/tasks/main.yml
    - name: Copiar archivos de la aplicación (vote, worker, result)
    ansible.builtin.copy:
        src: "/vagrant/roxs-voting-app/{{ item }}"
        dest: "/opt/roxs_voting_app/{{ item }}"
        mode: '0755'
        remote_src: yes
    loop:
        - vote/
        - worker/
        - result/

    - name: Instalar dependencias de Python (vote app)
    ansible.builtin.pip:
        requirements: /opt/roxs_voting_app/vote/requirements.txt
        virtualenv: /opt/roxs_voting_app/vote/.venv
        virtualenv_command: python3 -m venv
    ```

### 4\. Script de Inicio Automatizado (Bonus)

Para simplificar el inicio de la aplicación, se creó un script `iniciar_app.sh` que se ejecuta directamente en la VM:

```bash
#!/bin/bash

# Directorios y archivos
APP_DIR="/opt/roxs_voting_app"
PROMETHEUS_DIR="/tmp/prometheus-multiproc"
PID_DIR="/tmp/roxs-voting"

# Crear directorios necesarios
mkdir -p $PROMETHEUS_DIR $PID_DIR

# Función para verificar si un puerto está en uso
check_port() {
    nc -z localhost $1 2>/dev/null
    return $?
}

# Función para matar procesos usando un puerto específico
kill_port() {
    sudo lsof -t -i:$1 | xargs -r sudo kill -9
}

# Función para esperar que un servicio esté disponible
wait_for_service() {
    local port=$1
    local service=$2
    local max_attempts=30
    local attempt=1

    echo "Esperando que $service esté disponible en el puerto $port..."
    while ! nc -z localhost $port; do
        if [ $attempt -ge $max_attempts ]; then
            echo "$service no respondió después de $max_attempts intentos"
            return 1
        fi
        attempt=$((attempt+1))
        sleep 1
    done
    echo "$service está disponible"
    return 0
}

# Función para limpiar procesos anteriores
cleanup() {
    echo "Limpiando procesos anteriores..."
    if [ -f $PID_DIR/worker.pid ]; then
        kill -9 $(cat $PID_DIR/worker.pid) 2>/dev/null || true
    fi
    if [ -f $PID_DIR/result.pid ]; then
        kill -9 $(cat $PID_DIR/result.pid) 2>/dev/null || true
    fi
    if [ -f $PID_DIR/vote.pid ]; then
        kill -9 $(cat $PID_DIR/vote.pid) 2>/dev/null || true
    fi
    rm -f $PID_DIR/*.pid
    sudo pkill -f "python3 -m flask"
    sudo pkill -f "node main.js"
    kill_port 80
    kill_port 3000
}

# Configurar hosts
echo "Configurando /etc/hosts..."
if ! grep -q "redis" /etc/hosts; then
    echo "127.0.0.1 redis" | sudo tee -a /etc/hosts
fi
if ! grep -q "database" /etc/hosts; then
    echo "127.0.0.1 database" | sudo tee -a /etc/hosts
fi

# Manejar señales para limpieza
trap cleanup EXIT

# Limpiar procesos anteriores
cleanup

# Asegurar que los servicios base estén corriendo
echo "Iniciando servicios base..."
sudo service postgresql restart
sudo service redis-server restart

# Esperar que PostgreSQL y Redis estén disponibles
wait_for_service 5432 "PostgreSQL"
wait_for_service 6379 "Redis"

# Exportar variables de entorno
export PROMETHEUS_MULTIPROC_DIR=$PROMETHEUS_DIR

# Instalar nginx si no está instalado
if ! command -v nginx &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y nginx
fi

# Configurar nginx
sudo cp /vagrant/roles/app_deploy/files/nginx.conf /etc/nginx/conf.d/vote.conf
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

# Iniciar Result (puerto 3000)
echo "Iniciando Result..."
cd $APP_DIR/result || exit
npm install --silent
npm start > $APP_DIR/logs/result.log 2>&1 &
echo $! > $PID_DIR/result.pid
wait_for_service 3000 "Result"
sleep 5

# Iniciar Worker (puerto 3001)
echo "Iniciando Worker..."
cd $APP_DIR/worker || exit
npm install --silent
WORKER_PORT=3001 npm start > $APP_DIR/logs/worker.log 2>&1 &
echo $! > $PID_DIR/worker.pid
wait_for_service 3001 "Worker metrics"
sleep 5

# Iniciar Vote (puerto 8080)
echo "Iniciando Vote..."
cd $APP_DIR/vote || exit
source .venv/bin/activate

# Instalar dependencias en el entorno virtual
echo "Instalando dependencias de Python..."
pip install --upgrade pip --quiet
pip install flask redis prometheus_client prometheus_flask_exporter python-dotenv --quiet

echo "Iniciando servicio Vote..."
export FLASK_APP=app.py
export FLASK_ENV=development
export FLASK_DEBUG=1
export FLASK_RUN_HOST=0.0.0.0
export FLASK_RUN_PORT=8080
python3 -m flask run --host=0.0.0.0 --port=8080 > $APP_DIR/logs/vote.log 2>&1 &
echo $! > $PID_DIR/vote.pid
wait_for_service 8080 "Vote"

echo "✅ Todos los servicios han sido iniciados"
echo "📊 Vote app: http://localhost"
echo "📈 Result app: http://localhost:3000"
echo "🔍 Logs disponibles en $APP_DIR/logs/"

# Monitorear logs
tail -f $APP_DIR/logs/*.log
```

### 5\.  Capturas de Pantalla

Para completar la documentación, debes tomar las siguientes capturas de pantalla:

1. **Interfaz de Votación**
      * Accede a `http://localhost`
      * Captura la pantalla mostrando las opciones de voto (Cats vs Dogs)
2. **Página de Resultados**
      * Accede a `http://localhost:3000`
      * Captura la pantalla mostrando los resultados en tiempo real

## 💭 Reflexiones y Lecciones Clave

Este desafío fue una verdadera prueba de fuego, repleta de **errores de depuración** que, lejos de ser frustrantes, se convirtieron en las lecciones más valiosas. Cada "FAILED\!" en Ansible nos obligó a profundizar en el problema y entender los mecanismos internos.

### Desafíos Específicos Superados

1. **"chmod: invalid mode" con `become_user`:** Este fue un obstáculo recurrente al intentar ejecutar tareas como el usuario `postgres`. La solución implicó probar diferentes enfoques, desde configurar `ansible_become_tmpdir` hasta, finalmente, recurrir a la ejecución directa de comandos `sudo -u postgres psql` a través del módulo `shell`. Esta experiencia destacó la importancia de conocer las alternativas cuando las abstracciones de Ansible no funcionan como se espera.
2. **"fe\_sendauth: no password supplied" y "could not translate host name 'database'":** Estos errores de conexión a PostgreSQL y Redis resaltaron la necesidad de verificar las configuraciones de la aplicación (los archivos `main.js` y `app.py`). La solución fue cambiar los nombres de host "database" y "redis" a `localhost` o `127.0.0.1`, ya que todos los servicios residen en la misma VM, y asegurar que los módulos de Ansible se conectaran correctamente a la base de datos (con `psycopg2` instalado).
3. **Conflictos de Puertos (`EADDRINUSE`):** La detección de que el servicio `worker` también intentaba usar el puerto 3000 (reservado para `result`) fue crucial. La depuración de logs reveló que `worker` tenía un "metrics server" allí. La solución fue modificar el código del `worker` para usar un puerto alternativo (3001).
4. **Problemas de Rutas de Archivos en `ansible.builtin.copy`:** La confusión inicial sobre la ruta `src` al copiar los directorios de la aplicación desde el directorio compartido de Vagrant (`/vagrant`) a `/opt/roxs_voting_app/` fue un punto de fricción. Aprender a verificar la estructura exacta del directorio compartido (`ls /vagrant/`) y entender cómo `remote_src: yes` interactúa con `src: "/vagrant/roxs-voting-app/{{ item }}"` fue fundamental. Similarmente, corregir la ruta para `requirements.txt` a `/opt/roxs_voting_app/requirements.txt` (después de ver cómo se copiaban los archivos) fue clave.

### Mejores Prácticas Reforzadas

* **Lectura Detallada de Mensajes de Error:** Cada línea de un error fatal de Ansible o un log de aplicación contiene información valiosa que guía la depuración.
* **Verificación Manual en la VM:** El uso de `vagrant ssh` para inspeccionar directorios (`ls -la`), archivos (`cat`), y procesos (`ps aux`) fue indispensable para entender el estado real de la VM.
* **Idempotencia:** Asegurar que las tareas de Ansible sean idempotentes (ej. con `creates` o `failed_when`/`changed_when`) es crucial para poder ejecutar `vagrant provision` repetidamente sin causar problemas.
* **Manejo de Contextos (`ansible_local` vs. remoto):** Comprender dónde se ejecuta Ansible y cómo eso afecta la resolución de rutas de archivos y la instalación de colecciones/dependencias de Python.

## 🎯 Resultados Alcanzados

Con la persistencia y el análisis de cada error, el objetivo final fue alcanzado:

1. ✅ **Automatización Completa del Despliegue:** Se logró automatizar la configuración de la VM, la instalación de todos los componentes de software (Redis, PostgreSQL, Node.js, Python) y el despliegue de los archivos de la Roxs Voting App.
2. ✅ **Aplicación Funcional y Accesible:** La Roxs Voting App se encuentra totalmente operativa en el entorno local, accesible a través de los puertos mapeados (`http://localhost:8080` para la votación y `http://localhost:3000` para los resultados).
3. ✅ **Flujo de Datos Correcto:** Se validó que los votos fluyen correctamente desde el frontend (Flask), pasan por Redis, son procesados por el Worker (Node.js), se persisten en PostgreSQL y finalmente se visualizan en tiempo real en la página de resultados (Node.js).
4. ✅ **Experiencia Práctica sin Contenedores:** Obtuvimos una valiosa experiencia en la orquestación y despliegue de múltiples servicios sin recurrir a tecnologías de contenedores como Docker, entendiendo las complejidades subyacentes de las dependencias y la comunicación entre procesos.

## 📎 Recursos

* 🧠 [Artículo del reto Día 7](https://www.google.com/search?q=https://90daysdevops.295devops.com/semana-1/dia7)
* 🔗 [Repositorio del Proyecto Roxs Voting App](https://github.com/roxsross/roxs-devops-project90)
* 🔗 [Repositorio del Proyecto Roxs Voting App - Mi Solución](https://github.com/moises-cisneros/roxs-devops-project90)
* 📘 [Documentación oficial de Ansible](https://docs.ansible.com/)
* 📘 [Documentación oficial de Vagrant](https://www.vagrantup.com/docs)
* 📘 [Flask Documentation](https://flask.palletsprojects.com/)
* 📘 [Node.js Documentation](https://nodejs.org/docs)
* 📘 [Documentación de PostgreSQL](https://www.postgresql.org/docs/)
* 📘 [Documentación de Redis](https://redis.io/docs/)
