/* ******************************************************************
        PROYECTO DE BASES DE DATOS
        MICROSOFT SQL SERVER - CMICE GETAFE

        ALEJANDRA VAQUERO CASTRO
        26 NOVIEMBRE 2026

        iHome 
        Gestión y mantenimiento inteligente de espacios
******************************************************************* */

-- ===================================================================
--      1. CREACIÓN DE LA BASE DE DATOS
-- ===================================================================

CREATE DATABASE iHome;
GO

USE iHome;
GO

-- ===================================================================
--      2. CREACIÓN DE TABLAS E INSERCIÓN DE DATOS DE PRUEBA
-- ===================================================================
-- -------------------------------------------------------------------
--      2.1. CLIENTES
-- -------------------------------------------------------------------

CREATE TABLE Clientes
(
    COD_Cliente INT IDENTITY(1,1)
        CONSTRAINT PK_Clientes PRIMARY KEY,
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
        CONSTRAINT DF_CLIENTES_RGPD_Autoriza DEFAULT 0,
    RGPD_Fecha DATETIME2 NULL,
	RegistroInicial DATETIME2
        GENERATED ALWAYS AS ROW START NOT NULL,
	RegistroFinal DATETIME2
		GENERATED ALWAYS AS ROW END NOT NULL,
	
    PERIOD FOR SYSTEM_TIME
		(RegistroInicial, RegistroFinal)
)
WITH
(
	SYSTEM_VERSIONING = ON
	(HISTORY_TABLE = dbo.Clientes_Historico)
);
GO

-- DNI/NIF único aunque tengamos varios valores NULL
CREATE UNIQUE INDEX UX_CLIENTES_DNI_NIF
ON CLIENTES (DNI_NIF)
WHERE DNI_NIF IS NOT NULL;
GO


INSERT INTO CLIENTES
    (ContactoNombre,
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
    RGPD_Fecha)
VALUES
    ('Vera', 'Castro', 'Gutiérrez', '672958367', 'veracastro@gmail.com', '61234678Y',
    'Calle Madrid', '28041', 'Madrid', 'Madrid', 1, '2023-09-02'),
    ('Javier', 'Sánchez', 'Rivera', '689463778', 'javiersanchez@gmail.com', '87632816T',
    'Calle Lisboa', '28014', 'Leganés', 'Madrid', 1, '2022-04-17'),
    ('Francisco', 'Vaquero', 'Castro', '645277890', 'franciscovaquero@gmail.com', '47284617D',
    'Avenida Fuenlabrada', '28911', 'Málaga', 'Málaga', 0, NULL);
GO

SELECT * FROM Clientes;
GO



-- -------------------------------------------------------------------
--      2.2. PROVEEDORES
-- -------------------------------------------------------------------

CREATE TABLE Proveedores
(
    COD_Proveedor INT IDENTITY(1,1)
        CONSTRAINT PK_Proveedores PRIMARY KEY,
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
        CONSTRAINT DF_PROVEEDORES_RGPD_Autoriza DEFAULT 0,
    RGPD_Fecha DATETIME2 NULL,
    RegistroInicial DATETIME2
		GENERATED ALWAYS AS ROW START NOT NULL,
	RegistroFinal DATETIME2
		GENERATED ALWAYS AS ROW END NOT NULL,
	
    PERIOD FOR SYSTEM_TIME
		(RegistroInicial, RegistroFinal)
)
WITH
(
	SYSTEM_VERSIONING = ON
	(HISTORY_TABLE = dbo.Proveedores_Historico)
);
GO

-- NIF único aunque tengamos varios valores NULL
CREATE UNIQUE INDEX UX_PROVEEDORES_NIF
ON PROVEEDORES (NIF)
WHERE NIF IS NOT NULL;
GO


INSERT INTO PROVEEDORES
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
    ('Los Gemelos', 'Juan José', 'Escribano', 'Cabello', '677528478', NULL,
    '1816363F', 'Lago Maracaibo 13 D', '28018', 'Madrid', 'Madrid',
    'Saco 1m3 - www.sacoslosgemelos.com', 0, NULL),
    ('Saltoki', 'Daniel', 'García', 'Velasco', '606582493', 'dgarciav@saltoki.es',
    'A82825456', 'Calle Río Bembezar 4', '28906', 'Getafe', 'Madrid',
    'www.saltoki.es', 1, '2025-07-27'),
    ('Dormitorum', NULL, NULL, NULL, '600999897', NULL,
    NULL, 'Av Rey Juan Carlos I 69', '28916', 'Leganés', 'Madrid',
    'www.dormitorum.es', 1, '2025-10-06'),
    ('Bosch España', NULL, NULL, NULL, '976305713', NULL,
    NULL, NULL, NULL, NULL, NULL,
    'www.bosch-home.es', 0, NULL),
    ('IKEA', NULL, NULL, NULL, '900400922', NULL,
    NULL, NULL, NULL, 'Leganés', 'Madrid',
    NULL, 0, NULL),
    ('PVC3', 'Verónica', 'García','Díaz', '925513637', 'pvc3@pvc3.com',
    NULL, 'Calle Nuevo Toledo 19', '45200', 'Illescas', 'Toledo',
    NULL, 1, '2025-07-15'),
    ('JCMLsoluciones.es', 'Fransuani', 'Álvarez', NULL, '602654868', NULL,
    'B19963594', 'Calle de las Dehesillas 2 Local 1', '28981', 'Parla', 'Madrid',
    'Contratista', 1, '2025-06-20');
GO

SELECT * FROM Proveedores;
GO


-- -------------------------------------------------------------------
--      2.3. ESTADOS_PLANIFICACION 
-- -------------------------------------------------------------------

CREATE TABLE Estados_Planificacion
(
    COD_EstadoPlan INT IDENTITY(1,1)
        CONSTRAINT PK_Estados_Planificacion PRIMARY KEY,
    EstadoPlan NVARCHAR(30) NOT NULL
        CONSTRAINT UQ_Estados_Planificacion_EstadoPlan UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Estados_Planificacion_Activo DEFAULT 1,
    Orden INT NOT NULL
);
GO

INSERT INTO Estados_Planificacion
(EstadoPlan, Orden)
VALUES
    ('PENDIENTE', 1),
    ('PROGRAMADO', 2),
    ('EN CURSO', 3),
    ('FINALIZADO', 4),
    ('CANCELADO', 5),
    ('APLAZADO', 6);
GO

SELECT *
FROM Estados_Planificacion
ORDER BY Orden;
GO




-- -------------------------------------------------------------------
--      2.4. ESTADOS_PRESUPUESTOS
-- -------------------------------------------------------------------

CREATE TABLE Estados_Presupuestos
(
    COD_EstadoPresu INT IDENTITY(1,1)
        CONSTRAINT PK_Estados_Presupuestos PRIMARY KEY,
    EstadoPresu NVARCHAR(30) NOT NULL
        CONSTRAINT UQ_Estados_Presupuestos_EstadoPresu UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Estados_Presupuestos_Activo DEFAULT 1,
    Orden INT NOT NULL
);
GO

INSERT INTO Estados_Presupuestos
(EstadoPresu,Orden)
VALUES
    ('RECIBIDO', 1),
    ('ENTREGADO', 2),
    ('EN REVISIÓN', 3),
    ('ACEPTADO', 4),
    ('RECHAZADO', 5),
    ('POSTERGADO', 6);
GO

SELECT *
FROM Estados_Presupuestos
ORDER BY Orden;
GO



-- -------------------------------------------------------------------
--      2.5. CATEGORIAS_SERVICIOS
-- -------------------------------------------------------------------

CREATE TABLE Categorias_Servicios
(
    COD_CatServicio INT IDENTITY(1,1)
        CONSTRAINT PK_Categorias_Servicios PRIMARY KEY,
    CatServicio NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Categorias_Servicios_CatServicio UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Categorias_Servicios_Activo DEFAULT 1
);
GO

INSERT INTO Categorias_Servicios
(CatServicio)
VALUES
    ('ACABADOS'), ('CARPINTERIA'), ('CONSERVACION'), ('CONSTRUCCION'),
    ('GESTION'), ('INSTALACION'), ('LIMPIEZA'), ('LOGISTICA'),
    ('MANTENIMIENTO'), ('PROFESIONAL'), ('REFORMA'), ('REPARACION'),
    ('SUSTITUCION'), ('TECNICO');
GO

SELECT *
FROM Categorias_Servicios
ORDER BY CatServicio;
GO



-- -------------------------------------------------------------------
--      2.6. CATEGORIAS_SISTEMAS
-- -------------------------------------------------------------------

CREATE TABLE Categorias_Sistemas
(
    COD_CatSistema INT IDENTITY(1,1)
        CONSTRAINT PK_Categorias_Sistemas PRIMARY KEY,
    CatSistema NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Categorias_Sistemas_CatSistema UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Categorias_Sistemas_Activo DEFAULT 1
);
GO

INSERT INTO Categorias_Sistemas
(CatSistema)
VALUES
    ('CLIMATIZACION_VENTILACION'),
    ('CONSTRUCTIVOS'),
    ('ELECTRICIDAD_ILUMINACION'),
    ('ELECTRODOMESTICOS_EQUIPAMIENTO'),
    ('FONTANERIA_SANEAMIENTO'),
    ('SEGURIDAD_CONTROL'),
    ('TELECOMUNICACIONES');
GO

SELECT *
FROM Categorias_Sistemas
ORDER BY CatSistema;
GO



-- -------------------------------------------------------------------
--      2.7. TIPOS_ACTIVIDADES
-- -------------------------------------------------------------------

CREATE TABLE Tipos_Actividades
(
    COD_TipoActividad INT IDENTITY(1,1)
        CONSTRAINT PK_Tipos_Actividades PRIMARY KEY,
    TipoActividad NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Tipos_Actividades_TipoActividad UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Tipos_Actividades_Activo DEFAULT 1
);
GO

INSERT INTO Tipos_Actividades
(TipoActividad)
VALUES
    ('ALMACENAR'), ('ANALIZAR'), ('COBRAR'), ('COMPRAR'), ('COMPROBAR'),
    ('CONTACTAR'), ('COORDINAR'), ('CITAR'), ('COTIZAR'), ('DISEÑAR'),
    ('DOCUMENTAR'), ('EJECUTAR'), ('ENTREGAR'), ('ENVIAR'), ('INSPECCIONAR'),
    ('INSTALAR'), ('LIMPIAR'), ('MEDIR'), ('MODIFICAR'), ('NOTIFICAR'),
    ('ORGANIZAR'), ('PAGAR'), ('PINTAR'), ('PLANIFICAR'), ('PRESUPUESTAR'),
    ('RECOGER'), ('REPARAR'), ('REVISAR'), ('SOLICITAR'), ('SUPERVISAR'),
    ('SUSTITUIR'), ('TRAMITAR'), ('VERIFICAR'), ('VISITAR');
GO
    

SELECT *
FROM Tipos_Actividades
ORDER BY TipoActividad;
GO




-- -------------------------------------------------------------------
--      2.8. TIPOS_DOCUMENTOS
-- -------------------------------------------------------------------

CREATE TABLE Tipos_Documentos
(
    COD_TipoDoc INT IDENTITY(1,1)
        CONSTRAINT PK_Tipos_Documentos PRIMARY KEY,
    TipoDoc NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Tipos_Documentos_TipoDoc UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Tipos_Documentos_Activo DEFAULT 1
);
GO

INSERT INTO Tipos_Documentos
(TipoDoc)
VALUES
    ('ACTA'), ('ALBARAN'), ('AUTORIZACION'), ('BOLETIN'), ('CATALOGO'),
    ('CARPETA'), ('CERTIFICADO'), ('CONTRATO'), ('DECLARACION_RESPONSABLE'),
    ('FACTURA'), ('FACTURA_PROFORMA'), ('FACTURA_RECTIFICATIVA'),
    ('FICHA_TECNICA'), ('FOTOGRAFIAS'), ('GARANTIA'), ('INFORME_TECNICO'),
    ('JUSTIFICANTE_PAGO'), ('LICENCIA'), ('MANUAL'), ('MEMORIA_TECNICA'),
    ('ORDEN_COMPRA'), ('ORDEN_TRABAJO'), ('PLANOS'), ('PRESUPUESTO'),
    ('RECIBO'), ('RGPD');
GO

SELECT *
FROM Tipos_Documentos
ORDER BY TipoDoc;
GO



-- -------------------------------------------------------------------
--      2.9. TIPOS_ESPACIOS
-- -------------------------------------------------------------------

CREATE TABLE Tipos_Espacios
(
    COD_TipoEspacio INT IDENTITY(1,1)
        CONSTRAINT PK_Tipos_Espacios PRIMARY KEY,
    TipoEspacio NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Tipos_Espacios_TipoEspacio UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Tipos_Espacios_Activo DEFAULT 1
);
GO

