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