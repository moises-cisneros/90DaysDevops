#!/bin/bash

LOG="logs_despliegue.txt"
APP_DIR="devops-static-web"

instalar_dependencias() {
    echo "Instalando dependencias..." | tee -a $LOG
    sudo apt update && sudo apt install -y python3 python3-pip python3-venv nginx git 2>&1 | tee -a $LOG
    sudo systemctl enable nginx 2>&1 | tee -a $LOG
    sudo systemctl start nginx 2>&1 | tee -a $LOG
}

clonar_app() {
    echo "Clonando la aplicación..." | tee -a $LOG
    if [ -d "$APP_DIR" ]; then
        echo "El directorio $APP_DIR ya existe. Usando el existente." | tee -a $LOG
        cd "$APP_DIR" || exit 1
        git pull origin booklibrary 2>&1 | tee -a ../$LOG
    else
        git clone -b booklibrary https://github.com/roxsross/devops-static-web.git 2>&1 | tee -a $LOG
        cd "$APP_DIR" || exit 1
    fi
}

configurar_entorno() {
    echo "Configurando entorno virtual..." | tee -a ../$LOG
    # Si venv está corrupto, borrarlo y recrear
    if [ ! -d "venv" ] || [ ! -f "venv/bin/activate" ] && [ ! -f "venv/Scripts/activate" ]; then
        rm -rf venv
        python3 -m venv venv
    fi
    # Activar entorno virtual
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    elif [ -f "venv/Scripts/activate" ]; then
        source venv/Scripts/activate
    fi
    pip install --upgrade pip
    pip install -r requirements.txt 2>&1 | tee -a ../$LOG
    pip install gunicorn 2>&1 | tee -a ../$LOG
}

configurar_gunicorn() {
    echo "Iniciando Gunicorn..." | tee -a ../$LOG
    pkill -f "gunicorn.*library_site" 2>/dev/null || true
    # Detectar plataforma y lanzar Gunicorn desde el path correcto
    if [ -f "venv/bin/gunicorn" ]; then
        nohup venv/bin/gunicorn -w 4 -b 0.0.0.0:8000 library_site:app >>../$LOG 2>&1 &
    elif [ -f "venv/Scripts/gunicorn.exe" ]; then
        nohup venv/Scripts/gunicorn.exe -w 4 -b 0.0.0.0:8000 library_site:app >>../$LOG 2>&1 &
    else
        echo "No se encontró Gunicorn en el entorno virtual" | tee -a ../$LOG
    fi
    sleep 3
}

configurar_nginx() {
    echo "Configurando Nginx..." | tee -a ../$LOG
    sudo rm -f /etc/nginx/sites-enabled/default
    sudo tee /etc/nginx/sites-available/booklibrary >/dev/null <<EOF
server {
    listen 80;
    server_name _;
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }
    location /static/ {
        alias $(pwd)/static/;
        expires 30d;
    }
    access_log /var/log/nginx/booklibrary_access.log;
    error_log /var/log/nginx/booklibrary_error.log;
}
EOF
    sudo ln -sf /etc/nginx/sites-available/booklibrary /etc/nginx/sites-enabled/
    sudo nginx -t >>../$LOG 2>&1 && sudo systemctl reload nginx
}

verificar_servicios() {
    echo "Verificando servicios..." | tee -a ../$LOG
    if systemctl is-active --quiet nginx; then
        echo "✓ Nginx está activo" | tee -a ../$LOG
    else
        echo "✗ Nginx no está activo" | tee -a ../$LOG
    fi
    if pgrep -f "gunicorn.*library_site" >/dev/null; then
        echo "✓ Gunicorn está corriendo" | tee -a ../$LOG
    else
        echo "✗ Gunicorn no está corriendo" | tee -a ../$LOG
    fi
    if netstat -tlnp | grep -q ":8000"; then
        echo "✓ Puerto 8000 está en uso" | tee -a ../$LOG
    else
        echo "✗ Puerto 8000 no está en uso" | tee -a ../$LOG
    fi
    if curl -s http://127.0.0.1:8000 >/dev/null; then
        echo "✓ Gunicorn responde correctamente" | tee -a ../$LOG
    else
        echo "✗ Gunicorn no responde" | tee -a ../$LOG
    fi
}

main() {
    echo "=== Iniciando despliegue de Book Library ===" | tee $LOG
    instalar_dependencias
    clonar_app
    configurar_entorno
    configurar_gunicorn
    configurar_nginx
    verificar_servicios
    echo "=== Despliegue finalizado ===" | tee -a ../$LOG
    echo "Revisá $LOG para detalles." | tee -a ../$LOG
    echo "La aplicación debería estar disponible en: http://$(hostname -I | awk '{print $1}')" | tee -a ../$LOG
}

main
