CREATE PROCEDURE sp_ActualizarFactura
    @IdFactura INT,
    @IdEmpleado INT,
    @IdCliente INT,
    @Fecha DATETIME,
    @TotalPago DECIMAL(10,2),
    @IdFormaPago INT
AS
BEGIN

    -- Validar que la factura exista
    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 50005, 'No se puede actualizar: la factura no existe', 1;
    END

    -- Validar existencia de empleado
    IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        THROW 50006, 'No se puede actualizar: el empleado no existe', 1;
    END

    -- Validar existencia de cliente
    IF NOT EXISTS (SELECT 1 FROM Clientes WHERE IdCliente = @IdCliente)
    BEGIN
        THROW 50007, 'No se puede actualizar: el cliente no existe', 1;
    END

    -- Validar existencia de forma de pago
    IF NOT EXISTS (SELECT 1 FROM FormaPago WHERE IdFormaPago = @IdFormaPago)
    BEGIN
        THROW 50008, 'No se puede actualizar: la forma de pago no existe', 1;
    END

    -- Actualizar la factura
    UPDATE Factura
    SET 
        IdEmpleado = @IdEmpleado,
        IdCliente = @IdCliente,
        Fecha = @Fecha,
        Total_pago = @TotalPago,
        IdFormaPago = @IdFormaPago
    WHERE IdFactura = @IdFactura;

    -- Retornar la factura actualizada
    SELECT * FROM Factura WHERE IdFactura = @IdFactura;
END;