INSERT INTO Tipos_Espacios
(TipoEspacio,Activo)
VALUES
    ('ACCESO', 1), ('ALMACEN', 1), ('AZOTEA', 1), ('BAÑO', 1),
    ('COCINA', 1), ('COMEDOR', 1), ('CUARTO_CALDERAS', 1),
    ('CUARTO_CONTADORES', 1), ('CUARTO_ELECTRICO', 1),
    ('DESPACHO', 1), ('DORMITORIO', 1), ('GARAJE', 0),
    ('OFICINA', 1), ('PASILLO', 1), ('PATIO', 1), ('PORTAL', 1),
    ('SALON', 1), ('SALA_TECNICA', 1), ('TALLER', 1),
    ('TERRAZA', 1), ('TRASTERO', 1), ('VESTIDOR', 1);
GO

SELECT *
FROM Tipos_Espacios
ORDER BY TipoEspacio;
GO



-- -------------------------------------------------------------------
--      2.10. TIPOS_PROPIEDADES
-- -------------------------------------------------------------------

CREATE TABLE Tipos_Propiedades
(
    COD_TipoPropiedad INT IDENTITY(1,1)
        CONSTRAINT PK_Tipos_Propiedades PRIMARY KEY,
    TipoPropiedad NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Tipos_Propiedades_TipoPropiedad UNIQUE,
    PrefijoPropiedad NVARCHAR(3) NOT NULL
        CONSTRAINT UQ_Tipos_Propiedades_Prefijo UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Tipos_Propiedades_Activo DEFAULT 1
);
GO

INSERT INTO Tipos_Propiedades
(TipoPropiedad, PrefijoPropiedad, Activo)
VALUES
    ('APARTAMENTO', 'APT', 1),
    ('CASA', 'CSA', 1),
    ('CHALET', 'CHL', 1),
    ('COMERCIAL', 'CMR', 1),
    ('EDIFICIO', 'EDF', 1),
    ('EFIMERO', 'EFM', 1),
    ('GARAJE', 'GAR', 0),
    ('INDUSTRIAL', 'IND', 1),
    ('OFICINA', 'OFI', 1),
    ('PISO', 'PSO', 1);
GO

SELECT *
FROM Tipos_Propiedades
ORDER BY TipoPropiedad;
GO



-- -------------------------------------------------------------------
--      2.11. TIPOS_SERVICIOS
-- -------------------------------------------------------------------

CREATE TABLE Tipos_Servicios
(
    COD_TipoServicio INT IDENTITY(1,1)
        CONSTRAINT PK_Tipos_Servicios PRIMARY KEY,
    COD_CatServicio INT NOT NULL
        CONSTRAINT FK_Tipos_Servicios_Categorias FOREIGN KEY
        REFERENCES Categorias_Servicios,
    TipoServicio NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Tipos_Servicios_TipoServicio UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Tipos_Servicios_Activo DEFAULT 1
);
GO

-- SEGURIDAD será el único tipo de servicio desactivado
INSERT INTO Tipos_Servicios
(COD_CatServicio, TipoServicio, Activo)
SELECT
    C.COD_CatServicio,
    V.TipoServicio,
    CASE
        WHEN V.TipoServicio = N'SEGURIDAD' THEN 0
        ELSE 1
    END
FROM
(
    VALUES
        (N'ACABADOS', N'PINTURA'),
        (N'ACABADOS', N'REVESTIMIENTOS'),

        (N'CARPINTERIA', N'CARPINTERIA'),
        (N'CARPINTERIA', N'CERRAJERIA'),
        (N'CARPINTERIA', N'MONTAJE_MOBILIARIO'),

        (N'CONSERVACION', N'INSPECCION_PROPIEDAD'),

        (N'CONSTRUCCION', N'AISLAMIENTO_ACUSTICO'),
        (N'CONSTRUCCION', N'AISLAMIENTO_TERMICO'),
        (N'CONSTRUCCION', N'IMPERMEABILIZACION'),

        (N'GESTION', N'GESTION_COMPRAS'),
        (N'GESTION', N'GESTION_GARANTIAS'),
        (N'GESTION', N'GESTION_LICENCIAS'),
        (N'GESTION', N'GESTION_PERMISOS'),
        (N'GESTION', N'GESTION_RESIDUOS'),

        (N'INSTALACION', N'CLIMATIZACION'),
        (N'INSTALACION', N'CONDUCTOS'),
        (N'INSTALACION', N'DOMOTICA'),
        (N'INSTALACION', N'ELECTRICIDAD'),
        (N'INSTALACION', N'ELECTRODOMESTICOS'),
        (N'INSTALACION', N'FOTOVOLTAICA'),
        (N'INSTALACION', N'FONTANERIA'),
        (N'INSTALACION', N'INSTALACION_PERSIANAS'),
        (N'INSTALACION', N'TELECOMUNICACIONES'),

        (N'LOGISTICA', N'ALQUILER_MAQUINARIA'),
        (N'LOGISTICA', N'RETIRADA_EQUIPOS'),
        (N'LOGISTICA', N'SUMINISTRO_MATERIALES'),
        (N'LOGISTICA', N'TRANSPORTE_MATERIALES'),

        (N'MANTENIMIENTO', N'CORRECTIVO'),
        (N'MANTENIMIENTO', N'FILTROS'),
        (N'MANTENIMIENTO', N'PREDICTIVO'),
        (N'MANTENIMIENTO', N'PREVENTIVO'),

        (N'PROFESIONAL', N'ASESORAMIENTO_TECNICO'),
        (N'PROFESIONAL', N'CERTIFICACION_ENERGETICA'),
        (N'PROFESIONAL', N'COORDINACION_SEGURIDAD'),
        (N'PROFESIONAL', N'DIRECCION_FACULTATIVA'),
        (N'PROFESIONAL', N'DIRECCION_OBRA'),
        (N'PROFESIONAL', N'ELABORACION_PRESUPUESTOS'),
        (N'PROFESIONAL', N'ESTUDIO_VIABILIDAD'),
        (N'PROFESIONAL', N'LEVANTAMIENTO_PLANOS'),
        (N'PROFESIONAL', N'REDACCION_INFORMES'),
        (N'PROFESIONAL', N'REDACCION_PROYECTOS'),
        (N'PROFESIONAL', N'TASACIONES'),

        (N'REFORMA', N'REFORMA_INTEGRAL'),
        (N'REFORMA', N'REFORMA_PARCIAL'),

        (N'TECNICO', N'AUDITORIA_ENERGETICA'),
        (N'TECNICO', N'CERTIFICACION_INSTALACIONES'),
        (N'TECNICO', N'INSPECCION_TECNICA'),
        (N'TECNICO', N'MEDICIONES'),
        (N'TECNICO', N'VISITA_TECNICA'),

        (N'INSTALACION', N'SEGURIDAD')
) AS V (CatServicio, TipoServicio)
INNER JOIN Categorias_Servicios AS C
    ON C.CatServicio = V.CatServicio;
GO

-- Comprobar los registros
/* SELECT
    TS.COD_TipoServicio,
    CS.CatServicio,
    TS.TipoServicio,
    TS.Activo
FROM TIPOS_SERVICIOS AS TS
INNER JOIN CATEGORIAS_SERVICIOS AS CS
    ON TS.COD_CatServicio = CS.COD_CatServicio
ORDER BY
    CS.CatServicio,
    TS.TipoServicio;
GO */

SELECT * FROM TIPOS_SERVICIOS

-- -------------------------------------------------------------------
--      2.12. TIPOS_SISTEMAS
-- -------------------------------------------------------------------

CREATE TABLE Tipos_Sistemas
(
    COD_TipoSistema INT IDENTITY(1,1)
        CONSTRAINT PK_Tipos_Sistemas PRIMARY KEY,
    COD_CatSistema INT NOT NULL
        CONSTRAINT FK_Tipos_Sistemas_Categorias FOREIGN KEY
        REFERENCES CATEGORIAS_SISTEMAS,
    TipoSistema NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Tipos_Sistemas_TipoSistema UNIQUE,
    Activo BIT NOT NULL
        CONSTRAINT DF_Tipos_Sistemas_Activo DEFAULT 1
);
GO



-- ALARMA será el único tipo de sistema desactivado
INSERT INTO TIPOS_SISTEMAS
(COD_CatSistema, TipoSistema, Activo)
SELECT
    C.COD_CatSistema,
    V.TipoSistema,
    CASE
        WHEN V.TipoSistema = N'ALARMA' THEN 0
        ELSE 1
    END
FROM
(
    VALUES
        (N'CLIMATIZACION_VENTILACION', N'AEROTERMIA'),
        (N'CLIMATIZACION_VENTILACION', N'AIRE_ACONDICIONADO'),
        (N'CLIMATIZACION_VENTILACION', N'BOMBA_CALOR'),
        (N'CLIMATIZACION_VENTILACION', N'CALEFACCION'),
        (N'CLIMATIZACION_VENTILACION', N'RECUPERADOR_CALOR'),
        (N'CLIMATIZACION_VENTILACION', N'SUELO_RADIANTE'),
        (N'CLIMATIZACION_VENTILACION', N'VENTILACION_MECANICA'),

        (N'CONSTRUCTIVOS', N'CARPINTERIA'),
        (N'CONSTRUCTIVOS', N'IMPERMEABILIZACION'),

        (N'ELECTRICIDAD_ILUMINACION', N'INSTALACION_FOTOVOLTAICA'),

        (N'ELECTRODOMESTICOS_EQUIPAMIENTO', N'CAMPANA_EXTRACTORA'),
        (N'ELECTRODOMESTICOS_EQUIPAMIENTO', N'ELECTRODOMESTICO'),
        (N'ELECTRODOMESTICOS_EQUIPAMIENTO', N'TERMO_ELECTRICO'),

        (N'FONTANERIA_SANEAMIENTO', N'FILTRACION_AGUA'),
        (N'FONTANERIA_SANEAMIENTO', N'RIEGO_AUTOMATICO'),

        (N'SEGURIDAD_CONTROL', N'ALARMA'),
        (N'SEGURIDAD_CONTROL', N'CONTROL_ACCESO'),
        (N'SEGURIDAD_CONTROL', N'DETECCION_INCENDIOS'),

        (N'CLIMATIZACION_VENTILACION', N'FILTRACION_AIRE')
) AS V (CatSistema, TipoSistema)
INNER JOIN CATEGORIAS_SISTEMAS AS C
    ON C.CatSistema = V.CatSistema;
GO


-- Comprobar los registros
/* SELECT
    TS.COD_TipoSistema,
    CS.CatSistema,
    TS.TipoSistema,
    TS.Activo
FROM TIPOS_SISTEMAS AS TS
INNER JOIN CATEGORIAS_SISTEMAS AS CS
    ON TS.COD_CatSistema = CS.COD_CatSistema
ORDER BY
    CS.CatSistema,
    TS.TipoSistema;
GO */

select * from TIPOS_SISTEMAS


-- -------------------------------------------------------------------
--      2.13. PROPIEDADES
-- -------------------------------------------------------------------

CREATE TABLE Propiedades
(
    COD_Propiedad INT IDENTITY(1,1)
        CONSTRAINT PK_Propiedades PRIMARY KEY,
    COD_Cliente INT NOT NULL
        CONSTRAINT FK_Propiedades_Clientes FOREIGN KEY
        REFERENCES Clientes,
    COD_TipoPropiedad INT NOT NULL
        CONSTRAINT FK_Propiedades_Tipos FOREIGN KEY
        REFERENCES Tipos_Propiedades,
    RefPropiedad NVARCHAR(30) NULL,
    DireccionPropiedad NVARCHAR(300) NULL,
    CodigoPostal NVARCHAR(10) NULL,
    Ciudad NVARCHAR(200) NULL,
    Provincia NVARCHAR(200) NULL   
);
GO

-- crear referencia única cuando contiene un valor 
CREATE UNIQUE INDEX UX_Propiedades_RefPropiedad
ON Propiedades (RefPropiedad)
WHERE RefPropiedad IS NOT NULL;
GO

-- trigger para generar la referencia de propiedad automáticamente al insertar un nuevo registro 
-- puede insertar varias propiedades a la vez
CREATE TRIGGER TRG_Propiedades_RefPropiedad
ON Propiedades
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
    SET RefPropiedad = CONCAT(
        'C', I.COD_Cliente,
        '-', TP.PrefijoPropiedad,
        '-', I.COD_Propiedad
    )
    FROM Propiedades AS P
    INNER JOIN INSERTED AS I
        ON P.COD_Propiedad = I.COD_Propiedad
    INNER JOIN Tipos_Propiedades AS TP
        ON I.COD_TipoPropiedad = TP.COD_TipoPropiedad;
