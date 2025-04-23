USE [FerreteriaDB]
GO
/****** Object:  StoredProcedure [dbo].[InsertarArticulo]    Script Date: 22/04/2025 2:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[InsertarArticulo]
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
        IF EXISTS (SELECT 1 FROM dbo.Proveedor WHERE IdProveedor = @IdProveedor) AND
           EXISTS (SELECT 1 FROM dbo.Categoria WHERE IdCategoria = @IdCategoria)
        BEGIN
            INSERT INTO dbo.Articulos (
			    CodeArticulo,
                Nombre,
                Stock,
                PrecioUnitario,
                Descripcion,
                FechaRegistro,
                IdProveedor,
                IdCategoria
            )
            VALUES (
				@CodeArticulo,
                @NombreArticulo,
                @Stock,
                @Precio,
                @Descripcion,
                GETDATE(),
                @IdProveedor,
                @IdCategoria
            );

            SELECT SCOPE_IDENTITY() AS IdArticulo;
        END
        ELSE
            RAISERROR('IdProveedor o IdCategoria no existen.', 16, 1);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
