CREATE DATABASE iHome;
GO

USE iHome;
GO

-- ==========================================================================
-- 1. TABLA CLIENTES
-- ==========================================================================

CREATE TABLE Clientes
(
    COD_Cliente INT IDENTITY(1,1)
        CONSTRAINT PK_Clientes
        PRIMARY KEY,
    ContactoNombre NVARCHAR(100) NOT NULL,
    ContactoApellido1 NVARCHAR(100) NOT NULL,
    ContactoApellido2 NVARCHAR(100) NULL,
    ContactoTel NVARCHAR(20) NULL,
    ContactoEmail NVARCHAR(300) NULL,
    DNI_NIF NVARCHAR(9) NULL,
    ContactoDireccion NVARCHAR(300) NULL,
    CodigoPostal NVARCHAR(10) NULL,
    Ciudad NVARCHAR(200) NULL,
    Provincia NVARCHAR(200) NULL,
    RGPD_Autoriza BIT NOT NULL
        CONSTRAINT DF_Clientes_RGPD DEFAULT 0,
    RGPD_Fecha DATETIME2 NULL,
	Fecha_Inicio DATETIME2
		GENERATED ALWAYS AS ROW START NOT NULL,
	Fecha_Fin DATETIME2
		GENERATED ALWAYS AS ROW END NOT NULL,
	
    PERIOD FOR SYSTEM_TIME
		(Fecha_Inicio, Fecha_Fin)
)
WITH
(
	SYSTEM_VERSIONING = ON
	(
		HISTORY_TABLE = dbo.Clientes_Historico
	)
);
GO

INSERT INTO Clientes
(
    ContactoNombre,
    ContactoApellido1,
    ContactoApellido2,
    ContactoTel,
    ContactoEmail,
    DNI_NIF,
    ContactoDireccion,
    CodigoPostal,
    Ciudad,
    Provincia,
    RGPD_Autoriza,
    RGPD_Fecha
)
VALUES
('Vera', 'Castro', 'Gutiérrez', '672958367', 'veracastro@gmail.com', '61234678Y', 'Calle Madrid', '28041', 'Madrid', 'Madrid', 1, '20230902'),
('Javier', 'Sánchez', 'Rivera', '689463778', 'javiersanchez@gmail.com', '87632816T', 'Calle Lisboa', '28014', 'Leganés', 'Madrid', 1, '20220417'),
('Francisco', 'Vaquero', 'Castro', '645277890', 'franciscovaquero@gmail.com', '47284617D', 'Avenida Fuenlabrada', '28911', 'Málaga', 'Málaga', 0, NULL),
('Marilyn', 'Rivera', null, '924784556', 'mrivera@gmail.com', 'Y7234819D', 'Calle Universidad', '28892', 'Bilbao', 'País Vasco', 1, getdate());
GO

SELECT * FROM Clientes;
GO

/*
ALTER TABLE Clientes
SET (SYSTEM_VERSIONING = OFF);
GO

DROP TABLE Clientes;
GO

DROP TABLE Clientes_Historico;
GO
*/


-- ==========================================================================
-- 2. TABLA PROVEEDORES
-- ==========================================================================

CREATE TABLE Proveedores
(
    COD_Proveedor INT IDENTITY(1,1)
        CONSTRAINT PK_Proveedores
        PRIMARY KEY,
    Empresa NVARCHAR(200) NOT NULL,
    ContactoNombre NVARCHAR(100) NULL,
    ContactoApellido1 NVARCHAR(100) NULL,
    ContactoApellido2 NVARCHAR(100) NULL,
    ContactoTel NVARCHAR(20) NULL,
    ContactoEmail NVARCHAR(300) NULL,
    NIF NVARCHAR(9) NULL,
    DireccionProveedor NVARCHAR(300) NULL,
    CodigoPostal NVARCHAR(10) NULL,
    Ciudad NVARCHAR(200) NULL,
    Provincia NVARCHAR(200) NULL,
    Notas NVARCHAR(MAX) NULL,
    RGPD_Autoriza BIT NOT NULL
        CONSTRAINT DF_Proveedores_RGPD DEFAULT 0,
    RGPD_Fecha DATETIME2 NULL,
    Fecha_Inicio DATETIME2
		GENERATED ALWAYS AS ROW START NOT NULL,
	Fecha_Fin DATETIME2
		GENERATED ALWAYS AS ROW END NOT NULL,
	
    PERIOD FOR SYSTEM_TIME
		(Fecha_Inicio, Fecha_Fin)
)
WITH
(
	SYSTEM_VERSIONING = ON
	(
		HISTORY_TABLE = dbo.Proveedores_Historico
	)
);
GO

