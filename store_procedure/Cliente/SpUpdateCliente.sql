CREATE PROCEDURE UpdateCliente
    @IdCliente SMALLINT,
    @Dpi NVARCHAR(13),
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @NIT NVARCHAR(20),
    @CorreoElectronico NVARCHAR(100),
    @Telefono NVARCHAR(16),
    @FechaRegistro DATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Clientes
    SET 
        Dpi = @Dpi,
        Nombre = @Nombre,
        Apellido = @Apellido,
        NIT = @NIT,
        CorreoElectronico = @CorreoElectronico,
        Telefono = @Telefono,
        FechaRegistro = @FechaRegistro
    WHERE IdCliente = @IdCliente;

    SELECT 'Cliente actualizado correctamente.' AS Mensaje;
END;