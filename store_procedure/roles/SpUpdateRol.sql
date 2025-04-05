CREATE OR ALTER PROCEDURE ActualizarRol
    @Id INT,
    @Nombre VARCHAR(50),
    @Sueldo FLOAT
AS
BEGIN
    UPDATE Roles
    SET Nombre = @Nombre, Sueldo = @Sueldo
    WHERE Id = @Id
END
GO
