CREATE OR ALTER TRIGGER trg_ActualizarStock_Articulos
ON DetalleVenta
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT: restar stock
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE A
        SET A.Stock = A.Stock - I.Cantidad
        FROM Articulos A
        INNER JOIN inserted I ON A.IdArticulo = I.IdArticulo;
    END

    -- DELETE: sumar stock
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE A
        SET A.Stock = A.Stock + D.Cantidad
        FROM Articulos A
        INNER JOIN deleted D ON A.IdArticulo = D.IdArticulo;
    END

    -- UPDATE: ajustar stock según diferencia
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE A
        SET A.Stock = A.Stock + (D.Cantidad - I.Cantidad)
        FROM Articulos A
        INNER JOIN deleted D ON A.IdArticulo = D.IdArticulo
        INNER JOIN inserted I ON A.IdArticulo = I.IdArticulo AND D.IdDetalleVenta = I.IdDetalleVenta;
    END
END;
