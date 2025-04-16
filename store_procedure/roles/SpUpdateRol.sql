CREATE OR ALTER PROCEDURE ActualizarRol
    @IdRol TINYINT,
    @Nombre VARCHAR(25),
    @Sueldo DECIMAL(10,2)
AS
BEGIN
    UPDATE Roles
    SET Nombre = @Nombre, Sueldo = @Sueldo
    WHERE IdRol = @IdRol
END
GO
