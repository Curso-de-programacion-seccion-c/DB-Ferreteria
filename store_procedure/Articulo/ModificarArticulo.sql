CREATE PROCEDURE ModificarArticulo
    @CodeArticulo SMALLINT,
    @Nombre VARCHAR(35),
    @Stock SMALLINT,
    @PrecioUnitario DECIMAL(10,2),
    @Descripcion VARCHAR(50),
    @FechaRegistro DATE,
    @IdProveedor TINYINT,
    @IdCategoria TINYINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Articulos WHERE CodeArticulo = @CodeArticulo)
        BEGIN
            UPDATE Articulos
            SET Nombre = @Nombre,
                Stock = @Stock,
                PrecioUnitario = @PrecioUnitario,
                Descripcion = @Descripcion,
                FechaRegistro = @FechaRegistro,
                IdProveedor = @IdProveedor,
                IdCategoria = @IdCategoria
            WHERE CodeArticulo = @CodeArticulo
        END
        ELSE
        BEGIN
            RAISERROR('No se encontró el artículo a modificar.', 16, 1)
        END
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el artículo: ' + ERROR_MESSAGE()
    END CATCH
END