INSERT INTO Proveedores
(
    Empresa,
    ContactoNombre,
    ContactoApellido1,
    ContactoApellido2,
    ContactoTel,
    ContactoEmail,
    NIF,
    DireccionProveedor,
    CodigoPostal,
    Ciudad,
    Provincia,
    Notas,
    RGPD_Autoriza,
    RGPD_Fecha
)
VALUES
('Los Gemelos', 'Juan José', 'Escribano', 'Cabello', '677528478', NULL, '1816363F', 'Lago Maracaibo 13 D', '28018', 'Madrid', 'Madrid', 'Saco 1m3 - www.sacoslosgemelos.com', 0, NULL),
('Saltoki', 'Daniel', 'García', 'Velasco', '606582493', 'dgarciav@saltoki.es', 'A82825456', 'Calle Río Bembezar 4', '28906', 'Getafe', 'Madrid', 'www.saltoki.es', 1, '2025-07-27'),
('Dormitorum', NULL, NULL, NULL, '600999897', NULL, NULL, 'Av. Rey Juan Carlos I 69', '28916', 'Leganés', 'Madrid', 'www.dormitorum.es', 1, '2025-10-06'),
('Bosch España', NULL, NULL, NULL, '976305713', NULL, NULL, NULL, NULL, NULL, NULL, 'www.bosch-home.es', 0, NULL),
('IKEA', NULL, NULL, NULL, '900400922', NULL, NULL, NULL, NULL, 'Leganés', 'Madrid', NULL, 0, NULL),
('PVC3', 'Verónica', 'García', 'Díaz', '925513637', 'pvc3@pvc3.com', NULL, 'Calle Nuevo Toledo 19', '45200', 'Illescas', 'Toledo', NULL, 1, '2025-07-15'),
('JCMLsoluciones.es', 'Fransuani', 'Álvarez', NULL, '602654868', NULL, 'B19963594', 'Calle de las Dehesillas 2 Local 1', '28981', 'Parla', 'Madrid', 'Contratista', 1, '2025-06-20');
GO

SELECT * FROM Proveedores;
GO

/*
ALTER TABLE Proveedores
SET (SYSTEM_VERSIONING = OFF);
GO

DROP TABLE Proveedores;
GO

DROP TABLE Proveedores_Historico;
GO
*/


-- ==========================================================================
-- 3. TABLA CATEGORIAS_ACTIVIDADES
-- ==========================================================================

CREATE TABLE Categorias_Actividades
(
    COD_Categoria_Act INT IDENTITY(1,1)
        CONSTRAINT PK_Categorias_Actividades
        PRIMARY KEY,
    Categoria_Act NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Categorias_Plan
        UNIQUE,
    Activada BIT NOT NULL
        CONSTRAINT DF_Categorias_Actividades_Activada DEFAULT 1
);
GO

INSERT INTO Categorias_Actividades
(
    Categoria_Act,
    Activada
)
VALUES
('Mantenimiento', 1),
('Inspección', 1),
('Instalación', 1),
('Limpieza', 1),
('Sustitución', 1),
('Reforma', 0);
GO

SELECT * FROM Categorias_Actividades;
GO

/*
DROP TABLE Categorias_Actividades
*/


-- ==========================================================================
-- 4. TABLA ESTADOS_ACTIVIDADES
-- ==========================================================================

