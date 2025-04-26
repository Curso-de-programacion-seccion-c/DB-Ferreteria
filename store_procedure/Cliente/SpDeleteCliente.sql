CREATE PROCEDURE DeleteCliente
    @IdCliente SMALLINT
AS
BEGIN

    DELETE FROM Clientes
    WHERE IdCliente = @IdCliente;

END;