USE FerreteriaDB;
GO

CREATE OR ALTER PROCEDURE dbo.InsertarArticulo
    @NombreArticulo VARCHAR(35),
    @Precio         DECIMAL(10,2),
    @Stock          SMALLINT,
    @IdCategoria    TINYINT,
    @IdProveedor    TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS(SELECT 1 FROM dbo.Proveedor WHERE IdProveedor = @IdProveedor)
           AND EXISTS(SELECT 1 FROM dbo.Categoria WHERE IdCategoria = @IdCategoria)
        BEGIN
            INSERT INTO dbo.Articulos (
                CodeArticulo,
                Nombre,
                Stock,
                PrecioUnitario,
                FechaRegistro,
                IdProveedor,
                IdCategoria
            )
            VALUES (
                (SELECT ISNULL(MAX(CodeArticulo), 0) + 1 FROM dbo.Articulos),
                @NombreArticulo,
                @Stock,
                @Precio,
                GETDATE(),
                @IdProveedor,
                @IdCategoria
            );

            -- Devuelvo el nuevo IdArticulo
            SELECT SCOPE_IDENTITY() AS IdArticulo;
        END
        ELSE
            RAISERROR('IdProveedor o IdCategoria no existe.', 16, 1);
    END TRY
    BEGIN CATCH
        THROW;  
    END CATCH
END;
GO
