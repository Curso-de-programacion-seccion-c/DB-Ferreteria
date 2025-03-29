CREATE PROCEDURE SpFindUser
    @CodigoUsuario NVARCHAR(50),
    @Username NVARCHAR(50),
    @isActive BIT = 1,
    @isFind BIT OUTPUT
AS
BEGIN
    SET @isFind = 0 -- Inicializar como no encontrado

    IF @CodigoUsuario IS NOT NULL
        BEGIN
            IF @isActive = 1
                BEGIN
                    IF EXISTS (SELECT 1 FROM Usuario WHERE CodigoUsuario = @CodigoUsuario AND IsActive = 1)
                        BEGIN
                            SET @isFind = 1
                        END
                END
            ELSE
                BEGIN
                    IF EXISTS (SELECT 1 FROM Usuario WHERE CodigoUsuario = @CodigoUsuario)
                        BEGIN
                            SET @isFind = 1
                        END
                END
        END
    ELSE IF @Username IS NOT NULL
       BEGIN
            IF @isActive = 1
                BEGIN
                    IF EXISTS (SELECT 1 FROM Usuario WHERE Username = @Username AND IsActive = 1)
                        BEGIN
                            SET @isFind = 1
                        END
                END
            ELSE
                BEGIN
                    IF EXISTS (SELECT 1 FROM Usuario WHERE Username = @Username)
                        BEGIN
                            SET @isFind = 1
                        END
                END
        END
       END
END
go