END;
GO

INSERT INTO Propiedades
(
    COD_Cliente,
    COD_TipoPropiedad,
    DireccionPropiedad,
    CodigoPostal,
    Ciudad,
    Provincia
)
VALUES
    (2, 3, 'Calle Madrid 23', NULL, 'Madrid', 'Madrid'),
    (1, 1, 'Lisboa 8', '28617', 'Getafe', 'Madrid'),
    (3, 2, 'Ave Rey Juan Carlos I 17', '28045', 'Madrid', 'Madrid'),
    (1, 1, 'Carabelos 57', '28014', 'Madrid', 'Madrid');
GO


/* SELECT
    P.COD_Propiedad,
    P.RefPropiedad,
    C.ContactoNombre,
    C.ContactoApellido1,
    TP.TipoPropiedad,
    P.DireccionPropiedad,
    P.CodigoPostal,
    P.Ciudad,
    P.Provincia
FROM PROPIEDADES AS P
INNER JOIN CLIENTES AS C
    ON P.COD_Cliente = C.COD_Cliente
INNER JOIN TIPOS_PROPIEDADES AS TP
    ON P.COD_TipoPropiedad = TP.COD_TipoPropiedad
ORDER BY P.COD_Propiedad;
GO */

select * from PROPIEDADES



-- -------------------------------------------------------------------
--      2.14. ESPACIOS
-- -------------------------------------------------------------------

CREATE TABLE Espacios
(
    COD_Espacio INT IDENTITY(1,1)
        CONSTRAINT PK_Espacios PRIMARY KEY,
    COD_Propiedad INT NOT NULL
        CONSTRAINT FK_Espacios_PROPIEDADES FOREIGN KEY
        REFERENCES PROPIEDADES,
    COD_TipoEspacio INT NOT NULL
        CONSTRAINT FK_Espacios_TIPOS FOREIGN KEY
        REFERENCES TIPOS_ESPACIOS,
    RefEspacio NVARCHAR(30) NULL,
    Area DECIMAL(10,2) NULL
        CONSTRAINT CK_Espacios_Area
        CHECK (Area IS NULL OR Area >= 0),
    Volumen DECIMAL(10,2) NULL
        CONSTRAINT CK_Espacios_Volumen
        CHECK (Volumen IS NULL OR Volumen >= 0)  
);
GO

-- Referencia única cuando contiene un valor
CREATE UNIQUE INDEX UX_Espacios_RefEspacio
ON Espacios (RefEspacio)
WHERE RefEspacio IS NOT NULL;
GO

-- importante permitir inserciones múltiples y generar una referencia para cada espacio
CREATE TRIGGER TRG_Espacios_RefEspacio
ON Espacios
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE E
    SET RefEspacio = CONCAT(
        'P', I.COD_Propiedad,
        '-', TE.TipoEspacio,
        '-', I.COD_Espacio
    )
    FROM Espacios AS E
    INNER JOIN INSERTED AS I
        ON E.COD_Espacio = I.COD_Espacio
    INNER JOIN TIPOS_ESPACIOS AS TE
        ON I.COD_TipoEspacio = TE.COD_TipoEspacio;
END;
GO

INSERT INTO ESPACIOS
(
    COD_Propiedad,
    COD_TipoEspacio,
    Area,
    Volumen
)
VALUES
    (2, 6, 18.00, 45.00), (2, 4, 4.50, 11.25), (2, 13, 9.00, 22.50),
    (1, 4, 6.00, 15.00), (1, 5, 16.00, 40.00), (3, 11, 14.00, 35.00),
    (3, 5, 12.00, 30.00), (3, 4, 5.00, 12.50), (3, 6, 20.00, 50.00);
GO

-- consulta de comprobación de los registros insertados
SELECT
    E.COD_Espacio,
    E.RefEspacio,
    E.COD_Propiedad,
    TP.TipoPropiedad,
    E.COD_TipoEspacio,
    TE.TipoEspacio,
    E.Area,
    E.Volumen
FROM Espacios AS E
INNER JOIN Propiedades AS P
    ON E.COD_Propiedad = P.COD_Propiedad
INNER JOIN Tipos_Propiedades AS TP
    ON P.COD_TipoPropiedad = TP.COD_TipoPropiedad
INNER JOIN TIPOS_ESPACIOS AS TE
    ON E.COD_TipoEspacio = TE.COD_TipoEspacio
ORDER BY
    E.COD_Propiedad,
    E.COD_Espacio;
GO

select * from ESPACIOS



-- -------------------------------------------------------------------
--      2.15. DOCUMENTOS
-- -------------------------------------------------------------------

CREATE TABLE Documentos
(
    COD_Doc INT IDENTITY(1,1)
        CONSTRAINT PK_Documentos PRIMARY KEY,
    COD_Propiedad INT NOT NULL
        CONSTRAINT FK_Documentos_Propiedades FOREIGN KEY
        REFERENCES Propiedades,
    COD_TipoDoc INT NOT NULL
        CONSTRAINT FK_Documentos_Tipos FOREIGN KEY
        REFERENCES Tipos_Documentos,
    RefDoc NVARCHAR(50) NULL,
    URL_Doc NVARCHAR(4000) NOT NULL,
);
GO

 
-- Referencia única cuando contiene un valor
CREATE UNIQUE INDEX UX_Documentos_RefDoc
ON Documentos (RefDoc)
WHERE RefDoc IS NOT NULL;
GO

-- trigger admite inserciones múltiples y genera una referencia para cada documento
CREATE TRIGGER TRG_Documentos_RefDoc
ON Documentos
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE D
    SET RefDoc = CONCAT(
        'P', I.COD_Propiedad,
        '-', TD.TipoDoc,
        '-', I.COD_Doc
    )
    FROM Documentos AS D
    INNER JOIN INSERTED AS I
        ON D.COD_Doc = I.COD_Doc
    INNER JOIN Tipos_Documentos AS TD
        ON I.COD_TipoDoc = TD.COD_TipoDoc;
END;
GO


INSERT INTO Documentos
(
    COD_Propiedad,
    COD_TipoDoc,
    URL_Doc
)
SELECT
    V.COD_Propiedad,
    TD.COD_TipoDoc,
    V.URL_Doc
FROM
(
    VALUES
    (
        1,
        N'CARPETA',
        N'https://drive.google.com/drive/folders/1la8GaonwtKXaj-9YakJkK_3XddA6WER4?usp=sharing'
    ),
    (
        1,
        N'FICHA_TECNICA',
        N'https://drive.google.com/file/d/1stBMSeuwY69RS7OyLim7mubKe4k32e0u/view?usp=sharing'
    )
) AS V (COD_Propiedad, TipoDoc, URL_Doc)
INNER JOIN Tipos_Documentos AS TD
    ON TD.TipoDoc = V.TipoDoc;
GO

/*
-- comprobar los registros insertados
SELECT
    D.COD_Doc,
    D.RefDoc,
    D.COD_Propiedad,
    P.RefPropiedad,
    TD.TipoDoc,
    D.URL_Doc
FROM DOCUMENTOS AS D
INNER JOIN PROPIEDADES AS P
    ON D.COD_Propiedad = P.COD_Propiedad
INNER JOIN TIPOS_DOCUMENTOS AS TD
    ON D.COD_TipoDoc = TD.COD_TipoDoc
ORDER BY D.COD_Doc;
GO */

SELECT * FROM Documentos;
GO

-- -------------------------------------------------------------------
--      2.16. SERVICIOS
-- -------------------------------------------------------------------


-- restricción de la tabla Espacios para que la clave foránea compuesta de la tabla Servicios funcione correctamente
ALTER TABLE Espacios
ADD CONSTRAINT UQ_Espacios_COD_Espacio_Propiedad
UNIQUE (COD_Espacio, COD_Propiedad);
GO


CREATE TABLE Servicios
(
    COD_Servicio INT IDENTITY(1,1)
        CONSTRAINT PK_Servicios PRIMARY KEY,
    COD_Propiedad INT NOT NULL
        CONSTRAINT FK_Servicios_Propiedades FOREIGN KEY
        REFERENCES Propiedades,
    COD_Espacio INT NULL
        CONSTRAINT FK_Servicios_Espacios
        FOREIGN KEY (COD_Espacio, COD_Propiedad)
        REFERENCES Espacios (COD_Espacio, COD_Propiedad),
    COD_Proveedor INT NOT NULL
        CONSTRAINT FK_Servicios_Proveedores FOREIGN KEY
        REFERENCES Proveedores,
    COD_TipoServicio INT NOT NULL
        CONSTRAINT FK_Servicios_Tipos FOREIGN KEY
        REFERENCES Tipos_Servicios,
    RefServicio NVARCHAR(30) NULL,
    Especificaciones XML NULL,
    COD_Doc INT NULL
        CONSTRAINT FK_Servicios_Documentos FOREIGN KEY
        REFERENCES Documentos
);
GO

-- Referencia única cuando contiene un valor
CREATE UNIQUE INDEX UX_Servicios_RefServicio
ON Servicios (RefServicio)
WHERE RefServicio IS NOT NULL;
GO

-- trigger admite inserciones múltiples y genera una referencia para cada servicio
CREATE TRIGGER TRG_Servicios_RefServicio
ON Servicios
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE S
    SET RefServicio = CONCAT(
        'PR', I.COD_Proveedor,
        '-TS', I.COD_TipoServicio,
        '-S', I.COD_Servicio
    )
    FROM Servicios AS S
    INNER JOIN INSERTED AS I
        ON S.COD_Servicio = I.COD_Servicio;
END;
GO

/* drop table Servicios

DROP TRIGGER IF EXISTS TRG_Servicios_RefServicio;
GO

SELECT *
FROM sys.triggers
WHERE name = 'TRG_Servicios_RefServicio';
GO */

