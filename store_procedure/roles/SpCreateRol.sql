CREATE OR ALTER PROCEDURE InsertarRol
    @Nombre VARCHAR(50),
    @Sueldo FLOAT
AS
BEGIN
    INSERT INTO Roles (Nombre, Sueldo)
    VALUES (@Nombre, @Sueldo)
END
GO
