CREATE PROCEDURE SpUpdateRol
    @IdRol INT,
    @Nombre NVARCHAR(50),
    @Sueldo DECIMAL(10, 2),
AS
BEGIN
    UPDATE Roles
    SET Nombre = @Nombre,
        Sueldo = @Sueldo
    WHERE IdRol = @IdRol

    SELECT Nombre AS Rol, Sueldo AS Sueldo
    FROM Roles
    WHERE IdRol = @IdRol
END