INSERT INTO Servicios
(
    COD_Propiedad,
    COD_Espacio,
    COD_Proveedor,
    COD_TipoServicio,
    Especificaciones,
    COD_Doc
)
SELECT
    1,
    NULL,
    P.COD_Proveedor,
    TS.COD_TipoServicio,
    CAST(N'
    <Detalles>
        <Horario>Mañanas de 9:00h a 13:00h. Tardes de 16:00h a 19:00h</Horario>
        <Caracteristicas>Saco 1m3 37 euros IVA incluido</Caracteristicas>
    </Detalles>' AS XML),
    NULL
FROM Proveedores AS P
CROSS JOIN Tipos_Servicios AS TS
WHERE P.Empresa = N'Los Gemelos'
  AND TS.TipoServicio = N'SUMINISTRO_MATERIALES';
GO

INSERT INTO Servicios
    (COD_Propiedad,
    COD_Espacio,
    COD_Proveedor,
    COD_TipoServicio,
    Especificaciones,
    COD_Doc)
SELECT
    1,
    E.COD_Espacio,
    P.COD_Proveedor,
    TS.COD_TipoServicio,
    CAST(N'
    <Detalles>
        <Caracteristicas>
            FILTRO F7 (1 FIL. ISO EPM1 55%) PARA DFEVO 1/2,
            FILTRO G4 (1 FIL. COARSE 65%) PARA DFEVO 1/2
        </Caracteristicas>
    </Detalles>' AS XML),
    2
FROM Proveedores AS P
CROSS JOIN Tipos_Servicios AS TS
CROSS APPLY
(
    SELECT TOP (1)
        E1.COD_Espacio
    FROM Espacios AS E1
    INNER JOIN Tipos_Espacios AS TE
        ON E1.COD_TipoEspacio = TE.COD_TipoEspacio
    WHERE E1.COD_Propiedad = 1
      AND TE.TipoEspacio = N'COCINA'
    ORDER BY E1.COD_Espacio
) AS E
WHERE P.Empresa = N'Saltoki'
  AND TS.TipoServicio = N'FILTROS';
GO

-- comprobar los registros insertados
SELECT
    S.COD_Servicio,
    S.RefServicio,
    P.Empresa,
    TS.TipoServicio,
    S.COD_Propiedad,
    E.RefEspacio,
    TE.TipoEspacio,
    S.Especificaciones,
    S.COD_Doc
FROM Servicios AS S
INNER JOIN Proveedores AS P
    ON S.COD_Proveedor = P.COD_Proveedor
INNER JOIN Tipos_Servicios AS TS
    ON S.COD_TipoServicio = TS.COD_TipoServicio
LEFT JOIN Espacios AS E
    ON S.COD_Espacio = E.COD_Espacio
LEFT JOIN Tipos_Espacios AS TE
    ON E.COD_TipoEspacio = TE.COD_TipoEspacio
ORDER BY S.COD_Servicio;
GO


SELECT * FROM Servicios;
GO


-- -------------------------------------------------------------------
--      2.17. SISTEMAS
-- -------------------------------------------------------------------

CREATE TABLE SISTEMAS
(
    COD_Sistema INT IDENTITY(1,1)
        CONSTRAINT PK_SISTEMAS PRIMARY KEY,

    COD_Propiedad INT NOT NULL,
    COD_Espacio INT NULL,
    COD_Proveedor INT NOT NULL,
    COD_TipoSistema INT NOT NULL,

    RefSistema NVARCHAR(50) NULL,
    DatosTecnicos XML NULL,
    FechaInstalacion DATETIME2 NOT NULL,
    COD_Doc INT NULL,

    CONSTRAINT FK_SISTEMAS_PROPIEDADES
        FOREIGN KEY (COD_Propiedad)
        REFERENCES PROPIEDADES (COD_Propiedad),

    CONSTRAINT FK_SISTEMAS_ESPACIOS
        FOREIGN KEY (COD_Espacio, COD_Propiedad)
        REFERENCES ESPACIOS (COD_Espacio, COD_Propiedad),

    CONSTRAINT FK_SISTEMAS_PROVEEDORES
        FOREIGN KEY (COD_Proveedor)
        REFERENCES PROVEEDORES (COD_Proveedor),

    CONSTRAINT FK_SISTEMAS_TIPOS
        FOREIGN KEY (COD_TipoSistema)
        REFERENCES TIPOS_SISTEMAS (COD_TipoSistema),

    CONSTRAINT FK_SISTEMAS_DOCUMENTOS
        FOREIGN KEY (COD_Doc)
        REFERENCES DOCUMENTOS (COD_Doc)
);
GO


CREATE UNIQUE INDEX UX_SISTEMAS_RefSistema
ON SISTEMAS (RefSistema)
WHERE RefSistema IS NOT NULL;
GO


/* 
CREATE TRIGGER TRG_SISTEMAS_RefSistema
ON SISTEMAS
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE S
    SET RefSistema = CONCAT(
        'PR', I.COD_Proveedor,
        '-TS', I.COD_TipoSistema,
        '-S', I.COD_Sistema
    )
    FROM SISTEMAS AS S
    INNER JOIN INSERTED AS I
        ON S.COD_Sistema = I.COD_Sistema;
END;
GO


INSERT INTO SISTEMAS
(
    COD_Propiedad,
    COD_Espacio,
    COD_Proveedor,
    COD_TipoSistema,
    DatosTecnicos,
    FechaInstalacion,
    COD_Doc
)
SELECT
    1,
    NULL,
    P.COD_Proveedor,
    TS.COD_TipoSistema,
    CAST(N'
    <Sistema>
        <Marca>SIBER</Marca>
        <Modelo>DF EVO 2</Modelo>
        <Tipo>Recuperador de calor</Tipo>
        <Caracteristicas>
            <CaudalMax>200 m3/h</CaudalMax>
            <Domotica>Conectividad mediante KNX - Modbus</Domotica>
            <ClaseFiltro>Coarse 65% (G4)</ClaseFiltro>
        </Caracteristicas>
    </Sistema>' AS XML),
    '2025-11-01',
    1
FROM PROVEEDORES AS P
CROSS JOIN TIPOS_SISTEMAS AS TS
WHERE P.Empresa = N'Saltoki'
  AND TS.TipoSistema = N'RECUPERADOR_CALOR';
GO

SELECT *
FROM SISTEMAS;
GO */


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

-- -------------------------------------------------------------------
--      2.18. PRESUPUESTOS
-- -------------------------------------------------------------------

/* CREATE TABLE PRESUPUESTOS
(
    COD_Presupuesto INT IDENTITY(1,1)
        CONSTRAINT PK_PRESUPUESTOS PRIMARY KEY,

    COD_Propiedad INT NOT NULL,
    COD_Doc INT NOT NULL,
    COD_Sistema INT NULL,
    COD_Servicio INT NULL,
    COD_EstadoPresu INT NOT NULL,

    RefPresu NVARCHAR(50) NULL,

    FechaInicio DATETIME2 NOT NULL,
    FechaFin DATETIME2 NOT NULL,

    Importe DECIMAL(14,2) NOT NULL,
    Anticipo DECIMAL(14,2) NULL,
    PagoParcial DECIMAL(14,2) NULL,

    -- Importe total pagado
    PagoTotal AS
    (
        ISNULL(Anticipo, 0) + ISNULL(PagoParcial, 0)
    ) PERSISTED,

    -- Importe pendiente de pago
    Saldo AS
    (
        Importe - (ISNULL(Anticipo, 0) + ISNULL(PagoParcial, 0))
    ) PERSISTED,

    -- Indica si el presupuesto está completamente pagado
    Pagado AS
    (
        CASE
            WHEN Importe =
                ISNULL(Anticipo, 0) +
                ISNULL(PagoParcial, 0)
            THEN 1
            ELSE 0
        END
    ) PERSISTED,

    URL_Compra NVARCHAR(4000) NULL,
    Comentarios NVARCHAR(MAX) NULL,

    RegistroInicial DATETIME2 NOT NULL
        CONSTRAINT DF_PRESUPUESTOS_RegistroInicial
        DEFAULT SYSDATETIME(),

    RegistroFinal DATETIME2 NOT NULL
        CONSTRAINT DF_PRESUPUESTOS_RegistroFinal
        DEFAULT SYSDATETIME(),

    -- Claves foráneas
    CONSTRAINT FK_PRESUPUESTOS_PROPIEDADES
        FOREIGN KEY (COD_Propiedad)
        REFERENCES PROPIEDADES (COD_Propiedad),

    CONSTRAINT FK_PRESUPUESTOS_DOCUMENTOS
        FOREIGN KEY (COD_Doc)
        REFERENCES DOCUMENTOS (COD_Doc),

    CONSTRAINT FK_PRESUPUESTOS_SISTEMAS
        FOREIGN KEY (COD_Sistema)
        REFERENCES SISTEMAS (COD_Sistema),

    CONSTRAINT FK_PRESUPUESTOS_SERVICIOS
        FOREIGN KEY (COD_Servicio)
        REFERENCES SERVICIOS (COD_Servicio),

    CONSTRAINT FK_PRESUPUESTOS_ESTADOS
        FOREIGN KEY (COD_EstadoPresu)
        REFERENCES ESTADOS_PRESUPUESTOS (COD_EstadoPresu),

    -- Restricciones CHECK
    CONSTRAINT CK_PRESUPUESTOS_Fechas
        CHECK (FechaFin >= FechaInicio),

    CONSTRAINT CK_PRESUPUESTOS_Importe
        CHECK (Importe >= 0),

    CONSTRAINT CK_PRESUPUESTOS_Anticipo
        CHECK (Anticipo IS NULL OR Anticipo >= 0),

    CONSTRAINT CK_PRESUPUESTOS_PagoParcial
        CHECK (PagoParcial IS NULL OR PagoParcial >= 0),

    CONSTRAINT CK_PRESUPUESTOS_Pagos
        CHECK
        (
            ISNULL(Anticipo, 0) +
            ISNULL(PagoParcial, 0) <= Importe
        )
);
GO

CREATE UNIQUE INDEX UX_PRESUPUESTOS_RefPresu
ON PRESUPUESTOS (RefPresu)
WHERE RefPresu IS NOT NULL;
GO


CREATE TRIGGER TRG_PRESUPUESTOS_RefPresu
ON PRESUPUESTOS
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
    SET RefPresu = CONCAT(
        PR.RefPropiedad,
        '-PR',
        I.COD_Presupuesto
    )
    FROM PRESUPUESTOS AS P
    INNER JOIN INSERTED AS I
        ON P.COD_Presupuesto = I.COD_Presupuesto
    INNER JOIN PROPIEDADES AS PR
        ON I.COD_Propiedad = PR.COD_Propiedad;
END;
GO


INSERT INTO PRESUPUESTOS
(
    COD_Propiedad,
    COD_Doc,
    COD_Sistema,
    COD_Servicio,
    COD_EstadoPresu,
    FechaInicio,
    FechaFin,
    Importe,
    Anticipo,
    PagoParcial,
    URL_Compra,
    Comentarios
)
SELECT
    1,
    2,
    1,
    2,
    EP.COD_EstadoPresu,
    '2026-11-01',
    '2026-11-15',
    61.96,
    0,
    61.96,
    NULL,
    N'solo entrega en tienda'
FROM ESTADOS_PRESUPUESTOS AS EP
WHERE EP.EstadoPresu = N'ACEPTADO';
GO */



select * from PRESUPUESTOS



-- -------------------------------------------------------------------
--      2.19. PLANIFICACION
-- -------------------------------------------------------------------


/* -- clave foraneas compuestas para la tabla PLANIFICACION
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE name = 'UQ_SISTEMAS_COD_Sistema_Propiedad'
)
BEGIN
    ALTER TABLE SISTEMAS
    ADD CONSTRAINT UQ_SISTEMAS_COD_Sistema_Propiedad
    UNIQUE (COD_Sistema, COD_Propiedad);
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE name = 'UQ_SERVICIOS_COD_Servicio_Propiedad'
)
BEGIN
    ALTER TABLE SERVICIOS
    ADD CONSTRAINT UQ_SERVICIOS_COD_Servicio_Propiedad
    UNIQUE (COD_Servicio, COD_Propiedad);
END;
GO


CREATE TABLE PLANIFICACION
(
    COD_Actividad INT IDENTITY(1,1)
        CONSTRAINT PK_PLANIFICACION PRIMARY KEY,

    COD_Propiedad INT NOT NULL,
    COD_TipoActividad INT NOT NULL,
    COD_Sistema INT NULL,
    COD_Servicio INT NULL,

    RefActividad NVARCHAR(50) NULL,

    COD_EstadoPlan INT NOT NULL,

    FechaInicio DATETIME2 NULL,
    FechaFin DATETIME2 NULL,

    Comentarios NVARCHAR(MAX) NULL,
    FechaRecordatorio DATETIME2 NULL,
    COD_Doc INT NULL,

    RegistroInicial DATETIME2 NOT NULL
        CONSTRAINT DF_PLANIFICACION_RegistroInicial
        DEFAULT SYSDATETIME(),

    RegistroFinal DATETIME2 NOT NULL
        CONSTRAINT DF_PLANIFICACION_RegistroFinal
        DEFAULT SYSDATETIME(),

    -- Claves foráneas
    CONSTRAINT FK_PLANIFICACION_PROPIEDADES
        FOREIGN KEY (COD_Propiedad)
        REFERENCES PROPIEDADES (COD_Propiedad),

    CONSTRAINT FK_PLANIFICACION_TIPOS
        FOREIGN KEY (COD_TipoActividad)
        REFERENCES TIPOS_ACTIVIDADES (COD_TipoActividad),

    CONSTRAINT FK_PLANIFICACION_SISTEMAS
        FOREIGN KEY (COD_Sistema, COD_Propiedad)
        REFERENCES SISTEMAS (COD_Sistema, COD_Propiedad),

    CONSTRAINT FK_PLANIFICACION_SERVICIOS
        FOREIGN KEY (COD_Servicio, COD_Propiedad)
        REFERENCES SERVICIOS (COD_Servicio, COD_Propiedad),

    CONSTRAINT FK_PLANIFICACION_ESTADOS
        FOREIGN KEY (COD_EstadoPlan)
        REFERENCES ESTADOS_PLANIFICACION (COD_EstadoPlan),

    CONSTRAINT FK_PLANIFICACION_DOCUMENTOS
        FOREIGN KEY (COD_Doc)
        REFERENCES DOCUMENTOS (COD_Doc),

    -- Restricción de fechas
    CONSTRAINT CK_PLANIFICACION_Fechas
        CHECK (
            FechaInicio IS NULL
            OR FechaFin IS NULL
            OR FechaFin >= FechaInicio
        )
);
GO



CREATE UNIQUE INDEX UX_PLANIFICACION_RefActividad
ON PLANIFICACION (RefActividad)
WHERE RefActividad IS NOT NULL;
GO




CREATE TRIGGER TRG_PLANIFICACION_RefActividad
ON PLANIFICACION
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
    SET RefActividad = CONCAT(
        PR.RefPropiedad,

        CASE
            WHEN I.COD_Sistema IS NOT NULL
            THEN CONCAT('-S', I.COD_Sistema)
            ELSE ''
        END,

        CASE
            WHEN I.COD_Servicio IS NOT NULL
            THEN CONCAT('-SV', I.COD_Servicio)
            ELSE ''
        END,

        '-',
        TA.TipoActividad,
        '-A',
        I.COD_Actividad
    )
    FROM PLANIFICACION AS P
    INNER JOIN INSERTED AS I
        ON P.COD_Actividad = I.COD_Actividad
    INNER JOIN PROPIEDADES AS PR
        ON I.COD_Propiedad = PR.COD_Propiedad
    INNER JOIN TIPOS_ACTIVIDADES AS TA
        ON I.COD_TipoActividad = TA.COD_TipoActividad;
END;
GO */

/* 
INSERT INTO PLANIFICACION
(
    COD_Propiedad,
    COD_TipoActividad,
    COD_Sistema,
    COD_Servicio,
    COD_EstadoPlan,
    FechaInicio,
    FechaFin,
    Comentarios,
    FechaRecordatorio,
    COD_Doc
)
SELECT
    1,
    31,
    1,
    2,
    EP.COD_EstadoPlan,
    '2026-12-01',
    '2026-12-01',
    N'OFERTA REPUESTOS SIBER',
    '2026-10-01',
    NULL
FROM ESTADOS_PLANIFICACION AS EP
WHERE EP.EstadoPlan = N'PROGRAMADO';
GO

select * from PLANIFICACION
 */

-- ===================================================================
--      3. PROCEDIMIENTOS ALMACENADOS
-- ===================================================================
-- -------------------------------------------------------------------
--      3.1. REGISTRAR UN SISTEMA
-- -------------------------------------------------------------------
/* Registrar un nuevo sistema instalado en una propiedad,
incluyendo sus datos técnicos en el campo XML.*/

CREATE OR ALTER PROCEDURE dbo.SP_RegistrarSistema
    @COD_Propiedad INT,
    @COD_Proveedor INT,
    @COD_TipoSistema INT,
    @FechaInstalacion DATETIME2,
    @DatosTecnicos XML = NULL,
    @COD_Espacio INT = NULL,
    @COD_Doc INT = NULL,
    @COD_Sistema INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @COD_Sistema = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Comprobar que existe la propiedad.
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Propiedades
            WHERE COD_Propiedad = @COD_Propiedad
        )
            THROW 50001, 'La propiedad indicada no existe.', 1;

        -- Comprobar que el proveedor existe.
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Proveedores
            WHERE COD_Proveedor = @COD_Proveedor
        )
            THROW 50002, 'El proveedor indicado no existe.', 1;

        -- Comprobar que el tipo de sistema existe y está activo.
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Tipos_Sistemas
            WHERE COD_TipoSistema = @COD_TipoSistema
              AND Activo = 1
        )
            THROW 50003, 'El tipo de sistema no existe o está inactivo.', 1;

        -- Si se indica un espacio, debe pertenecer a la propiedad.
        IF @COD_Espacio IS NOT NULL
           AND NOT EXISTS (
                SELECT 1
                FROM dbo.Espacios
                WHERE COD_Espacio = @COD_Espacio
                  AND COD_Propiedad = @COD_Propiedad
           )
            THROW 50004, 'El espacio no pertenece a la propiedad indicada.', 1;

        -- Si se indica un documento, debe pertenecer a la propiedad.
        IF @COD_Doc IS NOT NULL
           AND NOT EXISTS (
                SELECT 1
                FROM dbo.Documentos
                WHERE COD_Doc = @COD_Doc
                  AND COD_Propiedad = @COD_Propiedad
           )
            THROW 50005, 'El documento no pertenece a la propiedad indicada.', 1;

        INSERT INTO dbo.Sistemas
        (
            COD_Propiedad,
            COD_Espacio,
            COD_Proveedor,
            COD_TipoSistema,
            DatosTecnicos,
            FechaInstalacion,
            COD_Doc
        )
        VALUES
        (
            @COD_Propiedad,
            @COD_Espacio,
            @COD_Proveedor,
            @COD_TipoSistema,
            @DatosTecnicos,
            @FechaInstalacion,
            @COD_Doc
        );

        SET @COD_Sistema = CONVERT(INT, SCOPE_IDENTITY());

        COMMIT TRANSACTION;

        -- Devolver el registro creado, incluida la referencia generada por el trigger.
        SELECT
            COD_Sistema,
            RefSistema,
            COD_Propiedad,
            COD_Proveedor,
            COD_TipoSistema,
            FechaInstalacion,
            DatosTecnicos
        FROM dbo.Sistemas
        WHERE COD_Sistema = @COD_Sistema;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO



