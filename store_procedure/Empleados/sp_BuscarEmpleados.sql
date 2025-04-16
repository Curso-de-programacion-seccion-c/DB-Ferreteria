ALTER PROCEDURE sp_BuscarEmpleados
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener todos los empleados (sin importar si hay búsqueda o no)
    SELECT 
        IdEmpleado, 
        Dpi, 
        Nombre, 
        Apellido, 
        Puesto,
        CorreoElectronico, 
        Telefono, 
        FechaContratacion, Estado
    FROM Empleados
    ORDER BY Nombre, Apellido;

    -- Mostrar mensaje si no hay empleados
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 'Empleados no encontrados' AS Mensaje;
    END
END
