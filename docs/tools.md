# 🛠️ Herramientas de DevOps - Semana 01

Esta sección recopila las herramientas clave utilizadas durante la primera semana del desafío, con una breve descripción y enlaces a sus tutoriales de instalación.

## 🐧 Linux (WSL2)

**Descripción:** Sistema operativo fundamental en DevOps, base para casi todas las herramientas y entornos de servidor. WSL2 (Windows Subsystem for Linux 2) permite ejecutar un entorno Linux completo directamente en Windows.
**Instalación (WSL2 en Windows):**

1. Abrir PowerShell como administrador.
2. Ejecutar: `wsl --install`
3. Reiniciar el sistema si se solicita.
4. Más detalles: [Instalación de Linux en Windows con WSL](https://learn.microsoft.com/es-es/windows/wsl/install)

## 🌐 Nginx

**Descripción:** Servidor web y proxy inverso de alto rendimiento. Utilizado para servir contenido estático y balancear carga.
**Instalación (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

**Más detalles:** [Documentación oficial de Nginx](https://nginx.org/en/docs/)

## 🗃️ Apache HTTP Server

**Descripción:** Servidor web de código abierto, robusto y ampliamente utilizado. Compatible con una gran variedad de módulos.
**Instalación (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
```

**Más detalles:** [Documentación oficial de Apache](https://httpd.apache.org/docs/)

## 📦 VirtualBox

**Descripción:** Software de virtualización que permite crear y ejecutar máquinas virtuales (VMs) en tu sistema operativo actual. Es esencial para crear entornos de laboratorio.
**Instalación:** Descargar desde el sitio oficial. [Descargar VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## ⚙️ Vagrant

**Descripción:** Herramienta para construir y gestionar entornos de desarrollo virtuales en un solo flujo de trabajo. Funciona con VirtualBox (y otros proveedores) para automatizar la creación de VMs.
**Instalación:** Descargar e instalar el paquete correspondiente a tu OS desde el sitio oficial. Requiere VirtualBox preinstalado.
**Más detalles:** [Documentación oficial de Vagrant](https://developer.hashicorp.com/vagrant/docs)

## 🌳 Git

**Descripción:** Sistema de control de versiones distribuido que rastrea cambios en el código fuente durante el desarrollo de software. Fundamental para la colaboración.
**Instalación (Windows):** Descargar e instalar el Git Bash desde [git-scm.com/downloads](https://git-scm.com/downloads).
**Instalación (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install git -y
```

**Más detalles:** [Sitio oficial de Git](https://git-scm.com/docs)

## 🚀 GitHub

**Descripción:** Plataforma de alojamiento de código para control de versiones y colaboración, utilizando Git. Permite la gestión de repositorios, Pull Requests, etc.
**Uso:** Principalmente una plataforma web. Se integra con Git. No requiere una "instalación" de software local más allá de Git.

## 📜 Bash Scripting

**Descripción:** Lenguaje de scripting para la shell de Unix/Linux (Bash). Permite automatizar tareas repetitivas y complejas mediante la escritura de scripts.
**Uso:** Incluido por defecto en la mayoría de las distribuciones Linux y WSL. Se escribe en archivos `.sh`.
**Más detalles:** [Documentación oficial de Bash](https://www.gnu.org/software/bash/manual/bash.html)

## 🤖 Ansible

**Descripción:** Herramienta de automatización de TI sin agente, utilizada para configuración de gestión, despliegue de aplicaciones y orquestación. Usa SSH para comunicarse con los nodos.
**Instalación (en un Control Node Linux/WSL):**

```bash
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

**Más detalles:** [Documentación oficial de Ansible](https://docs.ansible.com/)

## ⚡ Redis

**Descripción:** Almacén de estructura de datos en memoria de código abierto, utilizado como base de datos, caché y bróker de mensajes. Rápido y versátil.
**Instalación (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install redis-server -y
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

## 🐘 PostgreSQL

**Descripción:** Sistema de gestión de bases de datos relacionales de código abierto, robusto y escalable. Utilizado para almacenar datos estructurados.
**Instalación (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib -y
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

## 🟩 Node.js

**Descripción:** Entorno de ejecución de JavaScript de código abierto y multiplataforma. Permite ejecutar código JavaScript en el lado del servidor. Incluye npm (Node Package Manager).
**Instalación (Ejemplo con NVM - recomendado):**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc # O ~/.zshrc
nvm install --lts
nvm use --lts
```

## 🐍 Python

**Descripción:** Lenguaje de programación de alto nivel ampliamente utilizado en DevOps para scripting, automatización y desarrollo web (ej. Flask).
**Instalación (Ubuntu/Debian - Python 3 suele estar preinstalado):**

```bash
sudo apt update
sudo apt install python3 python3-pip -y
```

## 🍶 Flask

**Descripción:** Microframework web ligero para Python. Ideal para construir APIs y aplicaciones web pequeñas y medianas.
**Instalación (dentro de un entorno virtual):**

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install Flask
```

## 🦄 Gunicorn

**Descripción:** Servidor WSGI (Web Server Gateway Interface) para Python. Se utiliza para servir aplicaciones web Python (como Flask) en producción, actuando como intermediario entre el servidor web (Nginx/Apache) y la aplicación.
**Instalación (dentro de un entorno virtual):**

```bash
pip install gunicorn
```