-- INSERTAR DATOS DE PRUEBA
DECLARE @NuevoSistema INT;
DECLARE @ProveedorSaltoki INT;
DECLARE @TipoRecuperador INT;

SELECT @ProveedorSaltoki = COD_Proveedor
FROM dbo.Proveedores
WHERE Empresa = N'Saltoki';

SELECT @TipoRecuperador = COD_TipoSistema
FROM dbo.Tipos_Sistemas
WHERE TipoSistema = N'RECUPERADOR_CALOR'
  AND Activo = 1;

IF @ProveedorSaltoki IS NULL OR @TipoRecuperador IS NULL
    THROW 50101, 'No se encuentra el proveedor o el tipo de sistema para la prueba.', 1;

EXEC dbo.SP_RegistrarSistema
    @COD_Propiedad = 1,
    @COD_Proveedor = @ProveedorSaltoki,
    @COD_TipoSistema = @TipoRecuperador,
    @FechaInstalacion = '2026-11-01',
    @DatosTecnicos = N'
        <Sistema>
            <Marca>SIBER</Marca>
            <Modelo>DF EVO 2</Modelo>
            <Tipo>Recuperador de calor</Tipo>
            <Caracteristicas>
                <CaudalMax>200 m3/h</CaudalMax>
                <Domotica>KNX - Modbus</Domotica>
                <ClaseFiltro>Coarse 65% (G4)</ClaseFiltro>
            </Caracteristicas>
        </Sistema>',
    @COD_Doc = @NuevoDocumento,
    @COD_Sistema = @NuevoSistema OUTPUT;

PRINT CONCAT('Sistema registrado. COD_Sistema: ', @NuevoSistema);




-- -------------------------------------------------------------------
--      3.2. REGISTRAR UN SERVICIO
-- -------------------------------------------------------------------
/*Registrar un servicio asociado a una propiedad, espacio y proveedor.*/

CREATE OR ALTER PROCEDURE dbo.SP_RegistrarServicio
    @COD_Propiedad INT,
    @COD_Proveedor INT,
    @COD_TipoServicio INT,
    @COD_Servicio INT OUTPUT,
    @COD_Espacio INT = NULL,
    @Especificaciones XML = NULL,
    @COD_Doc INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @COD_Servicio = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Propiedades
            WHERE COD_Propiedad = @COD_Propiedad
        )
            THROW 50011, 'La propiedad indicada no existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Proveedores
            WHERE COD_Proveedor = @COD_Proveedor
        )
            THROW 50012, 'El proveedor indicado no existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Tipos_Servicios
            WHERE COD_TipoServicio = @COD_TipoServicio
              AND Activo = 1
        )
            THROW 50013, 'El tipo de servicio no existe o está inactivo.', 1;

        IF @COD_Espacio IS NOT NULL
           AND NOT EXISTS (
                SELECT 1
                FROM dbo.Espacios
                WHERE COD_Espacio = @COD_Espacio
                  AND COD_Propiedad = @COD_Propiedad
           )
            THROW 50014, 'El espacio no pertenece a la propiedad indicada.', 1;

        IF @COD_Doc IS NOT NULL
           AND NOT EXISTS (
                SELECT 1
                FROM dbo.Documentos
                WHERE COD_Doc = @COD_Doc
                  AND COD_Propiedad = @COD_Propiedad
           )
            THROW 50015, 'El documento no pertenece a la propiedad indicada.', 1;

        INSERT INTO dbo.Servicios
        (
            COD_Propiedad,
            COD_Espacio,
            COD_Proveedor,
            COD_TipoServicio,
            Especificaciones,
            COD_Doc
        )
        VALUES
        (
            @COD_Propiedad,
            @COD_Espacio,
            @COD_Proveedor,
            @COD_TipoServicio,
            @Especificaciones,
            @COD_Doc
        );

        SET @COD_Servicio = CONVERT(INT, SCOPE_IDENTITY());

        COMMIT TRANSACTION;

        SELECT
            COD_Servicio,
            RefServicio,
            COD_Propiedad,
            COD_Espacio,
            COD_Proveedor,
            COD_TipoServicio,
            Especificaciones,
            COD_Doc
        FROM dbo.Servicios
        WHERE COD_Servicio = @COD_Servicio;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO





-- INSERTAR DATOS DE PRUEBA
DECLARE @NuevoServicio INT;
DECLARE @TipoFiltros INT;
DECLARE @EspacioCocina INT;

SELECT @TipoFiltros = COD_TipoServicio
FROM dbo.Tipos_Servicios
WHERE TipoServicio = N'FILTROS'
  AND Activo = 1;

SELECT TOP (1) @EspacioCocina = E.COD_Espacio
FROM dbo.Espacios AS E
INNER JOIN dbo.Tipos_Espacios AS TE
    ON E.COD_TipoEspacio = TE.COD_TipoEspacio
WHERE E.COD_Propiedad = 1
  AND TE.TipoEspacio = N'COCINA'
ORDER BY E.COD_Espacio;

IF @TipoFiltros IS NULL
    THROW 50102, 'No se encuentra el tipo de servicio FILTROS.', 1;

IF @EspacioCocina IS NULL
    THROW 50103, 'No se encuentra un espacio de tipo COCINA en la propiedad 1.', 1;

EXEC dbo.SP_RegistrarServicio
    @COD_Propiedad = 1,
    @COD_Espacio = @EspacioCocina,
    @COD_Proveedor = @ProveedorSaltoki,
    @COD_TipoServicio = @TipoFiltros,
    @Especificaciones = N'
        <Detalles>
            <Caracteristicas>
                <Filtro>F7</Filtro>
                <Descripcion>Filtro ISO ePM1 55%</Descripcion>
            </Caracteristicas>
            <Mantenimiento>
                <Frecuencia>Semestral</Frecuencia>
                <Recomendacion>Revisar y sustituir los filtros</Recomendacion>
            </Mantenimiento>
        </Detalles>',
    @COD_Doc = @NuevoDocumento,
    @COD_Servicio = @NuevoServicio OUTPUT;

PRINT CONCAT('Servicio registrado. COD_Servicio: ', @NuevoServicio);






-- -------------------------------------------------------------------
--      3.3. PROGRAMAR UNA ACTIVIDAD
-- -------------------------------------------------------------------
/*Planificar una actividad técnica, indicando fechas, tipo, estado y
sistema o servicio relacionado.*/

CREATE OR ALTER PROCEDURE dbo.SP_ProgramarActividad
    @COD_Propiedad INT,
    @COD_TipoActividad INT,
    @EstadoPlan NVARCHAR(30),
    @COD_Actividad INT OUTPUT,
    @FechaInicio DATETIME2 = NULL,
    @FechaFin DATETIME2 = NULL,
    @COD_Sistema INT = NULL,
    @COD_Servicio INT = NULL,
    @Comentarios NVARCHAR(MAX) = NULL,
    @FechaRecordatorio DATETIME2 = NULL,
    @COD_Doc INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @COD_Actividad = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Propiedades
            WHERE COD_Propiedad = @COD_Propiedad
        )
            THROW 50021, 'La propiedad indicada no existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Tipos_Actividades
            WHERE COD_TipoActividad = @COD_TipoActividad
              AND Activo = 1
        )
            THROW 50022, 'El tipo de actividad no existe o está inactivo.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Estados_Planificacion
            WHERE EstadoPlan = @EstadoPlan
              AND Activo = 1
        )
            THROW 50023, 'El estado indicado no existe o está inactivo.', 1;

        IF @FechaInicio IS NOT NULL
           AND @FechaFin IS NOT NULL
           AND @FechaFin < @FechaInicio
            THROW 50024, 'La fecha de finalización no puede ser anterior a la fecha de inicio.', 1;

        IF @COD_Sistema IS NOT NULL
           AND NOT EXISTS (
                SELECT 1
                FROM dbo.Sistemas
                WHERE COD_Sistema = @COD_Sistema
                  AND COD_Propiedad = @COD_Propiedad
           )
            THROW 50025, 'El sistema no pertenece a la propiedad indicada.', 1;

        IF @COD_Servicio IS NOT NULL
           AND NOT EXISTS (
                SELECT 1
                FROM dbo.Servicios
                WHERE COD_Servicio = @COD_Servicio
                  AND COD_Propiedad = @COD_Propiedad
           )
            THROW 50026, 'El servicio no pertenece a la propiedad indicada.', 1;

        IF @COD_Doc IS NOT NULL
           AND NOT EXISTS (
                SELECT 1
                FROM dbo.Documentos
                WHERE COD_Doc = @COD_Doc
                  AND COD_Propiedad = @COD_Propiedad
           )
            THROW 50027, 'El documento no pertenece a la propiedad indicada.', 1;

        DECLARE @COD_EstadoPlan INT;

        SELECT @COD_EstadoPlan = COD_EstadoPlan
        FROM dbo.Estados_Planificacion
        WHERE EstadoPlan = @EstadoPlan
          AND Activo = 1;

        INSERT INTO dbo.Planificacion
        (
            COD_Propiedad,
            COD_TipoActividad,
            COD_Sistema,
            COD_Servicio,
            COD_EstadoPlan,
            FechaInicio,
            FechaFin,
            Comentarios,
            FechaRecordatorio,
            COD_Doc
        )
        VALUES
        (
            @COD_Propiedad,
            @COD_TipoActividad,
            @COD_Sistema,
            @COD_Servicio,
            @COD_EstadoPlan,
            @FechaInicio,
            @FechaFin,
            @Comentarios,
            @FechaRecordatorio,
            @COD_Doc
        );

        SET @COD_Actividad = CONVERT(INT, SCOPE_IDENTITY());

        COMMIT TRANSACTION;

        SELECT
            COD_Actividad,
            RefActividad,
            COD_Propiedad,
            COD_TipoActividad,
            COD_Sistema,
            COD_Servicio,
            COD_EstadoPlan,
            FechaInicio,
            FechaFin,
            Comentarios,
            FechaRecordatorio
        FROM dbo.Planificacion
        WHERE COD_Actividad = @COD_Actividad;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO


