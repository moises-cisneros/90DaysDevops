# Día 04 - Git & GitHub: Bases, Ramificación, Fusión y Pull Requests

📅 **Fecha:** 10/06/2025

## ✅ Tema del Día

Hoy profundicé en **Git y GitHub**, herramientas esenciales para el control de versiones y la colaboración en el desarrollo de software. Aprendí los conceptos fundamentales de Git, cómo manejar ramas (branching), fusionar cambios (merging), y cómo colaborar eficazmente utilizando Pull Requests (PRs) en plataformas como GitHub. Este conocimiento es la columna vertebral de cualquier flujo de trabajo DevOps moderno.

## 🧠 Lo que aprendí

El día de hoy fue fundamental para entender cómo mantener un historial de cambios, colaborar en equipo y gestionar proyectos de software de manera eficiente.

### Conceptos Clave

* **Control de Versiones (VCS):** Entendí por qué Git es el sistema de control de versiones distribuido (DVCS) más popular y sus ventajas sobre sistemas centralizados (como SVN o Mercurial), permitiendo un trabajo sin conexión y una mayor resiliencia.
* **Elementos de Git:**
  * **Repositorios:** Dónde se almacenan todos los archivos y su historial.
  * **Commits:** Instantáneas de los cambios en un punto específico del tiempo.
  * **Branches (Ramas):** Líneas independientes de desarrollo que permiten trabajar en características sin afectar la línea principal.
  * **Estados de Git:** Comprendí el flujo entre el `Working Directory` (directorio de trabajo), `Staging Area` (área de preparación) y el `Commit History` (historial de commits).
  * **Colaboración en GitHub:** Aprendí el ciclo completo de colaboración, incluyendo:
    * **Repositorios Remotos:** Cómo conectar un repositorio local con uno en GitHub.
    * **Pull Requests (PRs):** El flujo estándar para proponer cambios y solicitar su revisión antes de fusionarlos en la rama principal.
    * **Sincronización:** Comandos para `clone`, `fetch`, `pull` y `push` cambios entre repositorios locales y remotos.

### Comandos Git Importantes

Dominar la terminal para Git es crucial. Tal como he experimentado en varias ocasiones, si la interfaz gráfica falla, los comandos de terminal son tu salvación. Algunos comandos que me parecieron especialmente útiles y que me han "salvado la vida" son:

* `git init`: Inicializar un nuevo repositorio.
* `git add .` / `git add <archivo>`: Añadir cambios al área de staging.
* `git commit -m "Mensaje"`: Guardar los cambios staged en el historial.
* `git status`: Ver el estado actual del repositorio.
* `git log --oneline`: Ver un historial conciso de commits.
* `git diff`: Ver las diferencias entre el directorio de trabajo, el staging y los commits.
* `git branch <nombre>` / `git checkout <nombre>`: Crear y cambiar entre ramas.
* `git merge <rama>`: Fusionar cambios de una rama a otra.
* `git pull origin main`: Descargar y fusionar cambios de un repositorio remoto.
* `git push origin main`: Subir tus commits al repositorio remoto.
* `git remote add origin <URL>`: Conectar un repositorio local con uno remoto.
* `git stash`: **¡Mi salvador\!** Guarda temporalmente los cambios no commiteados para poder cambiar de rama o realizar otras operaciones, y luego restaurarlos con `git stash pop`. Esto es invaluable cuando los conflictos son graves y necesitas pausar un trabajo.
* `git commit --amend`: Para modificar el último commit (cambiar el mensaje o añadir archivos olvidados). Muy útil para mantener un historial limpio antes de hacer `push`.
* `git revert <commit-hash>`: Deshace un commit creando un nuevo commit que revierte los cambios. Es más seguro que `reset` para historial compartido.
* `git reset --hard HEAD~1`: Deshace el último commit y descarta los cambios (usar con precaución, reescribe el historial).
* `git rebase -i HEAD~N`: Iniciar un rebase interactivo para reescribir el historial de commits (squash, reword, reordenar).
* `git cherry-pick <commit-hash>`: Aplica un commit específico de una rama a otra.
* `git log --oneline --graph --all`: Una forma excelente de visualizar la estructura de ramas y commits.

### Buenas Prácticas y Consejos

