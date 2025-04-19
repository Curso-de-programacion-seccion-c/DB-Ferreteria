CREATE PROCEDURE EliminarArticulo
    @CodeArticulo SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DELETE FROM Articulos WHERE CodeArticulo = @CodeArticulo
    END TRY
    BEGIN CATCH
        PRINT 'Error al eliminar el art�culo: ' + ERROR_MESSAGE()
    END CATCH
END