CREATE TABLE Estados_Actividades
(
    COD_Estado_Act INT IDENTITY(1,1)
        CONSTRAINT PK_Estados_Actividades
        PRIMARY KEY,
    Estado_Act NVARCHAR(50) NOT NULL
        CONSTRAINT UQ_Estado_Act
        UNIQUE,
    Activado BIT
        CONSTRAINT DF_Estados_Actividades_Activado DEFAULT 1,
    Orden INT NOT NULL
);
GO

INSERT INTO Estados_Actividades
(
    Estado_Act,
    Activado,
    Orden
)
VALUES
('Pendiente', 1, 1),
('Programado', 1, 2),
('En curso', 1, 3),
('Finalizado', 1, 4),
('Cancelado', 1, 5),
('Aplazado', 1, 6);
GO

SELECT * FROM Estados_Actividades;
GO

/*
DROP TABLE Estados_Actividades
*/

-- ==========================================================================
-- 5. TABLA ESTADOS_PRESUPUESTOS
-- ==========================================================================

CREATE TABLE Estados_Presupuestos
(
    COD_Estado_Pre INT IDENTITY(1,1)
        CONSTRAINT PK_Estados_Presupuestos
        PRIMARY KEY,
    Estado_Pre NVARCHAR(50) NOT NULL
        CONSTRAINT UQ_Estados
        UNIQUE,
    Activado BIT
        CONSTRAINT DF_Estados_Presupuestos_Activado DEFAULT 1,
    Orden INT NOT NULL
);
GO

INSERT INTO Estados_Presupuestos
(
    Estado_Pre,
    Activado,
    Orden
)
VALUES
('Solicitado', 1, 1),
('Entregado', 1, 2),
('En revisión', 1, 3),
('Aceptado', 1, 4),
('Rechazado', 1, 5),
('Postergado', 1, 6);
GO

SELECT * FROM Estados_Presupuestos;
GO

/*
DROP TABLE Estados_Presupuestos
*/

-- ==========================================================================
-- 6. TABLA TIPOS_PROPIEDADES
-- ==========================================================================

CREATE TABLE Tipos_Propiedades
(
    COD_Tipo_Propiedad INT IDENTITY(1,1)
        CONSTRAINT PK_Tipos_Propiedades
        PRIMARY KEY,
    Tipo_Propiedad NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Tipo_Propiedad
        UNIQUE,
    Prefijo_Propiedad VARCHAR(3) NOT NULL
        CONSTRAINT UQ_Prefijo_Propiedad
        UNIQUE,
    Descripcion NVARCHAR(300) NULL,
    Activado BIT NOT NULL
        CONSTRAINT DF_Tipos_Propiedades_Activado DEFAULT 1
);
GO

INSERT INTO Tipos_Propiedades
(
    Tipo_Propiedad,
    Prefijo_Propiedad,
    Descripcion,
    Activado
)
VALUES
('Piso', 'PSO', 'Vivienda situada en un edificio residencial', 1),
('Chalet', 'CHL', 'Vivienda unifamiliar independiente o pareada', 1),
('Casa', 'CSA', 'Vivienda unifamiliar', 1),
('Apartamento', 'APT', 'Vivienda de dimensiones reducidas', 1),
('Oficina', 'OFI', 'Espacio destinado a actividades profesionales', 1),
('Local comercial', 'LOC', 'Espacio destinado a actividades comerciales', 1),
('Espacio efimero', 'EFM', 'Espacio temporal destinado a eventos, comercio o actividades', 1),
('Nave industrial', 'IND', 'Espacio destinado a actividades industriales', 1),
('Edificio', 'EDF', 'Inmueble compuesto por varias unidades o espacios', 1),
('Garaje', 'GAR', 'Espacio destinado al estacionamiento de vehículos', 0);
GO


SELECT * FROM Tipos_Propiedades;
GO

/*
DROP TABLE Tipos_Propiedades
*/


/***************************************/




-- ==========================================================================
-- 7. TABLA PROPIEDADES
-- ==========================================================================

