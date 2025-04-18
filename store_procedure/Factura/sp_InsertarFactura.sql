CREATE OR ALTER PROCEDURE sp_InsertarFactura
    @IdEmpleado INT,
    @IdCliente INT,
    @Fecha DATETIME,
    @IdFormaPago INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar existencia del empleado
    IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        THROW 50001, 'No se puede agregar la factura: el empleado no existe', 1;
    END

    -- Validar existencia del cliente
    IF NOT EXISTS (SELECT 1 FROM Clientes WHERE IdCliente = @IdCliente)
    BEGIN
        THROW 50002, 'No se puede agregar la factura: el cliente no existe', 1;
    END

    -- Validar existencia de la forma de pago
    IF NOT EXISTS (SELECT 1 FROM FormaPago WHERE IdFormaPago = @IdFormaPago)
    BEGIN
        THROW 50003, 'No se puede agregar la factura: la forma de pago no existe', 1;
    END

    -- Insertar la factura (Total_pago se inicia en 0 y se actualizará automáticamente por el trigger)
    INSERT INTO Factura (IdEmpleado, IdCliente, Fecha, Total_pago, IdFormaPago)
    VALUES (@IdEmpleado, @IdCliente, @Fecha, 0.00, @IdFormaPago);

    -- Devolver el registro recién insertado
    SELECT TOP 1 *
    FROM Factura
    WHERE IdCliente = @IdCliente
      AND Fecha = @Fecha
      AND IdEmpleado = @IdEmpleado
    ORDER BY IdFactura DESC;
END;