* **Convenciones de Commits:** Aprendí la importancia de usar convenciones como `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `test:`, `chore:` en los mensajes de commit. Esto estructura el historial y facilita la comprensión para otros colaboradores y herramientas de automatización.
* **Reiniciar el sistema** tras la instalación de Git/GitHub Desktop (o cualquier herramienta importante) puede solucionar errores inesperados.
* **Entender el `.git`:** Me familiaricé con la estructura del directorio `.git/` (`hooks`, `objects`, `refs`, `config`, `HEAD`, `index`) para comprender cómo Git almacena la información internamente.

## ⚙️ Ejercicios Realizados

Los ejercicios me permitieron aplicar los conceptos de Git en escenarios reales, desde lo más básico hasta la resolución de desafíos avanzados. Puedes ver los resultados de algunos de estos ejercicios en mi repositorio de GitHub: [moises-cisneros/Git-Exercises](https://github.com/moises-cisneros/Git-Exercises).

### ✅ Tareas Iniciales: Configuración y Primer Repositorio

1. **Instalación y Configuración:**
    * Instalé Git en mi sistema siguiendo la guía oficial de `git-scm.com/downloads`.
    * Configuré mi nombre de usuario y email globalmente:

        ```bash
        git config --global user.name "Tu Nombre"
        git config --global user.email "tu@email.com"
        ```

2. **Creación del Primer Repositorio Local:**

    ```bash
    mkdir git-proyecto && cd git-proyecto
    git init
    touch index.html style.css
    git add .
    git commit -m "Commit inicial: Configuración del proyecto"
    ```

3. **Realizar Cambios y Commit:**
      * Modifiqué `index.html` y verifiqué los cambios con `git status` y `git diff`.
      * Realicé un nuevo commit:

        ```bash
        git add index.html
        git commit -m "feat: Actualizado index.html con contenido inicial"
        ```

4. **Verificar Historial:**

    ```bash
    git log --oneline
    ```

### 🔥 Desafíos Prácticos Adicionales

Afronté varios desafíos para poner a prueba mis habilidades en Git:

* Creé un repositorio `Git-Exercises` en GitHub (`moises-cisneros/Git-Exercises`), luego me conecté localmente.

    ```bash
    git remote add https://github.com/moises-cisneros/Git-Exercises.git
    cd git-exercises
    ```

* **`git stash`:** Utilicé `git stash` para guardar cambios sin commitear y `git stash pop` para restaurarlos. ¡Una herramienta que me salvó el día\!

* **`git commit --amend`:** Practiqué modificar el último commit para corregir un mensaje o añadir archivos olvidados.

* **`git rebase -i` (Interactivo):** Logré utilizar `rebase -i` para modificar el historial de commits, incluyendo la reescritura de mensajes, combinación de commits (`squash`) y reordenamiento. Esta fue una de las partes más desafiantes pero también más gratificantes del día, ya que me dio un control mucho mayor sobre la limpieza del historial.
  * *Captura de terminal:
  ![Git Rebase](/assets/day-04/exercise_git_rebase.png "Git Rebase")*

* **`git cherry-pick`:** Apliqué commits específicos de una rama a otra, demostrando cómo mover funcionalidades aisladas.

* **Git Hooks:** Configuramos y probamos un `pre-commit hook` para automatizar la verificación de calidad del código antes de un commit. Esto me permitió entender cómo se pueden implementar reglas de equipo para asegurar que el código cumpla con ciertos estándares.
  * *Captura de terminal:
  ![Git Hooks](/assets/day-04/exercise_git_hooks.png "Git Hooks")*

## 💭 Reflexiones y lecciones clave para otros

El Día 4 ha sido, sin duda, uno de los más intensos y gratificantes hasta ahora. Me llevo la certeza de que dominar Git a nivel de terminal es una habilidad indispensable que te sacará de apuros cuando las interfaces gráficas fallen, algo que ya me ha sucedido en el pasado.

La práctica con los **conflictos de merge y la resolución manual** fue reveladora. Es una situación común en el trabajo colaborativo, y entender cómo abordarla directamente es empoderador. El comando `git stash` se convirtió en mi nuevo favorito; no puedo contar las veces que me ha "salvado la vida" al permitirme guardar cambios volátiles sin commitear, especialmente cuando los conflictos o las interrupciones repentinas me obligaban a cambiar de contexto.

Además, comprender el uso de `git commit --amend` y el `rebase interactivo` para **pulir el historial de commits** antes de hacer `push` a ramas compartidas es una buena práctica invaluable que adoptaré en todos mis futuros proyectos. La claridad del historial facilita la auditoría y la colaboración.

Finalmente, el aprender sobre las **convenciones de commits** como `feat:`, `fix:`, etc., me ha impulsado a adoptar una metodología más estructurada y profesional en mis futuros proyectos, sabiendo que no solo beneficia mi propio seguimiento, sino también la legibilidad para cualquier equipo.

## 📎 Recursos Utilizados

* 🧠 **Artículo del reto Día 4:** [Git & GitHub - Basics, Branching, Merging, PRs](https://www.google.com/search?q=https://90daysdevops.295devops.com/semana-01/dia4/)
* 🌐 **Sitio oficial de Git (descargas ):** [git-scm.com/downloads](https://git-scm.com/downloads)
* 🌐 **Sitio oficial de Git (documentación):** [git-scm.com/docs](https://git-scm.com/docs)
* **Aprendizaje Interactivo de Git Branching:** [Learn Git Branching](https://learngitbranching.js.org/?locale=es_ES
)
* 📄 **Guia de Git de Atlassian:** [Atlassian Git Learning Guide](https://www.atlassian.com/git)
* 📖 **Libro "Pro Git" (Capítulo 2 - Uso Básico):** [Pro Git Book](https://git-scm.com/book/en/v2)
* 🚀 **Guía "GitHub's Hello World":** [GitHub Hello World Guide](https://docs.github.com/en/get-started/quickstart/hello-world)