CREATE TABLE Propiedades
(
    COD_Propiedad INT IDENTITY(1,1)
        CONSTRAINT PK_Propiedades
        PRIMARY KEY (COD_Propiedad),
    COD_TipoPropiedad INT NOT NULL
        CONSTRAINT FK_Propiedades_Tipos_Propiedad
        FOREIGN KEY (COD_TipoPropiedad)
        REFERENCES Tipos_Propiedad(COD_TipoPropiedad),
    RefPropiedad NVARCHAR(20) NULL,
    NombrePropiedad NVARCHAR(200) NULL,
    DireccionPropiedad NVARCHAR(300) NULL,
    CodigoPostal NVARCHAR(10) NULL,
    Ciudad NVARCHAR(200) NULL,
    Provincia NVARCHAR(200) NULL,
    COD_Cliente INT NOT NULL
        CONSTRAINT FK_Propiedades_Clientes
        FOREIGN KEY (COD_Cliente)
        REFERENCES Clientes(COD_Cliente)
);
GO

CREATE OR ALTER TRIGGER TR_Propiedades_GenerarRef
ON Propiedades
AFTER INSERT

AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
    SET RefPropiedad =
        TP.Prefijo + '-' +
        RIGHT('000' + CAST(P.COD_Propiedad AS VARCHAR(10)), 3)

    FROM Propiedades P
    INNER JOIN inserted I
        ON P.COD_Propiedad = I.COD_Propiedad
    INNER JOIN Tipos_Propiedad TP
        ON P.COD_TipoPropiedad = TP.COD_TipoPropiedad
    WHERE P.RefPropiedad IS NULL
END;
GO

INSERT INTO Propiedades
(
    COD_TipoPropiedad,
    NombrePropiedad,
    DireccionPropiedad,
    CodigoPostal,
    Ciudad,
    Provincia,
    COD_Cliente
)
VALUES
(4, NULL, 'Calle Madrid 23', NULL, 'Madrid', 'Madrid', 2),
(1, NULL, 'Lisboa 8', '28617', 'Getafe', 'Madrid', 1),
(2, 'Los Almendros', 'Ave Rey Juan Carlos I 17', '28045', 'Madrid', 'Madrid', 3),
(1, NULL, 'Carabelos 57', '28014', 'Madrid', 'Madrid', 1);
GO


SELECT * FROM Propiedades;
GO


-- ==========================================================================
-- 8. TABLA ESPACIOS
-- ==========================================================================


CREATE TABLE Espacios
(
    COD_Espacio INT IDENTITY(1,1)
        CONSTRAINT PK_Espacios
        PRIMARY KEY (COD_Espacio),
    NombreEspacio NVARCHAR(100) NOT NULL,
    Area DECIMAL(10,2) NULL,
    Volumen DECIMAL(10,2) NULL,
    Descripcion NVARCHAR(MAX) NULL,
    COD_Propiedad INT NOT NULL
        CONSTRAINT FK_Espacios_Propiedades
        FOREIGN KEY (COD_Propiedad)
        REFERENCES Propiedades(COD_Propiedad)
);
GO

INSERT INTO Espacios
(
    NombreEspacio,
    Area,
    Volumen,
    Descripcion,
    COD_Propiedad
)
VALUES
('Salón', 25.5, 63.75, NULL, 1),
('Cocina', 12, 30, 'Tipo americana', 1),
('Dormitorio principal', 15, 37.5, 'Con armario empotrado', 1),
('Dormitorio 1', 17.3, 43.25, NULL, 2),
('Dormitorio 2', 13.2, 33, NULL, 2),
('Aseo', 3.5, 8.75, NULL, 2),
('Baño', 6, 15, NULL, 2),
('Cocina', 12, 30, NULL, 3),
('Salón', 23.4, 58.5, NULL, 3),
('Despacho', 16.8, 42, NULL, 3);
GO

SELECT * FROM Espacios;
GO

