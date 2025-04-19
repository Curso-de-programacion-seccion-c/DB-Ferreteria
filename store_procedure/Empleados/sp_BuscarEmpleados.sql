CREATE OR ALTER PROCEDURE sp_BuscarEmpleados
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener todos los empleados (sin importar si hay b�squeda o no)
    SELECT 
        IdEmpleado, 
        Dpi, 
        Empleados.Nombre AS NombreEmpleado,
        Apellido, 
        Puesto,
        CorreoElectronico, 
        Telefono, 
        FechaContratacion,
        Roles.IdRol,
        Roles.Nombre AS NombreRol,
        Roles.Sueldo AS SueldoRol
    FROM Empleados
    INNER JOIN Roles ON Empleados.IdRol = Roles.IdRol

    -- Mostrar mensaje si no hay empleados
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 'Empleados no encontrados' AS Mensaje;
    END
END
