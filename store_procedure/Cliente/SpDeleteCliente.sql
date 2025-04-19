CREATE PROCEDURE DeleteCliente
    @IdCliente SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Clientes
    WHERE IdCliente = @IdCliente;

    SELECT 'Cliente eliminado correctamente.' AS Mensaje;
END;