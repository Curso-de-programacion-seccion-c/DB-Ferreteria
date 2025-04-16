CREATE PROCEDURE Sp_FormaPago_ObtenerTodas
AS
BEGIN
    
    BEGIN TRY
        SELECT 
            idFormaPago,
            NombreFormaPago,
            Descripcion
        FROM 
            FormaPago
        ORDER BY 
            NombreFormaPago;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al obtener formas de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;