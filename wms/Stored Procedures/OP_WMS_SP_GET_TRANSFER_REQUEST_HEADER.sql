﻿-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	16-Aug-17 @ Nexus Team Sprint Banjo-Kazooie 
-- Description:			SP que obtiene una o todas las solicitudes de transferencia

/*
-- Ejemplo de Ejecucion:
				EXEC [wms].[OP_WMS_SP_GET_TRANSFER_REQUEST_HEADER]
					@TRANSFER_REQUEST_ID = 47
*/
-- =============================================
CREATE PROCEDURE [wms].[OP_WMS_SP_GET_TRANSFER_REQUEST_HEADER](
	@TRANSFER_REQUEST_ID INT
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT
		[T].[TRANSFER_REQUEST_ID]
		,[T].[REQUEST_TYPE]
		,ISNULL([C].[PARAM_CAPTION],[T].[REQUEST_TYPE]) [REQUEST_TYPE_DESCRIPTION]
		,[T].[WAREHOUSE_FROM]
		,[W1].[DISTRIBUTION_CENTER_ID] [DISTRIBUTION_CENTER_FROM]
		,[T].[WAREHOUSE_TO]
		,[W2].[DISTRIBUTION_CENTER_ID] [DISTRIBUTION_CENTER_TO]
		,[T].[REQUEST_DATE]
		,[T].[DELIVERY_DATE]
		,[T].[COMMENT]
		,[T].[STATUS]
		,CASE [T].[STATUS]
			WHEN 'OPEN' THEN 'ABIERTA'
			WHEN 'CLOSED' THEN 'CERRADA'
			ELSE [T].[STATUS]
		END [STATUS_DESCRIPTION]
		,[T].[CREATED_BY]
		,[T].[LAST_UPDATE]
		,[T].[LAST_UPDATE_BY]
		,[T].[OWNER]
	FROM [wms].[OP_WMS_TRANSFER_REQUEST_HEADER] [T]
	INNER JOIN [wms].[OP_WMS_WAREHOUSES] [W1] ON [T].[WAREHOUSE_FROM]=[W1].[WAREHOUSE_ID]
	INNER JOIN [wms].[OP_WMS_WAREHOUSES] [W2] ON [T].[WAREHOUSE_TO] = [W2].[WAREHOUSE_ID]
	LEFT JOIN [wms].[OP_WMS_CONFIGURATIONS] [C] ON (
		[C].[PARAM_TYPE] = 'SISTEMA'
		AND [C].[PARAM_GROUP] = 'SOLICITUD_TRASLADO'
		AND [C].[PARAM_NAME] = [T].[REQUEST_TYPE]
	)
	WHERE [T].[TRANSFER_REQUEST_ID] = @TRANSFER_REQUEST_ID
END