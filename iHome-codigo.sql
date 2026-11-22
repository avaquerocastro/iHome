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
	(
		HISTORY_TABLE = dbo.Clientes_Historico
	)
);
GO

-- DNI/NIF único aunque tengamos varios valores NULL
CREATE UNIQUE INDEX UX_CLIENTES_DNI_NIF
ON CLIENTES (DNI_NIF)
WHERE DNI_NIF IS NOT NULL;
GO


INSERT INTO CLIENTES
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
(
    'Vera',
    'Castro',
    'Gutiérrez',
    '672958367',
    'veracastro@gmail.com',
    '61234678Y',
    'Calle Madrid',
    '28041',
    'Madrid',
    'Madrid',
    1,
    '2023-09-02'
),
(
    'Javier',
    'Sánchez',
    'Rivera',
    '689463778',
    'javiersanchez@gmail.com',
    '87632816T',
    'Calle Lisboa',
    '28014',
    'Leganés',
    'Madrid',
    1,
    '2022-04-17'
),
(
    'Francisco',
    'Vaquero',
    'Castro',
    '645277890',
    'franciscovaquero@gmail.com',
    '47284617D',
    'Avenida Fuenlabrada',
    '28911',
    'Málaga',
    'Málaga',
    0,
    NULL
);
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
	(
		HISTORY_TABLE = dbo.Proveedores_Historico
	)
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
(
    'Los Gemelos',
    'Juan José',
    'Escribano',
    'Cabello',
    '677528478',
    NULL,
    '1816363F',
    'Lago Maracaibo 13 D',
    '28018',
    'Madrid',
    'Madrid',
    'Saco 1m3 - www.sacoslosgemelos.com',
    0,
    NULL
),
(
    'Saltoki',
    'Daniel',
    'García',
    'Velasco',
    '606582493',
    'dgarciav@saltoki.es',
    'A82825456',
    'Calle Río Bembezar 4',
    '28906',
    'Getafe',
    'Madrid',
    'www.saltoki.es',
    1,
    '2025-07-27'
),
(
    'Dormitorum',
    NULL,
    NULL,
    NULL,
    '600999897',
    NULL,
    NULL,
    'Av Rey Juan Carlos I 69',
    '28916',
    'Leganés',
    'Madrid',
    'www.dormitorum.es',
    1,
    '2025-10-06'
),
(
    'Bosch España',
    NULL,
    NULL,
    NULL,
    '976305713',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    'www.bosch-home.es',
    0,
    NULL
),
(
    'IKEA',
    NULL,
    NULL,
    NULL,
    '900400922',
    NULL,
    NULL,
    NULL,
    NULL,
    'Leganés',
    'Madrid',
    NULL,
    0,
    NULL
),
(
    'PVC3',
    'Verónica',
    'García',
    'Díaz',
    '925513637',
    'pvc3@pvc3.com',
    NULL,
    'Calle Nuevo Toledo 19',
    '45200',
    'Illescas',
    'Toledo',
    NULL,
    1,
    '2025-07-15'
),
(
    'JCMLsoluciones.es',
    'Fransuani',
    'Álvarez',
    NULL,
    '602654868',
    NULL,
    'B19963594',
    'Calle de las Dehesillas 2 Local 1',
    '28981',
    'Parla',
    'Madrid',
    'Contratista',
    1,
    '2025-06-20'
);
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
(
    EstadoPlan,
    Orden
)
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
(
    EstadoPresu,
    Orden
)
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
(
    CatServicio
)
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
(
    CatSistema
)
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
(
    TipoActividad
)
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
(
    TipoDoc
)
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
(
    TipoEspacio,
    Activo
)
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
(
    TipoPropiedad,
    PrefijoPropiedad,
    Activo
)
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
        CONSTRAINT DF_Tipos_Servicios_Activo DEFAULT 1,
);
GO

-- SEGURIDAD será el único tipo de servicio desactivado
INSERT INTO Tipos_Servicios
(
    COD_CatServicio,
    TipoServicio,
    Activo
)
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
        CONSTRAINT DF_Tipos_Sistemas_Activo DEFAULT 1,
);
GO



-- ALARMA será el único tipo de sistema desactivado
INSERT INTO TIPOS_SISTEMAS
(
    COD_CatSistema,
    TipoSistema,
    Activo
)
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






/* Consulta para ver a qué propiedad pertenece cada espacio*/

-- -------------------------------------------------------------------
--      2.15. DOCUMENTOS
-- -------------------------------------------------------------------








-- -------------------------------------------------------------------
--      2.16. SERVICIOS
-- -------------------------------------------------------------------



-- -------------------------------------------------------------------
--      2.17. SISTEMAS
-- -------------------------------------------------------------------




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






-- -------------------------------------------------------------------
--      2.19. PLANIFICACION
-- -------------------------------------------------------------------







-- ===================================================================
--      3. PROCEDIMIENTOS ALMACENADOS
-- ===================================================================




