CREATE PROCEDURE Sp_FormaPago_Eliminar
    @IdFormaPago TINYINT
AS
BEGIN
    
    BEGIN TRY
        -- Validar existencia
        IF NOT EXISTS (SELECT 1 FROM FormaPago WHERE idFormaPago = @IdFormaPago)
        BEGIN
            RAISERROR('La forma de pago especificada no existe', 16, 1);
            RETURN;
        END

        -- Eliminar registro
        DELETE FROM FormaPago WHERE idFormaPago = @IdFormaPago;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al eliminar forma de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;