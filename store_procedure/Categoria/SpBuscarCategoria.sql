CREATE PROCEDURE SpBuscarCategoria
	@idCategoria tinyint = 0,
	@nombre VARCHAR(32) = ''
AS
BEGIN
	IF @idCategoria = 0 AND @nombre = ''
	BEGIN
		THROW 50000, 'No se puede buscar categorias vacias', 1;
		RETURN
	END

	SELECT *
	FROM Categoria
	WHERE (@idCategoria = 0 OR IdCategoria = @idCategoria)
	AND (@nombre = '' OR NombreCategoria = @nombre)
END