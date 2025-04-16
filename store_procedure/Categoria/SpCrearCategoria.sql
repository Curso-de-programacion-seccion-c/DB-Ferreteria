CREATE PROCEDURE SpCrearCategoria
	@NombreCategoria VARCHAR(32)
AS
BEGIN
	IF(RTRIM(LTRIM(@NombreCategoria)) = '')
	BEGIN
		THROW 50000, 'No se puede agregar categorias vacias', 1;
        RETURN
	END

	IF EXISTS(SELECT 1 FROM Categoria WHERE NombreCategoria LIKE '%' + @NombreCategoria + '%')
	BEGIN
		THROW 50000, 'No se puede agregar la categoria ya existe', 1;
        RETURN
	END

	INSERT INTO Categoria(NombreCategoria)
		VALUES(@NombreCategoria);
END