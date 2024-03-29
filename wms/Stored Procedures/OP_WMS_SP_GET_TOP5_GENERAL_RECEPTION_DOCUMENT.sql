﻿-- =============================================
-- Autor:	              marvin.solares
-- Fecha de Creacion: 	20180912 GForce@Jaguarundi
-- Description:	        Sp que trae el top 5 de los documentos de recepcion general para sap

/*
-- Ejemplo de Ejecucion:
			EXEC [wms].[OP_WMS_SP_GET_TOP5_GENERAL_RECEPTION_DOCUMENT];
				
*/
-- =============================================
CREATE PROCEDURE [wms].[OP_WMS_SP_GET_TOP5_GENERAL_RECEPTION_DOCUMENT]
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT TOP 5
		[RDH].[ERP_RECEPTION_DOCUMENT_HEADER_ID] AS [DocNum]
		,[RDH].[DOC_ID]
		,[RDH].[TYPE]
		,[RDH].[CODE_SUPPLIER]
		,[RDH].[CODE_CLIENT]
		,[RDH].[ERP_DATE]
		,[RDH].[LAST_UPDATE]
		,[RDH].[LAST_UPDATE_BY]
		,[RDH].[ATTEMPTED_WITH_ERROR]
		,[RDH].[IS_POSTED_ERP]
		,[RDH].[POSTED_ERP]
		,[RDH].[POSTED_RESPONSE]
		,[RDH].[ERP_REFERENCE]
		,[RDH].[IS_AUTHORIZED]
		,[RDH].[IS_COMPLETE]
		,[RDH].[TASK_ID]
		,[RDH].[EXTERNAL_SOURCE_ID]
	INTO
		[#RECEPTION_DOCUMENT]
	FROM
		[wms].[OP_WMS_ERP_RECEPTION_DOCUMENT_HEADER] [RDH]
	WHERE
		[RDH].[ERP_RECEPTION_DOCUMENT_HEADER_ID] > 0
		AND ISNULL([RDH].[IS_POSTED_ERP], 0) = 0
		AND ISNULL([RDH].[ATTEMPTED_WITH_ERROR], 0) = 0
		AND ISNULL([RDH].[IS_AUTHORIZED], 0) = 1
		AND [RDH].[IS_FROM_WAREHOUSE_TRANSFER] = 0
		AND [RDH].[IS_VOID] = 0
		AND [RDH].[SOURCE] = 'RECEPCION_GENERAL';

	UPDATE
		[RDH]
	SET	
		[RDH].[IS_SENDING] = 1
		,[RDH].[LAST_UPDATE_IS_SENDING] = GETDATE()
	FROM
		[wms].[OP_WMS_ERP_RECEPTION_DOCUMENT_HEADER] [RDH]
	INNER JOIN [#RECEPTION_DOCUMENT] [RD] ON ([RD].[DocNum] = [RDH].[ERP_RECEPTION_DOCUMENT_HEADER_ID]);

	SELECT
		*
	FROM
		[#RECEPTION_DOCUMENT];
END;
