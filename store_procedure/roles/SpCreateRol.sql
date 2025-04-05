CREATE OR ALTER PROCEDURE InsertarRol
    @Nombre VARCHAR(25),
    @Sueldo DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Roles (Nombre, Sueldo)
    VALUES (@Nombre, @Sueldo)
END
GO
