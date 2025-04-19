CREATE PROCEDURE ReadClienteById
    @IdCliente SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdCliente, Dpi, Nombre, Apellido, NIT, CorreoElectronico, Telefono, FechaRegistro
    FROM Clientes
    WHERE IdCliente = @IdCliente;
END;