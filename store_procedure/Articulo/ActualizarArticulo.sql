USE [FerreteriaDB]
GO
/****** Object:  StoredProcedure [dbo].[ActualizarArticulo]    Script Date: 22/04/2025 1:57:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ActualizarArticulo]
    @IdArticulo SMALLINT,
    @CodeArticulo SMALLINT,
    @NombreArticulo VARCHAR(35),
    @Precio DECIMAL(10,2),
    @Stock SMALLINT,
    @Descripcion VARCHAR(50),
    @IdCategoria TINYINT,
    @IdProveedor TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM dbo.Articulos WHERE IdArticulo = @IdArticulo) AND
           EXISTS (SELECT 1 FROM dbo.Proveedor WHERE IdProveedor = @IdProveedor) AND
           EXISTS (SELECT 1 FROM dbo.Categoria WHERE IdCategoria = @IdCategoria)
        BEGIN
            UPDATE dbo.Articulos
            SET Nombre = @NombreArticulo,
                CodeArticulo = @CodeArticulo,
                PrecioUnitario = @Precio,
                Stock = @Stock,
                Descripcion = @Descripcion,
                IdProveedor = @IdProveedor,
                IdCategoria = @IdCategoria
            WHERE IdArticulo = @IdArticulo;

            SELECT 1 AS Resultado, 'Artículo actualizado correctamente.' AS Mensaje;
        END
        ELSE
            SELECT 0 AS Resultado, 'IdArticulo, IdProveedor o IdCategoria no existen.' AS Mensaje;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
