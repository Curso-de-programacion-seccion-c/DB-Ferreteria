CREATE PROCEDURE Sp_FormaPago_Actualizar
    @IdFormaPago TINYINT,
    @NombreFormaPago VARCHAR(25) = NULL,
    @Descripcion VARCHAR(50) = NULL
AS
BEGIN
    
    BEGIN TRY
        -- Validar existencia
        IF NOT EXISTS (SELECT 1 FROM FormaPago WHERE idFormaPago = @IdFormaPago)
        BEGIN
            RAISERROR('La forma de pago especificada no existe', 16, 1);
            RETURN;
        END

        -- Validar nombre único si se proporciona
        IF @NombreFormaPago IS NOT NULL AND 
           EXISTS (SELECT 1 FROM FormaPago WHERE NombreFormaPago = @NombreFormaPago AND idFormaPago <> @IdFormaPago)
        BEGIN
            RAISERROR('Ya existe otra forma de pago con este nombre', 16, 1);
            RETURN;
        END

        -- Actualizar registro
        UPDATE FormaPago SET
            NombreFormaPago = ISNULL(@NombreFormaPago, NombreFormaPago),
            Descripcion = ISNULL(@Descripcion, Descripcion)
        WHERE idFormaPago = @IdFormaPago;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al actualizar forma de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;