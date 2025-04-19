CREATE PROCEDURE CreateCliente
    @Dpi NVARCHAR(13),
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @NIT NVARCHAR(20),
    @CorreoElectronico NVARCHAR(100),
    @Telefono NVARCHAR(16),
    @FechaRegistro DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Clientes (Dpi, Nombre, Apellido, NIT, CorreoElectronico, Telefono, FechaRegistro)
    VALUES (@Dpi, @Nombre, @Apellido, @NIT, @CorreoElectronico, @Telefono, ISNULL(@FechaRegistro, GETDATE()));

    SELECT SCOPE_IDENTITY() AS IdCliente; 
END;