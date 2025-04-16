CREATE PROCEDURE SpEliminarCategoria
	@idCategoria tinyint
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Articulos WHERE IdCategoria = @idCategoria)
	BEGIN
		THROW 50000, 'No se puede eliminar la categoria por que esta relacionado a uno o varios productos', 1;
        RETURN
	END

	DELETE FROM Categoria WHERE IdCategoria = @idCategoria;
END