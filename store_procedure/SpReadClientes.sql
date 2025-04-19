CREATE PROCEDURE ReadClientes
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdCliente, Dpi, Nombre, Apellido, NIT, CorreoElectronico, Telefono, FechaRegistro
    FROM Clientes;
END;