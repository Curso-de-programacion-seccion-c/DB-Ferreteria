CREATE OR ALTER PROCEDURE Sp_FormaPago_ObtenerPorId
    @IdFormaPago TINYINT,
	@nombre VARCHAR(100)
AS
BEGIN
    
    BEGIN TRY
		IF @IdFormaPago = 0 AND @nombre = ''
		BEGIN

			 RAISERROR('No se encontr� la forma de pago especificada', 16, 1);

		END

		SELECT *
		FROM FormaPago
		WHERE (@IdFormaPago = 0 OR IdFormaPago = @IdFormaPago)
		AND (@nombre = '' OR NombreFormaPago=@nombre)
            
        IF @@ROWCOUNT = 0
            RAISERROR('No se encontr� la forma de pago especificada', 16, 1);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al obtener forma de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;