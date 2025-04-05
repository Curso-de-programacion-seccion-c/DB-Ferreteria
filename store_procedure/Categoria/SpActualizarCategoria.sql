CREATE PROCEDURE SpActualizarCategoria
	@idCategoria tinyint,
	@nombre VARCHAR(32)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM Categoria WHERE IdCategoria = @idCategoria)
	BEGIN
		THROW 50000, 'No se puede actualizar la categoria por que no existe', 1;
        RETURN
	END

	IF EXISTS(SELECT 1 FROM Categoria WHERE NombreCategoria = @nombre
		AND IdCategoria <> @idCategoria)
	BEGIN
		THROW 50000, 'No se puede agregar la categoria ya existe', 1;
        RETURN
	END

	UPDATE Categoria
		SET NombreCategoria = @nombre
	WHERE IdCategoria = @idCategoria
END