-- INSERTAR DATOS DE PRUEBA
DECLARE @NuevaActividad INT;
DECLARE @TipoInspeccion INT;

SELECT @TipoInspeccion = COD_TipoActividad
FROM dbo.Tipos_Actividades
WHERE TipoActividad = N'INSPECCIONAR'
  AND Activo = 1;

IF @TipoInspeccion IS NULL
    THROW 50104, 'No se encuentra el tipo de actividad INSPECCIONAR.', 1;

EXEC dbo.SP_ProgramarActividad
    @COD_Propiedad = 1,
    @COD_TipoActividad = @TipoInspeccion,
    @EstadoPlan = N'PROGRAMADO',
    @FechaInicio = '2026-12-01 09:00:00',
    @FechaFin = '2026-12-01 11:00:00',
    @COD_Sistema = @NuevoSistema,
    @COD_Servicio = @NuevoServicio,
    @Comentarios = N'Revisión del recuperador de calor y sustitución de filtros.',
    @FechaRecordatorio = '2026-11-28 09:00:00',
    @COD_Doc = @NuevoDocumento,
    @COD_Actividad = @NuevaActividad OUTPUT;

PRINT CONCAT('Actividad registrada. COD_Actividad: ', @NuevaActividad);






-- -------------------------------------------------------------------
--      3.4. MODIFICAR EL ESTADO DE UNA ACTIVIDAD
-- -------------------------------------------------------------------
/*Cambiar el estado de una actividad: pendiente, programada, en curso,
finalizada, etc.*/

CREATE OR ALTER PROCEDURE dbo.SP_ModificarEstadoActividad
    @COD_Actividad INT,
    @EstadoPlan NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Planificacion
            WHERE COD_Actividad = @COD_Actividad
        )
            THROW 50031, 'La actividad indicada no existe.', 1;

        DECLARE @COD_EstadoPlan INT;

        SELECT @COD_EstadoPlan = COD_EstadoPlan
        FROM dbo.Estados_Planificacion
        WHERE EstadoPlan = @EstadoPlan
          AND Activo = 1;

        IF @COD_EstadoPlan IS NULL
            THROW 50032, 'El estado indicado no existe o está inactivo.', 1;

        UPDATE dbo.Planificacion
        SET COD_EstadoPlan = @COD_EstadoPlan,
            RegistroFinal = SYSDATETIME()
        WHERE COD_Actividad = @COD_Actividad;

        COMMIT TRANSACTION;

        SELECT
            P.COD_Actividad,
            P.RefActividad,
            EP.EstadoPlan,
            P.FechaInicio,
            P.FechaFin,
            P.RegistroFinal
        FROM dbo.Planificacion AS P
        INNER JOIN dbo.Estados_Planificacion AS EP
            ON P.COD_EstadoPlan = EP.COD_EstadoPlan
        WHERE P.COD_Actividad = @COD_Actividad;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO




-- INSERTAR DATOS DE PRUEBA
EXEC dbo.SP_ModificarEstadoActividad
    @COD_Actividad = @NuevaActividad,
    @EstadoPlan = N'EN CURSO';








-- -------------------------------------------------------------------
--      3.5. REGISTRAR UN DOCUMENTO
-- -------------------------------------------------------------------
/*Incorporar documentación técnica asociada a una propiedad.*/

CREATE OR ALTER PROCEDURE dbo.SP_RegistrarDocumento
    @COD_Propiedad INT,
    @TipoDoc NVARCHAR(100),
    @URL_Doc NVARCHAR(4000),
    @COD_Doc INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @COD_Doc = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Propiedades
            WHERE COD_Propiedad = @COD_Propiedad
        )
            THROW 50041, 'La propiedad indicada no existe.', 1;

        DECLARE @COD_TipoDoc INT;

        SELECT @COD_TipoDoc = COD_TipoDoc
        FROM dbo.Tipos_Documentos
        WHERE TipoDoc = @TipoDoc
          AND Activo = 1;

        IF @COD_TipoDoc IS NULL
            THROW 50042, 'El tipo de documento no existe o está inactivo.', 1;

        IF NULLIF(LTRIM(RTRIM(@URL_Doc)), N'') IS NULL
            THROW 50043, 'La URL del documento es obligatoria.', 1;

        INSERT INTO dbo.Documentos
        (
            COD_Propiedad,
            COD_TipoDoc,
            URL_Doc
        )
        VALUES
        (
            @COD_Propiedad,
            @COD_TipoDoc,
            @URL_Doc
        );

        SET @COD_Doc = CONVERT(INT, SCOPE_IDENTITY());

        COMMIT TRANSACTION;

        SELECT
            D.COD_Doc,
            D.RefDoc,
            D.COD_Propiedad,
            TD.TipoDoc,
            D.URL_Doc
        FROM dbo.Documentos AS D
        INNER JOIN dbo.Tipos_Documentos AS TD
            ON D.COD_TipoDoc = TD.COD_TipoDoc
        WHERE D.COD_Doc = @COD_Doc;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- INSERTAR DATOS DE PRUEBA
DECLARE @NuevoDocumento INT;

EXEC dbo.SP_RegistrarDocumento
    @COD_Propiedad = 1,
    @TipoDoc = N'FICHA_TECNICA',
    @URL_Doc = N'https://ejemplo.com/documentacion/recuperador-calor.pdf',
    @COD_Doc = @NuevoDocumento OUTPUT;

PRINT CONCAT('Documento registrado. COD_Doc: ', @NuevoDocumento);


-- ******** COMPROBACIÓN FINAL
SELECT
    P.COD_Actividad,
    P.RefActividad,
    PR.RefPropiedad,
    TA.TipoActividad,
    EP.EstadoPlan,
    S.RefSistema,
    SV.RefServicio,
    P.FechaInicio,
    P.FechaFin,
    P.Comentarios
FROM dbo.Planificacion AS P
INNER JOIN dbo.Propiedades AS PR
    ON P.COD_Propiedad = PR.COD_Propiedad
INNER JOIN dbo.Tipos_Actividades AS TA
    ON P.COD_TipoActividad = TA.COD_TipoActividad
INNER JOIN dbo.Estados_Planificacion AS EP
    ON P.COD_EstadoPlan = EP.COD_EstadoPlan
LEFT JOIN dbo.Sistemas AS S
    ON P.COD_Sistema = S.COD_Sistema
LEFT JOIN dbo.Servicios AS SV
    ON P.COD_Servicio = SV.COD_Servicio
WHERE P.COD_Actividad = @NuevaActividad;
GO


-- ===================================================================
--      4. PROCEDIMIENTOS TRANSACCIONALES
-- ===================================================================
-- -------------------------------------------------------------------
--      4.1. REGISTRAR UN SISTEMA COMPLETO
-- -------------------------------------------------------------------
/*Este procedimiento realiza las siguientes operaciones:
1. Comprueba que existen la propiedad, el proveedor y el tipo de sistema.
2. Comprueba que el espacio, si se indica, pertenece a la propiedad.
3. Comprueba que el tipo de documento existe y está activo.
4. Inserta el documento técnico en Documentos.
5. Recupera el identificador del documento.
6. Inserta el sistema en Sistemas, vinculándolo al documento.
7. Confirma ambas inserciones mediante COMMIT.*/

CREATE OR ALTER PROCEDURE dbo.SP_RegistrarSistemaCompleto
    @COD_Propiedad INT,
    @COD_Proveedor INT,
    @COD_TipoSistema INT,
    @FechaInstalacion DATETIME2,
    @TipoDoc NVARCHAR(100),
    @URL_Doc NVARCHAR(4000),
    @COD_Sistema INT OUTPUT,
    @COD_Doc INT OUTPUT,
    @COD_Espacio INT = NULL,
    @DatosTecnicos XML = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @COD_Sistema = NULL;
    SET @COD_Doc = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validar propiedad
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Propiedades
            WHERE COD_Propiedad = @COD_Propiedad
        )
        BEGIN
            ;THROW 50051, 'La propiedad indicada no existe.', 1;
        END;

        -- 2. Validar proveedor
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Proveedores
            WHERE COD_Proveedor = @COD_Proveedor
        )
        BEGIN
            ;THROW 50052, 'El proveedor indicado no existe.', 1;
        END;

        -- 3. Validar tipo de sistema
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Tipos_Sistemas
            WHERE COD_TipoSistema = @COD_TipoSistema
              AND Activo = 1
        )
        BEGIN
            ;THROW 50053, 'El tipo de sistema no existe o está inactivo.', 1;
        END;

        -- 4. Validar espacio y propiedad
        IF @COD_Espacio IS NOT NULL
           AND NOT EXISTS (
                SELECT 1
                FROM dbo.Espacios
                WHERE COD_Espacio = @COD_Espacio
                  AND COD_Propiedad = @COD_Propiedad
           )
        BEGIN
            ;THROW 50054, 'El espacio no pertenece a la propiedad indicada.', 1;
        END;

        -- 5. Validar tipo de documento
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Tipos_Documentos
            WHERE TipoDoc = @TipoDoc
              AND Activo = 1
        )
        BEGIN
            ;THROW 50055, 'El tipo de documento no existe o está inactivo.', 1;
        END;

        -- 6. Validar URL
        IF NULLIF(LTRIM(RTRIM(@URL_Doc)), N'') IS NULL
        BEGIN
            ;THROW 50056, 'La URL del documento es obligatoria.', 1;
        END;

        -- 7. Obtener identificador del tipo de documento
        DECLARE @COD_TipoDoc INT;

        SELECT @COD_TipoDoc = COD_TipoDoc
        FROM dbo.Tipos_Documentos
        WHERE TipoDoc = @TipoDoc
          AND Activo = 1;

        -- 8. Insertar documento técnico
        INSERT INTO dbo.Documentos
        (
            COD_Propiedad,
            COD_TipoDoc,
            URL_Doc
        )
        VALUES
        (
            @COD_Propiedad,
            @COD_TipoDoc,
            @URL_Doc
        );

        SET @COD_Doc = CONVERT(INT, SCOPE_IDENTITY());

        -- 9. Insertar sistema y vincular el documento
        INSERT INTO dbo.Sistemas
        (
            COD_Propiedad,
            COD_Espacio,
            COD_Proveedor,
            COD_TipoSistema,
            DatosTecnicos,
            FechaInstalacion,
            COD_Doc
        )
        VALUES
        (
            @COD_Propiedad,
            @COD_Espacio,
            @COD_Proveedor,
            @COD_TipoSistema,
            @DatosTecnicos,
            @FechaInstalacion,
            @COD_Doc
        );

        SET @COD_Sistema = CONVERT(INT, SCOPE_IDENTITY());

        -- 10. Confirmar ambas operaciones
        COMMIT TRANSACTION;

        -- 11. Mostrar el resultado
        SELECT
            S.COD_Sistema,
            S.RefSistema,
            S.COD_Propiedad,
            S.COD_Proveedor,
            S.COD_TipoSistema,
            S.FechaInstalacion,
            S.DatosTecnicos,
            D.COD_Doc,
            D.RefDoc,
            TD.TipoDoc,
            D.URL_Doc
        FROM dbo.Sistemas AS S
        INNER JOIN dbo.Documentos AS D
            ON S.COD_Doc = D.COD_Doc
        INNER JOIN dbo.Tipos_Documentos AS TD
            ON D.COD_TipoDoc = TD.COD_TipoDoc
        WHERE S.COD_Sistema = @COD_Sistema;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        SET @COD_Sistema = NULL;
        SET @COD_Doc = NULL;

        THROW;

    END CATCH;
