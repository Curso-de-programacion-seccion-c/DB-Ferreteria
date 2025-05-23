USE [FerreteriaDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ObtenerArticuloPorId]
    @IdArticulo SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT 
            IdArticulo,
            CodeArticulo,
            Nombre,
            Stock,
			PrecioUnitario,
            Descripcion
        FROM dbo.Articulos
        WHERE IdArticulo = @IdArticulo;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END


SELECT * FROM Articulos