CREATE PROCEDURE SpCreateRol
    @IdRol INT OUTPUT,
    @Nombre VARCHAR(25),
    @Sueldo DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Roles (Nombre, Sueldo)
    VALUES (@Nombre, @Sueldo)

    SET @IdRol = SCOPE_IDENTITY();

    SELECT @IdRol AS IdRol
    RETURN
END