/* Consulta para ver a qué propiedad pertenece cada espacio:
SELECT
    E.COD_Espacio,
    E.NombreEspacio,
    E.Area,
    E.Volumen,
    E.Descripcion,
    E.COD_Propiedad,
    P.RefPropiedad
FROM Espacios E
INNER JOIN Propiedades P
    ON E.COD_Propiedad = P.COD_Propiedad
ORDER BY E.COD_Propiedad, E.COD_Espacio;
GO*/

-- ==========================================================================
-- 9. TABLA SISTEMAS_SERVICIOS
-- ==========================================================================

CREATE TABLE Sistemas_Servicios
(
    COD_Sistema INT IDENTITY(1,1)
        CONSTRAINT PK_Sistemas_Servicios
        PRIMARY KEY (COD_Sistema),
    NombreSistema NVARCHAR(200) NOT NULL,
    DatosTecnicos XML NULL,
    Notas NVARCHAR(MAX) NULL,
    FechaInstalacion DATETIME2 NULL,
    COD_Proveedor INT NOT NULL
        CONSTRAINT FK_Sistemas_Proveedores
        FOREIGN KEY (COD_Proveedor)
        REFERENCES Proveedores(COD_Proveedor),
    COD_Espacio INT NOT NULL
        CONSTRAINT FK_Sistemas_Espacios
        FOREIGN KEY (COD_Espacio)
        REFERENCES Espacios(COD_Espacio)
);
GO

INSERT INTO Sistemas_Servicios
(
    NombreSistema,
    DatosTecnicos,
    Notas,
    FechaInstalacion,
    COD_Proveedor,
    COD_Espacio
)
VALUES
('Recuperador de calor', null, 'SIBER',  '20260820', 2, 9)
;
GO

SELECT * FROM Sistemas_Servicios;
GO

UPDATE Sistemas_Servicios
SET DatosTecnicos =
    '<Sistema>
        <Marca>SIBER</Marca>
        <Modelo>DF EVO 2</Modelo>
        <Tipo>Recuperador de calor</Tipo>
        <Caracteristicas>
            <CaudalMax>200 m3/h</CaudalMax>
            <Domotica>Conectividad mediante KNX - Modbus</Domotica>
            <ClaseFiltro>Coarse 65% (G4)</ClaseFiltro>
        </Caracteristicas>
    </Sistema>'
WHERE COD_Sistema = 1;
GO

/*Consulta para recuperar la marca:
SELECT
    COD_Sistema,
    NombreSistema,
    DatosTecnicos.value(
        '(/Sistema/Marca/text())[1]',
        'NVARCHAR(100)'
    )
AS Marca
FROM Sistemas_Servicios;
GO*/


-- ==========================================================================
-- 10. TABLA PLANIFICACION
-- ==========================================================================

CREATE TABLE Planificacion
(
    COD_Actividad INT IDENTITY(1,1)
        CONSTRAINT PK_Planificacion
        PRIMARY KEY (COD_Actividad),
    Actividad NVARCHAR(200) NOT NULL,
    COD_Categoria INT NOT NULL
        CONSTRAINT FK_Planificacion_Categorias
        FOREIGN KEY (COD_Categoria)
        REFERENCES Categorias(COD_Categoria),
    COD_Estado INT NOT NULL
        CONSTRAINT FK_Planificacion_Estados
        FOREIGN KEY (COD_Estado)
        REFERENCES Estados(COD_Estado),
    FechaInicial DATETIME2 NULL,
    FechaFinal DATETIME2 NULL,
    ProxRecordatorio DATETIME2 NULL,
    COD_Propiedad INT NOT NULL
        CONSTRAINT FK_Planificacion_Propiedades
        FOREIGN KEY (COD_Propiedad)
        REFERENCES Propiedades(COD_Propiedad),
    COD_Sistema INT NULL
        CONSTRAINT FK_Planificacion_Sistemas
        FOREIGN KEY (COD_Sistema)
        REFERENCES Sistemas_Servicios(COD_Sistema),
    COD_Espacio INT NULL
        CONSTRAINT FK_Planificacion_Espacios
        FOREIGN KEY (COD_Espacio)
        REFERENCES Espacios(COD_Espacio)    
);
GO

