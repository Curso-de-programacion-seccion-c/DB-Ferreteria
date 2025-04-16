

CREATE PROCEDURE sp_ActualizarEmpleado
    @IdEmpleado INT,
    @Dpi VARCHAR(20),
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Puesto VARCHAR(50),
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(15),
    @IdRol INT,
    @FechaContratacion DATE

AS
BEGIN
    UPDATE Empleados SET
        Dpi = @Dpi,
        Nombre = @Nombre,
        Apellido = @Apellido,
        Puesto = @Puesto,
        CorreoElectronico = @CorreoElectronico,
        Telefono = @Telefono,
        IdRol = @IdRol,
        FechaContratacion = @FechaContratacion
     
    WHERE IdEmpleado = @IdEmpleado
END