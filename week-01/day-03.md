# Día 03 - Vagrant: Automatización con Shell

📅 **Fecha:** 09/06/2025

## ✅ Tema del Día

Hoy me sumergí en el mundo de **Vagrant**, una herramienta fundamental en DevOps que me permite crear y gestionar entornos de desarrollo virtuales de forma automatizada y reproducible. Aprendí la importancia de estandarizar los entornos para que "funcione en mi máquina" se convierta en "funciona en cualquier máquina".

## 🧠 Lo que aprendí

Mis principales aprendizajes fueron:

* **Fundamentos de Vagrant:** Comprendí qué es Vagrant, cómo se integra con proveedores de virtualización como VirtualBox, y por qué es crucial para eliminar los problemas de "depende de mi máquina" en los equipos de desarrollo.
* **Instalación y Configuración:**
  * Monté una máquina virtual de **Ubuntu 24.04** en **VirtualBox**, luego instalé las **Guest Additions** de VirtualBox para una mejor integración en copiar y pegar dentro de la VirtualBox y mi Entorno Físico.
  * Instalé **VirtualBox** y **Vagrant** en mi sistema anfitrión (Linux y Windows), siguiendo las guías oficiales para asegurar una configuración correcta. Un detalle crucial fue **reiniciar el sistema** tras las instalaciones para que los cambios surtieran efecto, lo que me evitó varios dolores de cabeza.
* **Ciclo de Vida de una VM con Vagrant:** Dominé los comandos esenciales para trabajar con Vagrant, que incluyen:
  * `vagrant init`: Para crear un nuevo `Vagrantfile`.
  * `vagrant up`: Para levantar la VM y ejecutar el provisionamiento.
  * `vagrant ssh`: Para conectarme fácilmente a la VM sin configurar SSH manualmente.
  * `vagrant halt`: Para apagar la VM de forma segura.
  * `vagrant destroy`: Para eliminar completamente la VM y liberar recursos.
* **Provisionamiento con Shell:** Aprendí a automatizar la configuración inicial de una VM utilizando scripts de shell. Esto es poderoso porque permite instalar software, configurar servicios y desplegar aplicaciones automáticamente cada vez que se levanta una VM.
* **Buenas Prácticas:** La importancia de usar **IPs privadas** para acceder a servicios dentro de la VM desde el navegador del host, y la conveniencia de **separar los scripts de provisionamiento** en directorios dedicados (`scripts/`) para mantener el `Vagrantfile` limpio y modular.

## ⚙️ Ejercicios Prácticos Realizados

Para consolidar el aprendizaje, realicé dos proyectos prácticos que demuestran la utilidad de Vagrant:

### 📁 Estructura General del Día 03

```txt
day-03/
├── mi-proyecto/              # Proyecto con nginx + HTML personalizado
└── primer-vagrantfile/       # Proyecto básico con echo + nginx
```

### ✅ Ejercicio 1: Mi Primer `Vagrantfile`

Este ejercicio me permitió familiarizarme con la sintaxis básica del `Vagrantfile` y el concepto de provisionamiento `inline`.

* *Ruta al proyecto:* [`primer-vagrantfile`](/week-01/day-03/primer-vagrantfile/)

```ruby
Vagrant.configure("2") do |config|
  # Utiliza la imagen oficial de Ubuntu 22.04 (Jammy Jellyfish)
  config.vm.box = "ubuntu/jammy64"

  # Configura una red privada para acceder a la VM vía IP
  config.vm.network "private_network", ip: "192.168.33.10"

  # Provisionamiento directo con comandos de shell
  config.vm.provision "shell", inline: <<-SHELL
    echo "¡Hola desde el provisionamiento de Vagrant!" > /tmp/hola.txt
    sudo apt update -y && sudo apt install -y nginx
    sudo systemctl start nginx
  SHELL
end
```

**Resultados clave:**

* Al ejecutar `vagrant up`, la VM se levantó, se creó el archivo `/tmp/hola.txt`, y el servidor Nginx se instaló y se inició automáticamente.

* Pude conectarme a la VM usando `vagrant ssh` y verificar ambos resultados (`cat /tmp/hola.txt` y `systemctl status nginx`).

* *Captura de terminal:
![Primer Vagrantfile](/assets/day-03/terminal_ssh_vagrant.png "Primer Vagranfile")*

### ✅ Ejercicio 2: Servidor Web Nginx Personalizado

Este fue el reto principal, donde apliqué los conocimientos de modularización y personalización.

* *Ruta al proyecto:* [`mi-proyecto`](/week-01/day-03/mi-proyecto/)

```ruby
# mi_proyecto/Vagrantfile
Vagrant.configure("2") do |config|
  # VM base: Ubuntu 22.04 LTS (Noble Numbat)
  config.vm.box = "ubuntu/jammy64"

  # Asigna una IP privada diferente para evitar conflictos y probar la accesibilidad
  config.vm.network "private_network", ip: "192.168.33.20"

  # Provisionamiento utilizando un script de shell externo para mayor organización
  config.vm.provision "shell", path: "scripts/instalar_nginx.sh"
end
```

**Contenido de [`scripts/instalar_nginx.sh`](/week-01/day-03/mi-proyecto/scripts/instalar_nginx.sh):**
Este script no solo instaló Nginx, sino que también incluyó la instalación de `git` (como paquete adicional) y personalizó la página `index.html` con mi nombre y la fecha de despliegue, todo de forma automatizada.

**Resultados clave:**

* Después de `vagrant up`, pude acceder al servidor Nginx abriendo mi navegador y navegando a `http://192.168.33.20`.

* La página `index.html` mostraba mi nombre y la fecha de despliegue, confirmando que el provisionamiento personalizado funcionó a la perfección.

* *Captura de la terminal y navegador:
![Mi proyecto](/assets/day-03/mi_proyecto_vagrant.png "Mi proyecto")*

## 💭 Reflexiones y lecciones clave para otros

Este día fue un claro ejemplo de la importancia de la **persistencia** en DevOps. Me encontré con errores iniciales durante la instalación de VirtualBox y Vagrant que, aunque frustrantes, se resolvieron con algo tan simple como **reiniciar el sistema**. Esto subraya una lección valiosa: **a veces, la solución más compleja no es la correcta, y una simple reinicio puede limpiar el camino.**

La automatización con Vagrant me pareció increíblemente potente. En cuestión de minutos, pude pasar de cero a tener un entorno de desarrollo funcional y con un servidor web listo, algo que manualmente llevaría mucho más tiempo y sería propenso a errores. Esto me enseñó el verdadero valor de invertir tiempo en automatización: **ahorra innumerables horas y dolores de cabeza a largo plazo, además de garantizar la consistencia en cualquier entorno.**

Finalmente, la capacidad de configurar una IP privada y acceder a la VM desde mi navegador es un paso crucial para simular entornos de producción y probar aplicaciones web de manera eficiente.

## 📎 Recursos Utilizados

* 🧠 [Artículo del reto Día 3](https://90daysdevops.295devops.com/semana-01/dia3/#%EF%B8%8F-tu-primer-vagrantfile)
* 🌐 [Descargar Ubuntu](https://ubuntu.com/download/desktop)
* 🎥 [Instalación Ubuntu en VirtualBox (YouTube)](https://youtu.be/58UgwGzUeq8?si=PcbGjHTXf1ol-EF9)
* 🎥 [Habilitar copiar y pegar en VirtualBox (YouTube)](https://youtu.be/-Xf5slaCZNs?si=nb4D6VyCFqCckgB-)
* 📄 [Documentación oficial de Vagrant](https://developer.hashicorp.com/vagrant/docs)

-----
