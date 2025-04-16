CREATE PROCEDURE Sp_FormaPago_Crear
    @NombreFormaPago VARCHAR(25),
    @Descripcion VARCHAR(50) = NULL
AS
BEGIN
    
    BEGIN TRY
        -- Validar nombre no vac�o
        IF NULLIF(RTRIM(LTRIM(@NombreFormaPago)), '') IS NULL
        BEGIN
            RAISERROR('El nombre de la forma de pago no puede estar vac�o', 16, 1);
            RETURN;
        END

        -- Validar nombre �nico
        IF EXISTS (SELECT 1 FROM FormaPago WHERE NombreFormaPago = @NombreFormaPago)
        BEGIN
            RAISERROR('Ya existe una forma de pago con este nombre', 16, 1);
            RETURN;
        END

        -- Insertar nuevo registro
        INSERT INTO FormaPago (NombreFormaPago, Descripcion)
        VALUES (@NombreFormaPago, @Descripcion);
        
        -- Retornar ID generado
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al crear forma de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;
