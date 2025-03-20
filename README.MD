# Ferreteria-DB

Este proyecto contiene los archivos SQL necesarios para la creación y gestión de la base de datos de una ferretería.

## Requisitos

Antes de ejecutar los archivos SQL, asegúrate de tener lo siguiente instalado:

- Un servidor de base de datos compatible (por ejemplo, MySQL, PostgreSQL, SQL Server, etc.).
- Un cliente para ejecutar comandos SQL (como MySQL Workbench, pgAdmin, o la línea de comandos de tu sistema).

## Instrucciones para ejecutar los archivos SQL

1. **Clona el repositorio**:
    ```bash
    git clone git@github.com:Curso-de-programacion-seccion-c/DB-Ferreteria.git
    cd Ferreteria-DB
    ```

2. **Conéctate a tu servidor de base de datos**:
    - Abre tu cliente SQL.
    - Ingresa las credenciales de tu servidor (usuario, contraseña, host, puerto).

3. **Ejecuta los archivos SQL en el orden correcto**:
    - Primero, ejecuta el archivo de creación de la base de datos:
      ```sql
      base_datos.sql;
      ```
    - Luego, ejecuta los scripts de tablas y datos:
      ```sql
      tablas.sql;
      ```

4. **Verifica que la base de datos se haya creado correctamente**:
    - Realiza consultas de prueba para confirmar que las tablas y datos están presentes.

## Notas

- Asegúrate de que los archivos SQL sean compatibles con tu sistema de base de datos.
- Si encuentras errores, revisa los mensajes de error y ajusta los scripts según sea necesario.