END;
GO







-- -------------------------------------------------------------------
--      4.2. REGISTRAR UN SERVICIO COMPLETO
-- -------------------------------------------------------------------
/*Este procedimiento realiza las siguientes operaciones:
1. Comprueba la propiedad, el proveedor y el tipo de servicio.
2. Comprueba que el espacio pertenece a la propiedad, si se ha indicado.
3. Comprueba que el tipo de documento está activo.
4. Inserta el documento en Documentos.
5. Recupera su identificador.
6. Inserta el servicio en Servicios, vinculando el documento y el resto de entidades.
7. Confirma la transacción.*/

CREATE OR ALTER PROCEDURE dbo.SP_RegistrarServicioCompleto
    @COD_Propiedad INT,
    @COD_Proveedor INT,
    @COD_TipoServicio INT,
    @TipoDoc NVARCHAR(100),
    @URL_Doc NVARCHAR(4000),
    @COD_Servicio INT OUTPUT,
    @COD_Doc INT OUTPUT,
    @COD_Espacio INT = NULL,
    @Especificaciones XML = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @COD_Servicio = NULL;
    SET @COD_Doc = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validar propiedad
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Propiedades
            WHERE COD_Propiedad = @COD_Propiedad
        )
        BEGIN
            ;THROW 50061, 'La propiedad indicada no existe.', 1;
        END;

        -- 2. Validar proveedor
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Proveedores
            WHERE COD_Proveedor = @COD_Proveedor
        )
        BEGIN
            ;THROW 50062, 'El proveedor indicado no existe.', 1;
        END;

        -- 3. Validar tipo de servicio
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Tipos_Servicios
            WHERE COD_TipoServicio = @COD_TipoServicio
              AND Activo = 1
        )
        BEGIN
            ;THROW 50063, 'El tipo de servicio no existe o está inactivo.', 1;
        END;

        -- 4. Validar espacio y propiedad
        IF @COD_Espacio IS NOT NULL
           AND NOT EXISTS (
                SELECT 1
                FROM dbo.Espacios
                WHERE COD_Espacio = @COD_Espacio
                  AND COD_Propiedad = @COD_Propiedad
           )
        BEGIN
            ;THROW 50064, 'El espacio no pertenece a la propiedad indicada.', 1;
        END;

        -- 5. Validar tipo de documento
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Tipos_Documentos
            WHERE TipoDoc = @TipoDoc
              AND Activo = 1
        )
        BEGIN
            ;THROW 50065, 'El tipo de documento no existe o está inactivo.', 1;
        END;

        -- 6. Validar URL
        IF NULLIF(LTRIM(RTRIM(@URL_Doc)), N'') IS NULL
        BEGIN
            ;THROW 50066, 'La URL del documento es obligatoria.', 1;
        END;

        -- 7. Obtener identificador del tipo de documento
        DECLARE @COD_TipoDoc INT;

        SELECT @COD_TipoDoc = COD_TipoDoc
        FROM dbo.Tipos_Documentos
        WHERE TipoDoc = @TipoDoc
          AND Activo = 1;

        -- 8. Insertar documentación del servicio
        INSERT INTO dbo.Documentos
        (
            COD_Propiedad,
            COD_TipoDoc,
            URL_Doc
        )
        VALUES
        (
            @COD_Propiedad,
            @COD_TipoDoc,
            @URL_Doc
        );

        SET @COD_Doc = CONVERT(INT, SCOPE_IDENTITY());

        -- 9. Insertar servicio y vincular el documento
        INSERT INTO dbo.Servicios
        (
            COD_Propiedad,
            COD_Espacio,
            COD_Proveedor,
            COD_TipoServicio,
            Especificaciones,
            COD_Doc
        )
        VALUES
        (
            @COD_Propiedad,
            @COD_Espacio,
            @COD_Proveedor,
            @COD_TipoServicio,
            @Especificaciones,
            @COD_Doc
        );

        SET @COD_Servicio = CONVERT(INT, SCOPE_IDENTITY());

        -- 10. Confirmar ambas operaciones
        COMMIT TRANSACTION;

        -- 11. Mostrar el resultado
        SELECT
            S.COD_Servicio,
            S.RefServicio,
            S.COD_Propiedad,
            S.COD_Espacio,
            S.COD_Proveedor,
            S.COD_TipoServicio,
            S.Especificaciones,
            D.COD_Doc,
            D.RefDoc,
            TD.TipoDoc,
            D.URL_Doc
        FROM dbo.Servicios AS S
        INNER JOIN dbo.Documentos AS D
            ON S.COD_Doc = D.COD_Doc
        INNER JOIN dbo.Tipos_Documentos AS TD
            ON D.COD_TipoDoc = TD.COD_TipoDoc
        WHERE S.COD_Servicio = @COD_Servicio;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        SET @COD_Servicio = NULL;
        SET @COD_Doc = NULL;

        THROW;

    END CATCH;
END;
GO







-- ===================================================================
--      5. FUNCIONES
-- ===================================================================
-- -------------------------------------------------------------------
--      5.1. FUNCIÓN ESCALAR
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
--          5.1.1. SALDO POR PAGAR
-- -------------------------------------------------------------------
/*Recibe el identificador de un presupuesto y devuelve su saldo
pendiente de pago. Si el presupuesto no existe, devuelve NULL.*/

CREATE OR ALTER FUNCTION dbo.FN_CalcularSaldoPresupuesto
(
    @COD_Presupuesto INT
)
RETURNS DECIMAL(14,2)
AS
BEGIN
    DECLARE @Saldo DECIMAL(14,2);

    SELECT @Saldo = Saldo
    FROM dbo.Presupuestos
    WHERE COD_Presupuesto = @COD_Presupuesto;

    RETURN @Saldo;
END;
GO



-- -------------------------------------------------------------------
--          5.1.2. DÍAS HASTA UNA ACTIVIDAD
-- -------------------------------------------------------------------
/*Recibe el identificador de una actividad y calcula los días naturales
que faltan desde la fecha actual hasta su fecha de inicio.
- Resultado positivo: actividad futura.
- Resultado cero: comienza hoy.
- Resultado negativo: la fecha de inicio ya ha pasado.
- Resultado NULL: actividad inexistente o sin fecha de inicio.*/ 

