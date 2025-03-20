
USE FerreteriaDB

CREATE TABLE Categoria (
	IdCategoria INT IDENTITY(1,1) PRIMARY KEY ,
	NombreCategoria VARCHAR(32) NOT NULL,
	IsActive BIT DEFAULT 1
);

GO

CREATE TABLE Proveedor(
	IdProveedor INT IDENTITY(1,1) PRIMARY KEY,
	NombreProveedor VARCHAR(128) NOT NULL,
	Telefono VARCHAR(16) NOT NULL,
	NombreContacto VARCHAR(128) NOT NULL,
	IsActive BIT DEFAULT 1
);

GO

CREATE TABLE Usuario(
	IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
	IdEmpleado INT,
	CodigoUsuario VARCHAR(8),
	Username varchar(16),
	UserPassword VARCHAR(16),
	IdRol INT,
	IsActive BIT DEFAULT 1,
)