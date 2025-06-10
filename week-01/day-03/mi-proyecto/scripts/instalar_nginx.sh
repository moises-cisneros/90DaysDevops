#!/bin/bash

# scripts/instalar_nginx.sh

echo "Iniciando script de provisionamiento..."

# 📚 Tarea: Actualizar paquetes e instalar Nginx
echo "Actualizando índices de paquetes e instalando Nginx..."
sudo apt update -y
sudo apt install -y nginx

# 📚 Tarea: Otro paquete instalado (Git)
echo "Instalando Git..."
sudo apt install -y git

# Asegurar que Nginx esté iniciado y habilitado al arranque
echo "Asegurando que Nginx esté iniciado y habilitado..."
sudo systemctl start nginx
sudo systemctl enable nginx

# 📚 Tarea: Un archivo en /var/www/html/index.html con tu nombre y fecha
TU_NOMBRE="Moises" # Reemplaza con tu nombre
FECHA_ACTUAL=$(date +"%d/%m/%Y %H:%M:%S") # Formato Día/Mes/Año Hora:Minuto:Segundo

echo "Creando o modificando /var/www/html/index.html..."
sudo bash -c "cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Despliegue DevOps</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; text-align: center; margin-top: 50px; background-color: #f0f2f5; color: #333; }
        .container { background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); display: inline-block; }
        h1 { color: #28a745; margin-bottom: 20px; }
        p { font-size: 1.1em; line-height: 1.6; }
        .footer { margin-top: 30px; font-size: 0.9em; color: #666; }
    </style>
</head>
<body>
    <div class='container'>
        <h1>Hola desde Nginx!</h1>
        <p>Este es mi servidor web.</p>
        <p>Desplegado por: <strong>$TU_NOMBRE</strong></p>
        <p class='footer'>Fecha del despliegue: $FECHA_ACTUAL</p>
        <p>Reto 90 Days DevOps en accion!</p>
    </div>
</body>
</html>
EOF"

echo "Provisionamiento completado."