INSERT INTO Planificacion
(
     Actividad,
     COD_Categoria, 
     COD_Estado,
     FechaInicial,
     FechaFinal,
     ProxRecordatorio,
     COD_Propiedad,
     COD_Sistema,
     COD_Espacio
)
VALUES
(
    'Cambio de filtros', 5, 2, '20261001', '20261001', '20270315', 1, 1, 8
);
GO

SELECT * FROM Planificacion;
GO


-- ==========================================================================
-- 11. TABLA DOCUMENTOS
-- ==========================================================================

CREATE TABLE Documentos
(
    COD_Documento INT IDENTITY(1,1)
        CONSTRAINT PK_Documentos
        PRIMARY KEY (COD_Documento),
    TipoDocumento NVARCHAR(50) NOT NULL,
    URL_Documento NVARCHAR(4000) NULL,
    COD_Actividad INT NULL
        CONSTRAINT FK_Documentos_Actividades
        FOREIGN KEY (COD_Actividad)
        REFERENCES Planificacion(COD_Actividad),
    COD_Sistema INT NOT NULL
        CONSTRAINT FK_Documentos_Sistemas
        FOREIGN KEY (COD_Sistema)
        REFERENCES Sistemas_Servicios(COD_Sistema)
);
GO


INSERT INTO Documentos
(
    TipoDocumento,
    URL_Documento,
    COD_Actividad,
    COD_Sistema
)
VALUES
('Ficha técnica', 'https://drive.google.com/file/d/1-XTAVVK0gIGJFhcizQ2dAVrzQothN-dm/view?usp=sharing', null, 1),
('Ficha técnica', 'https://drive.google.com/file/d/1stBMSeuwY69RS7OyLim7mubKe4k32e0u/view?usp=sharing', 1, 1);
GO


SELECT * FROM Documentos;
GO

-- ==========================================================================
-- 12. TABLA PRESUPUESTO
-- ==========================================================================

CREATE TABLE Presupuestos
(
    COD_Presupuesto INT IDENTITY(1,1)
        CONSTRAINT PK_Presupuesto
        PRIMARY KEY (COD_Presupuesto),
    Descripcion NVARCHAR(300) NOT NULL,
    Cantidad DECIMAL(8,2) NULL
        CONSTRAINT CK_Presupuesto_Cantidad
        CHECK (Cantidad >= 0),
    Precio DECIMAL(12,2) NULL
        CONSTRAINT CK_Presupuesto_Precio
        CHECK (Precio >= 0),
    ImporteTotal AS
        (CONVERT(DECIMAL(14,2), Cantidad * Precio)) PERSISTED,
    COD_Estado INT NOT NULL
        CONSTRAINT FK_Presupuestos_Estados
        FOREIGN KEY (COD_Estado)
        REFERENCES Estados(COD_Estado),
    TiendaOnline NVARCHAR(4000) NULL,
    COD_Documento INT NULL
        CONSTRAINT FK_Presupuesto_Documentos
        FOREIGN KEY (COD_Documento)
        REFERENCES Documentos(COD_Documento),
    COD_Propiedad INT NOT NULL
        CONSTRAINT FK_Presupuesto_Propiedades
        FOREIGN KEY (COD_Propiedad)
        REFERENCES Propiedades(COD_Propiedad)
);
GO


INSERT INTO Presupuestos
(
    Descripcion,
    Cantidad,
    Precio,
    COD_Estado,
    TiendaOnline,
    COD_Documento,
    COD_Propiedad
)
VALUES
('FILTRO COMBINADO G4/F7 (COARSE 65% + EPM1 55%)', 1, (72.11*1.21), 3, 'https://www.siberzone.es/tienda/filtro-combinado-g4f7-coarse-65-epm155', 2, 2)
;
GO

SELECT * FROM Presupuestos;
GO

-- ==========================================================================
-- 13. TABLA TIPOS_DOCUMENTOS
-- ==========================================================================


