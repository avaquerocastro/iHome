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


