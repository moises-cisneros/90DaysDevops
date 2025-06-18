# 📊 Resumen Semanal - Semana 01

## 📅 Fechas

🗓️ Del 10 de junio al 16 de junio  

## 🧠 Temas cubiertos

- [Día 1: DevOps y la Importancia de Linux](/week-01/day-01/day-01.md)
- [Día 2: Comandos, estructura, usuarios y permisos](/week-01/day-02/day-02.md)
- [Día 3: Vagrant: Automatización con Shell](/week-01/day-03/day-03.md)
- [Día 4: Git & GitHub: Bases, Ramificación, Fusión y Pull Requests](/week-01/day-04/day-04.md)
- [Día 5: Automatizando Tareas con Bash Scripting](/week-01/day-05/day-05.md)
- [Día 6: Introducción a Ansible: Automatización de Infraestructura](/week-01/day-06/day-06.md)
- [Día 7: Desafío Final Semana 1: Despliegue de Roxs Voting App](/week-01/day-07/day-07.md)

## 📌 Lo más importante que aprendí

Breve listado de los aprendizajes clave de la semana.

- Comprendí la filosofía DevOps como una sinergia entre desarrollo y operaciones, impulsada por la automatización y la colaboración.
- Dominé los fundamentos de Linux (comandos, permisos, gestión de usuarios y servicios), esenciales como base para DevOps.
- Aprendí a crear y gestionar entornos de desarrollo reproducibles con Vagrant, utilizando provisionamiento con scripts Bash.
- Profundicé en Git y GitHub para el control de versiones y colaboración, incluyendo ramas, fusiones, Pull Requests y comandos avanzados como `git stash` y `git rebase -i`.
- Desarrollé habilidades en Bash scripting para automatizar tareas repetitivas, desde monitoreo de sistema hasta despliegues de aplicaciones.
- Me introduje en Ansible para la automatización de infraestructura sin agentes, creando inventarios y playbooks para configurar múltiples máquinas eficientemente.
- Consolidé todos los conocimientos al desplegar una aplicación distribuida (Roxs Voting App) con Vagrant y Ansible, gestionando servicios y resolviendo conflictos en un entorno virtual.

## 🧪 Prácticas realizadas

- [x] Instalación y configuración de WSL2 y comandos básicos de Linux.
- [x] Despliegue de servidores web (Nginx y Apache) y gestión de servicios con `systemctl`.
- [x] Creación y gestión de máquinas virtuales con Vagrant, incluyendo provisionamiento con scripts Bash para entornos estandarizados.
- [x] Control de versiones con Git (inicialización de repositorios, `add`, `commit`, `branch`, `merge`, `pull`, `push`) y colaboración con GitHub (Pull Requests).
- [x] Desarrollo de diversos scripts Bash para automatización de tareas (monitoreo, backups, gestión de usuarios, despliegues de aplicaciones).
- [x] Configuración de un laboratorio con dos máquinas virtuales (Control y Cliente) para practicar Ansible.
- [x] Uso de comandos ad-hoc y playbooks de Ansible para la automatización de infraestructura, instalación de paquetes y gestión de usuarios.
- [x] Despliegue de la Roxs Voting App, configurando múltiples servicios (Flask, Redis, Node.js, PostgreSQL) en una única VM con Vagrant y Ansible, incluyendo mapeo de puertos y gestión de dependencias.

## 🧠 Retos enfrentados

- **Configuración del Entorno:** La instalación de VirtualBox/Vagrant y la configuración de redes en VMs tomó tiempo y requirió depuración metódica (ej. orden de adaptadores de red, reinicios de sistema).
- **Compatibilidad con Windows:** Adaptar el flujo de trabajo de Ansible a Windows fue un reto, resuelto al usar una VM de Linux como nodo de control y la característica `ansible_local` de Vagrant.
- **Permisos y Dependencias:** Manejo de permisos en Linux (`chmod`, `chown`, `sudo NOPASSWD`) y resolución de dependencias de software (ej. `psycopg2` para PostgreSQL, colecciones de Ansible).
- **Resolución de Conflictos:** Experiencia en resolver conflictos de Git (merge conflicts) y conflictos de puertos en la aplicación distribuida (Roxs Voting App).
- **Dominio de la Terminal:** La certeza de que dominar la terminal (Linux, Git, Bash) es indispensable y te saca de apuros cuando las GUI fallan.
- **Valor de la Automatización:** Comprensión profunda del ahorro de tiempo y la consistencia que ofrece la automatización con herramientas como Vagrant, Bash scripting y Ansible.
- **Persistencia:** La importancia de la persistencia y la depuración metódica ante errores, incluso los más simples.

## 💡 Reflexión final de la semana

Esta primera semana ha sido una inmersión intensiva y muy enriquecedora en los fundamentos de DevOps. Cada día construyó sobre el anterior, consolidando conocimientos esenciales en Linux, control de versiones con Git, automatización con Bash, y gestión de infraestructura con Vagrant y Ansible. El desafío final de desplegar una aplicación distribuida fue la culminación perfecta, donde pude aplicar y ver la interconexión de todas las herramientas aprendidas. Aprendí la importancia de la paciencia en la depuración, la adaptabilidad ante los desafíos del entorno (especialmente con Windows y VMs), y el inmenso valor de la automatización para garantizar consistencia y eficiencia. Me siento mucho más preparado para abordar problemas de infraestructura como código y colaborar eficazmente en un equipo DevOps.

---
