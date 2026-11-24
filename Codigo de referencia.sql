/* ****************************************************
                 CÓDIGOS DE REFERENCIA
***************************************************** */



-- Para eliminar una tabla vinculada con tabla histórica:
ALTER TABLE Clientes
SET (SYSTEM_VERSIONING = OFF);
GO

DROP TABLE Clientes;
GO

DROP TABLE Clientes_Historico;
GO


-- Para eliminar triggers
DROP TRIGGER IF EXISTS TRG_Servicios_RefServicio;
GO

    -- comprobar que ha sido eliminado
SELECT *
FROM sys.triggers
WHERE name = 'TRG_Servicios_RefServicio';
GO