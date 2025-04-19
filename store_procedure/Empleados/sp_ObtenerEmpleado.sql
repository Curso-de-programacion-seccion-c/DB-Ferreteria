CREATE OR ALTER PROCEDURE sp_ObtenerEmpleado
    @IdEmpleado INT
AS
BEGIN
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
    WHERE IdEmpleado = @IdEmpleado
END