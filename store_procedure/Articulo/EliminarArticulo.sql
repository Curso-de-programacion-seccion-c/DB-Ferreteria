USE [FerreteriaDB]
GO
/****** Object:  StoredProcedure [dbo].[EliminarArticulo]    Script Date: 22/04/2025 2:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[EliminarArticulo]
    @IdArticulo SMALLINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM dbo.Articulos WHERE IdArticulo = @IdArticulo)
        BEGIN
            DELETE FROM dbo.Articulos WHERE IdArticulo = @IdArticulo;
        END
        ELSE
            RAISERROR('IdArticulo no existe.', 16, 1);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
