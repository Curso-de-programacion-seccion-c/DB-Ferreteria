ALTER PROCEDURE sp_ObtenerEmpleado
    @IdEmpleado INT
AS
BEGIN
    SELECT 
        IdEmpleado, Dpi, Nombre, Apellido, Puesto,
        CorreoElectronico, Telefono, IdRol, FechaContratacion
    FROM Empleados
    WHERE IdEmpleado = @IdEmpleado
    AND Estado = 1
    


END