CREATE OR ALTER FUNCTION dbo.FN_DiasHastaActividad
(
    @COD_Actividad INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Dias INT;
    DECLARE @FechaInicio DATETIME2;

    SELECT @FechaInicio = FechaInicio
    FROM dbo.Planificacion
    WHERE COD_Actividad = @COD_Actividad;

    IF @FechaInicio IS NULL
        RETURN NULL;

    SET @Dias = DATEDIFF
    (
        DAY,
        CONVERT(DATE, GETDATE()),
        CONVERT(DATE, @FechaInicio)
    );

    RETURN @Dias;
END;
GO



-- -------------------------------------------------------------------
--      5.2. FUNCIÓN DE TABLA
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
--          5.2.1. SISTEMAS POR PROPIEDAD
-- -------------------------------------------------------------------
/*Recibe el identificador de una propiedad y devuelve los sistemas
instalados en ella, incluyendo:
- Identificador y referencia del sistema.
- Nombre del proveedor.
- Tipo de sistema.
- Fecha de instalación.*/

CREATE OR ALTER FUNCTION dbo.FN_SistemasPorPropiedad
(
    @COD_Propiedad INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        S.COD_Sistema,
        S.COD_Propiedad,
        S.RefSistema,
        P.Empresa AS Proveedor,
        TS.TipoSistema,
        S.FechaInstalacion
    FROM dbo.Sistemas AS S
    INNER JOIN dbo.Proveedores AS P
        ON S.COD_Proveedor = P.COD_Proveedor
    INNER JOIN dbo.Tipos_Sistemas AS TS
        ON S.COD_TipoSistema = TS.COD_TipoSistema
    WHERE S.COD_Propiedad = @COD_Propiedad
);
GO

---- ****** COMPROBACIÓN DE FUNCIONES:



-- ===================================================================
--      6. VISTAS
-- ===================================================================
-- -------------------------------------------------------------------
--      6.1. INVENTARIO TÉCNICO
-- -------------------------------------------------------------------
/*Inventario de sistemas instalados en cada propiedad, con sus
características y proveedores.*/

CREATE OR ALTER VIEW dbo.VW_InventarioTecnico
AS
SELECT
    S.COD_Sistema,
    S.RefSistema,

    -- Propiedad
    P.COD_Propiedad,
    P.RefPropiedad,
    P.DireccionPropiedad,
    P.CodigoPostal,
    P.Ciudad,
    P.Provincia,

    -- Espacio
    E.COD_Espacio,
    E.RefEspacio,
    TE.TipoEspacio,

    -- Proveedor
    PR.COD_Proveedor,
    PR.Empresa AS Proveedor,

    -- Tipo de sistema
    TS.COD_TipoSistema,
    TS.TipoSistema,
    CS.CatSistema AS CategoriaSistema,

    -- Datos técnicos
    S.FechaInstalacion,
    S.DatosTecnicos,

    -- Documento asociado
    D.COD_Doc,
    D.RefDoc,
    D.URL_Doc

FROM dbo.Sistemas AS S

INNER JOIN dbo.Propiedades AS P
    ON S.COD_Propiedad = P.COD_Propiedad

INNER JOIN dbo.Proveedores AS PR
    ON S.COD_Proveedor = PR.COD_Proveedor

INNER JOIN dbo.Tipos_Sistemas AS TS
    ON S.COD_TipoSistema = TS.COD_TipoSistema

INNER JOIN dbo.Categorias_Sistemas AS CS
    ON TS.COD_CatSistema = CS.COD_CatSistema

LEFT JOIN dbo.Espacios AS E
    ON S.COD_Espacio = E.COD_Espacio

LEFT JOIN dbo.Tipos_Espacios AS TE
    ON E.COD_TipoEspacio = TE.COD_TipoEspacio

LEFT JOIN dbo.Documentos AS D
    ON S.COD_Doc = D.COD_Doc;
GO





-- -------------------------------------------------------------------
--      6.2. PLANIFICACIÓN DE ACTIVIDADES
-- -------------------------------------------------------------------
/*Actividades planificadas, fechas, estados, propiedades y sistemas
o servicios asociados.*/

CREATE OR ALTER VIEW dbo.VW_PlanificacionActividades
AS
SELECT
    P.COD_Actividad,
    P.RefActividad,

    -- Propiedad
    PR.COD_Propiedad,
    PR.RefPropiedad,
    PR.DireccionPropiedad,
    PR.Ciudad,

    -- Tipo de actividad
    TA.COD_TipoActividad,
    TA.TipoActividad,

    -- Estado de planificación
    EP.COD_EstadoPlan,
    EP.EstadoPlan,

    -- Fechas y seguimiento
    P.FechaInicio,
    P.FechaFin,
    P.FechaRecordatorio,
    P.Comentarios,
    P.RegistroInicial,
    P.RegistroFinal,

    -- Sistema relacionado
    S.COD_Sistema,
    S.RefSistema,
    TS.TipoSistema,

    -- Servicio relacionado
    SV.COD_Servicio,
    SV.RefServicio,
    TServ.TipoServicio,

    -- Documento asociado
    D.COD_Doc,
    D.RefDoc,
    D.URL_Doc

FROM dbo.Planificacion AS P

INNER JOIN dbo.Propiedades AS PR
    ON P.COD_Propiedad = PR.COD_Propiedad

INNER JOIN dbo.Tipos_Actividades AS TA
    ON P.COD_TipoActividad = TA.COD_TipoActividad

INNER JOIN dbo.Estados_Planificacion AS EP
    ON P.COD_EstadoPlan = EP.COD_EstadoPlan

LEFT JOIN dbo.Sistemas AS S
    ON P.COD_Sistema = S.COD_Sistema

LEFT JOIN dbo.Tipos_Sistemas AS TS
    ON S.COD_TipoSistema = TS.COD_TipoSistema

LEFT JOIN dbo.Servicios AS SV
    ON P.COD_Servicio = SV.COD_Servicio

LEFT JOIN dbo.Tipos_Servicios AS TServ
    ON SV.COD_TipoServicio = TServ.COD_TipoServicio

LEFT JOIN dbo.Documentos AS D
    ON P.COD_Doc = D.COD_Doc;
GO




-- -------------------------------------------------------------------
--      6.3. HISTÓRICO DE SERVICIOS
-- -------------------------------------------------------------------
/*Servicios registrados por propiedad, espacio, proveedor y
tipo de servicio.*/

CREATE OR ALTER VIEW dbo.VW_ServiciosRegistrados
AS
SELECT
    S.COD_Servicio,
    S.RefServicio,

    -- Propiedad
    P.COD_Propiedad,
    P.RefPropiedad,
    P.DireccionPropiedad,
    P.Ciudad,

    -- Espacio
    E.COD_Espacio,
    E.RefEspacio,
    TE.TipoEspacio,

    -- Proveedor
    PR.COD_Proveedor,
    PR.Empresa AS Proveedor,

    -- Tipo y categoría del servicio
    TS.COD_TipoServicio,
    TS.TipoServicio,
    CS.CatServicio AS CategoriaServicio,

    -- Información del servicio
    S.Especificaciones,

    -- Documento asociado
    D.COD_Doc,
    D.RefDoc,
    TD.TipoDoc,
    D.URL_Doc

FROM dbo.Servicios AS S

INNER JOIN dbo.Propiedades AS P
    ON S.COD_Propiedad = P.COD_Propiedad

INNER JOIN dbo.Proveedores AS PR
    ON S.COD_Proveedor = PR.COD_Proveedor

INNER JOIN dbo.Tipos_Servicios AS TS
    ON S.COD_TipoServicio = TS.COD_TipoServicio

INNER JOIN dbo.Categorias_Servicios AS CS
    ON TS.COD_CatServicio = CS.COD_CatServicio

LEFT JOIN dbo.Espacios AS E
    ON S.COD_Espacio = E.COD_Espacio

LEFT JOIN dbo.Tipos_Espacios AS TE
    ON E.COD_TipoEspacio = TE.COD_TipoEspacio

LEFT JOIN dbo.Documentos AS D
    ON S.COD_Doc = D.COD_Doc

LEFT JOIN dbo.Tipos_Documentos AS TD
    ON D.COD_TipoDoc = TD.COD_TipoDoc;
GO






-- ===================================================================
--      7. AGRUPACIÓN Y AGREGACIÓN
-- ===================================================================
-- -------------------------------------------------------------------
--      7.1. ACTIVIDADES POR ESTADO 
-- -------------------------------------------------------------------
/*Número de actividades pendientes, programadas, en curso y
finalizadas.*/

SELECT
    EP.EstadoPlan,
    COUNT(P.COD_Actividad) AS TotalActividades
FROM Estados_Planificacion AS EP
LEFT JOIN Planificacion AS P
    ON EP.COD_EstadoPlan = P.COD_EstadoPlan
WHERE EP.EstadoPlan IN
(
    N'PENDIENTE',
    N'PROGRAMADO',
    N'EN CURSO',
    N'FINALIZADO'
)
GROUP BY
    EP.COD_EstadoPlan,
    EP.EstadoPlan
ORDER BY
    EP.COD_EstadoPlan;
GO


-- -------------------------------------------------------------------
--      7.2. SISTEMAS POR PROPIEDAD
-- -------------------------------------------------------------------
/*Número y clasificación de instalaciones existentes en cada
propiedad.*/

SELECT
    P.COD_Propiedad,
    P.RefPropiedad,
    CS.CatSistema,
    TS.TipoSistema,
    COUNT(S.COD_Sistema) AS TotalSistemas
FROM Propiedades AS P
LEFT JOIN Sistemas AS S
    ON P.COD_Propiedad = S.COD_Propiedad
LEFT JOIN Tipos_Sistemas AS TS
    ON S.COD_TipoSistema = TS.COD_TipoSistema
LEFT JOIN Categorias_Sistemas AS CS
    ON TS.COD_CatSistema = CS.COD_CatSistema
GROUP BY
    P.COD_Propiedad,
    P.RefPropiedad,
    CS.CatSistema,
    TS.TipoSistema
ORDER BY
    P.COD_Propiedad,
    CS.CatSistema,
    TS.TipoSistema;
GO


-- -------------------------------------------------------------------
--      7.3. SERVICIOS POR PROVEEDOR
-- -------------------------------------------------------------------
/*Contabilizar los servicios asociados a cada proveedor.*/

SELECT
    PR.COD_Proveedor,
    PR.Empresa,
    COUNT(S.COD_Servicio) AS TotalServicios
FROM Proveedores AS PR
LEFT JOIN Servicios AS S
    ON PR.COD_Proveedor = S.COD_Proveedor
GROUP BY
    PR.COD_Proveedor,
    PR.Empresa
ORDER BY
    TotalServicios DESC,
    PR.Empresa;
GO


-- -------------------------------------------------------------------
--      7.4. PRESUPUESTOS POR PROPIEDAD
-- -------------------------------------------------------------------
/*Calcular el importe total presupuestado por propiedad (SUM).*/

SELECT
    P.COD_Propiedad,
    P.RefPropiedad,
    COUNT(PR.COD_Presupuesto) AS TotalPresupuestos,
    SUM(COALESCE(PR.Importe, 0)) AS ImporteTotal,
    AVG(PR.Importe) AS ImporteMedio
FROM Propiedades AS P
LEFT JOIN Presupuestos AS PR
    ON P.COD_Propiedad = PR.COD_Propiedad
GROUP BY
    P.COD_Propiedad,
    P.RefPropiedad
ORDER BY
    ImporteTotal DESC;
GO


-- -------------------------------------------------------------------
--      7.5. ACTIVIDADES POR TIPO
-- -------------------------------------------------------------------
/*Distribución de trabajos de mantenimiento, instalaciones,
reparaciones, inspecciones, etc.*/

SELECT
    TA.COD_TipoActividad,
    TA.TipoActividad,
    COUNT(P.COD_Actividad) AS TotalActividades
FROM Tipos_Actividades AS TA
LEFT JOIN Planificacion AS P
    ON TA.COD_TipoActividad = P.COD_TipoActividad
GROUP BY
    TA.COD_TipoActividad,
    TA.TipoActividad
ORDER BY
    TotalActividades DESC,
    TA.TipoActividad;
GO

-- -------------------------------------------------------------------
--      7.6. PROVEEDORES CON MÁS SERVICIOS
-- -------------------------------------------------------------------
/*Listado de proveedores que han prestado más de un servicio, ordenados
por el número de servicios prestados.*/

SELECT
    PR.Empresa,
    COUNT(S.COD_Servicio) AS TotalServicios
FROM Proveedores AS PR
INNER JOIN Servicios AS S
    ON PR.COD_Proveedor = S.COD_Proveedor
GROUP BY
    PR.COD_Proveedor,
    PR.Empresa
HAVING
    COUNT(S.COD_Servicio) > 1
ORDER BY
    TotalServicios DESC;
GO


-- ===================================================================
--      8. CONSULTAS XML
-- ===================================================================
-- -------------------------------------------------------------------
--      8.1. SERVICIOS - ESPECIFICACIONES
-- -------------------------------------------------------------------
/*Consultar características de los servicios.*/

SELECT
    S.COD_Servicio,
    S.RefServicio,
    P.Empresa AS Proveedor,
    TS.TipoServicio,
    S.Especificaciones.value(
        '(/Detalles/Caracteristicas/text())[1]',
        'NVARCHAR(1000)'
    ) AS Caracteristicas
FROM Servicios AS S
INNER JOIN Proveedores AS P
    ON S.COD_Proveedor = P.COD_Proveedor
INNER JOIN Tipos_Servicios AS TS
    ON S.COD_TipoServicio = TS.COD_TipoServicio
WHERE S.Especificaciones.exist('/Detalles/Caracteristicas') = 1;
GO


-- especificaciones completas
SELECT
    COD_Servicio,
    RefServicio,
    Especificaciones.query('/Detalles') AS DetallesServicio
FROM Servicios
WHERE Especificaciones IS NOT NULL;
GO


-- -------------------------------------------------------------------
--      8.2. SISTEMAS - DATOS TÉCNICOS
-- -------------------------------------------------------------------
/*Consultar sistemas que tengan información de domótica.*/

SELECT
    S.COD_Sistema,
    S.RefSistema,
    TS.TipoSistema,
    S.DatosTecnicos.value(
        '(/Sistema/Caracteristicas/Domotica/text())[1]',
        'NVARCHAR(200)'
    ) AS InformacionDomotica
FROM Sistemas AS S
INNER JOIN Tipos_Sistemas AS TS
    ON S.COD_TipoSistema = TS.COD_TipoSistema
WHERE S.DatosTecnicos.exist(
    '/Sistema/Caracteristicas/Domotica'
) = 1;
GO


-- datos técnicos completos
SELECT
    COD_Sistema,
    RefSistema,
    DatosTecnicos.query('/Sistema') AS InformacionTecnica
FROM Sistemas
WHERE DatosTecnicos IS NOT NULL;
GO


-- ===================================================================
--      9. USUARIOS Y ROLES
-- ===================================================================
-- -------------------------------------------------------------------
--      9.1. ADMINISTRADOR
-- -------------------------------------------------------------------
/*Control completo de la base de datos.*/

CREATE ROLE Rol_Administrador;
GO

CREATE USER Usuario_Administrador WITHOUT LOGIN;
GO

ALTER ROLE Rol_Administrador
ADD MEMBER Usuario_Administrador;
GO

ALTER ROLE db_owner
ADD MEMBER Usuario_Administrador;
GO

-- Prueba de permisos:
EXECUTE AS USER = 'Usuario_Administrador';
-- Debe funcionar
SELECT * FROM dbo.Clientes;
SELECT * FROM dbo.Presupuestos;
SELECT * FROM dbo.Sistemas;
REVERT;
GO



-- -------------------------------------------------------------------
--      9.2. GESTOR
-- -------------------------------------------------------------------
/*Consultar y gestionar clientes, propiedades, proveedores, servicios
y presupuestos con permisos de consulta, inserción, modificación
y eliminación.*/

CREATE ROLE Rol_Gestor;
GO

CREATE USER Usuario_Gestor WITHOUT LOGIN;
GO

ALTER ROLE Rol_Gestor
ADD MEMBER Usuario_Gestor;
GO

GRANT SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Clientes
TO Rol_Gestor;
GO

GRANT SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Propiedades
TO Rol_Gestor;
GO

GRANT SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Proveedores
TO Rol_Gestor;
GO

GRANT SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Servicios
TO Rol_Gestor;
GO

GRANT SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Presupuestos
TO Rol_Gestor;
GO

-- denegar el acceso directo a los sistemas y a la planificación
DENY SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Sistemas
TO Rol_Gestor;
GO

DENY SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Planificacion
TO Rol_Gestor;
GO

-- Prueba de permisos:
EXECUTE AS USER = 'Usuario_Gestor';
-- Debe funcionar
SELECT * FROM dbo.Clientes;
-- Debe funcionar
SELECT * FROM dbo.Propiedades;
-- Debe funcionar
SELECT * FROM dbo.Presupuestos;
-- Debe producir un error de permisos
SELECT * FROM dbo.Sistemas;
REVERT;
GO

-- -------------------------------------------------------------------
--      9.3. TÉCNICO
-- -------------------------------------------------------------------
/*Consultar propiedades, sistemas y servicios, y gestionar
actividades de planificación.*/

CREATE ROLE Rol_Tecnico;
GO

CREATE USER Usuario_Tecnico WITHOUT LOGIN;
GO

ALTER ROLE Rol_Tecnico
ADD MEMBER Usuario_Tecnico;
GO

GRANT SELECT
ON OBJECT::dbo.Propiedades
TO Rol_Tecnico;
GO

GRANT SELECT
ON OBJECT::dbo.Sistemas
TO Rol_Tecnico;
GO

GRANT SELECT
ON OBJECT::dbo.Servicios
TO Rol_Tecnico;
GO

-- realizar consultas, inserciones, modificaciones y eliminaciones
GRANT SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Planificacion
TO Rol_Tecnico;
GO

-- denegar el acceso directo a clientes, proveedores y presupuestos
DENY SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Clientes
TO Rol_Tecnico;
GO

DENY SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Proveedores
TO Rol_Tecnico;
GO

DENY SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.Presupuestos
TO Rol_Tecnico;
GO

-- Prueba de permisos:
EXECUTE AS USER = 'Usuario_Tecnico';
-- Debe funcionar
SELECT * FROM dbo.Propiedades;
-- Debe funcionar
SELECT * FROM dbo.Sistemas;
-- Debe funcionar
SELECT * FROM dbo.Planificacion;
-- Debe producir un error de permisos
SELECT * FROM dbo.Presupuestos;
REVERT;
GO


