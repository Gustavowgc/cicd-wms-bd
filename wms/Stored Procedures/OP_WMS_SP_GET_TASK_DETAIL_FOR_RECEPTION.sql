﻿-- =============================================
-- Autor:                 rudi.garcia
-- Fecha de Creacion:   2017-01-13 @ TeamErgon Sprint Ergon III
-- Description:          SP que obtiene el detalle de las recepciones desde una tarea.
-- Autor:                hector.gonzalez
-- Fecha de Creacion:   2017-03-13 @ TeamErgon Sprint Ergon V
-- Description:          Se agrego case cuando QTY_DOC viene NULL 
-- Modificación: pablo.aguilar
-- Fecha de Modificación: 2017-05-17 ErgonTeam@Sheik
-- Description:     Se estandariza los nombres de los campos del resultado.
/*
-- Ejemplo de Ejecucion:
        EXEC [wms].[OP_WMS_SP_GET_TASK_DETAIL_FOR_RECEPTION_1]
          @SERIAL_NUMBER = 13386          
		EXEC [wms].[OP_WMS_SP_GET_TASK_DETAIL_FOR_RECEPTION]
          @SERIAL_NUMBER = 13386
		  SELECT * FROM [wms].OP_WMS_TASK_LIST
*/
-- =============================================
CREATE PROCEDURE [wms].[OP_WMS_SP_GET_TASK_DETAIL_FOR_RECEPTION] (@SERIAL_NUMBER INT)
AS
IF NOT EXISTS ( SELECT TOP 1
					1
				FROM
					[wms].[OP_WMS_ERP_RECEPTION_DOCUMENT_HEADER]
				WHERE
					[TASK_ID] = @SERIAL_NUMBER )
BEGIN
	SELECT
		[IL].[MATERIAL_ID]
		,[IL].[MATERIAL_NAME]
		,SUM([IL].[ENTERED_QTY]) AS [QTY]
		,0 AS [QTY_DOC]
		,0 AS [QTY_DIFFERENCE]
		,MAX([T].[TASK_COMMENTS]) AS [TASK_COMMENTS]
		,[IL].[BARCODE_ID]
		,MAX([T].[SERIAL_NUMBER]) AS [SERIAL_NUMBER]
		,MAX([T].[CODIGO_POLIZA_TARGET]) AS [CODIGO_POLIZA_TARGET]
		,MAX([T].[CODIGO_POLIZA_SOURCE]) AS [CODIGO_POLIZA_SOURCE]
	FROM
		[wms].[OP_WMS_TASK_LIST] [T]
	INNER JOIN [wms].[OP_WMS_LICENSES] [L] ON ([L].[CODIGO_POLIZA] = [T].[CODIGO_POLIZA_SOURCE])
	INNER JOIN [wms].[OP_WMS_INV_X_LICENSE] [IL] ON ([IL].[LICENSE_ID] = [L].[LICENSE_ID])
	WHERE
		[T].[SERIAL_NUMBER] = @SERIAL_NUMBER
	GROUP BY
		[IL].[MATERIAL_ID]
		,[IL].[MATERIAL_NAME]
		,[IL].[BARCODE_ID];
END;
ELSE
BEGIN
	DECLARE	@RESULT AS TABLE (
			[MATERIAL_ID] VARCHAR(50)
			,[MATERIAL_NAME] VARCHAR(200)
			,[QTY] NUMERIC(18, 4)
			,[QTY_DOC] NUMERIC(18, 4)
			,[QTY_DIFFERENCE] NUMERIC(18, 4)
			,[TASK_COMMENTS] VARCHAR(50)
			,[BARCODE_ID] VARCHAR(25)
			,[SERIAL_NUMBER] INT
			,[CODIGO_POLIZA_TARGET] VARCHAR(25)
			,[CODIGO_POLIZA_SOURCE] VARCHAR(25)
			,[UNIT] VARCHAR(100)
		);

	SELECT
		[RDD].[MATERIAL_ID]
		,SUM([RDD].[QTY] * ISNULL([UMM].[QTY], 1)) [QTY]
		,[RDD].[ERP_RECEPTION_DOCUMENT_HEADER_ID]
	INTO
		[#RECEPTION_DETAIL]
	FROM
		[wms].[OP_WMS_ERP_RECEPTION_DOCUMENT_HEADER] [RDH]
	INNER JOIN [wms].[OP_WMS_ERP_RECEPTION_DOCUMENT_DETAIL] [RDD] ON [RDD].[ERP_RECEPTION_DOCUMENT_HEADER_ID] = [RDH].[ERP_RECEPTION_DOCUMENT_HEADER_ID]
	LEFT JOIN [wms].[OP_WMS_UNIT_MEASUREMENT_BY_MATERIAL] [UMM] ON [UMM].[MATERIAL_ID] = [RDD].[MATERIAL_ID]
											AND [RDD].[UNIT] = [UMM].[MEASUREMENT_UNIT]
	WHERE
		[RDH].[TASK_ID] = @SERIAL_NUMBER
	GROUP BY
		[RDD].[MATERIAL_ID]
		,[RDD].[ERP_RECEPTION_DOCUMENT_HEADER_ID];

	INSERT	INTO @RESULT
			(
				[MATERIAL_ID]
				,[MATERIAL_NAME]
				,[QTY]
				,[QTY_DOC]
				,[QTY_DIFFERENCE]
				,[TASK_COMMENTS]
				,[BARCODE_ID]
				,[SERIAL_NUMBER]
				,[CODIGO_POLIZA_TARGET]
				,[CODIGO_POLIZA_SOURCE]
				,[UNIT]
			)
	(SELECT
			[M].[MATERIAL_ID] AS [MATERIAL_ID]
			,[M].[MATERIAL_NAME] AS [MATERIAL_NAME]
			,SUM(ISNULL([TR].[QUANTITY_UNITS], 0)) AS [QTY]
			,CAST(MAX([RDD].[QTY]) AS NUMERIC(18, 4)) AS [QTY_DOC]
			,0 [QTY_DIFFERENCE]
			,MAX(CAST([H].[TASK_ID] AS VARCHAR)) AS [TASK_COMMENTS]
			,[M].[BARCODE_ID] AS [BARCODE_ID]
			,MAX([H].[TASK_ID]) AS [SERIAL_NUMBER]
			,CAST(MAX([H].[DOC_ID_POLIZA]) AS VARCHAR(25)) AS [CODIGO_POLIZA_TARGET]
			,CAST(MAX([H].[DOC_ID_POLIZA]) AS VARCHAR(25)) AS [CODIGO_POLIZA_SOURCE]
			,'Unidad Base'
		FROM
			[#RECEPTION_DETAIL] [RDD]
		INNER JOIN [wms].[OP_WMS_ERP_RECEPTION_DOCUMENT_HEADER] [H] ON [RDD].[ERP_RECEPTION_DOCUMENT_HEADER_ID] = [H].[ERP_RECEPTION_DOCUMENT_HEADER_ID]
		LEFT JOIN [wms].[OP_WMS_TRANS] [TR] ON [TR].[MATERIAL_CODE] = [RDD].[MATERIAL_ID]
											AND [TR].[TASK_ID] = [H].[TASK_ID]
											AND [TR].[TRANS_TYPE] = 'INGRESO_GENERAL'
											AND [TR].[STATUS] = 'PROCESSED'
		INNER JOIN [wms].[OP_WMS_MATERIALS] [M] ON [M].[MATERIAL_ID] = [RDD].[MATERIAL_ID]
		WHERE
			[H].[TASK_ID] = @SERIAL_NUMBER
		GROUP BY
			[M].[MATERIAL_ID]
			,[M].[MATERIAL_NAME]
			,[M].[BARCODE_ID]
		UNION
		SELECT
			[M].[MATERIAL_ID] AS [MATERIAL_ID]
			,[M].[MATERIAL_NAME] AS [MATERIAL_NAME]
			,SUM(ISNULL([T].[QUANTITY_UNITS], 0)) AS [QTY]
			,CAST(SUM([RDD].[QTY]) * MIN(ISNULL([UMM].[QTY],
											1)) AS NUMERIC(18,
											4)) AS [QTY_DOC]
			,0 [QTY_DIFFERENCE]
			,MAX(CAST([RDH].[TASK_ID] AS VARCHAR)) AS [TASK_COMMENTS]
			,[M].[BARCODE_ID] AS [BARCODE_ID]
			,MAX([RDH].[TASK_ID]) AS [SERIAL_NUMBER]
			,MAX([T].[CODIGO_POLIZA]) AS [CODIGO_POLIZA_TARGET]
			,MAX([T].[CODIGO_POLIZA]) AS [CODIGO_POLIZA_SOURCE]
			,[RDD].[UNIT]
		FROM
			[wms].[OP_WMS_ERP_RECEPTION_DOCUMENT_HEADER] [RDH]
		INNER JOIN [wms].[OP_WMS_TRANS] [T] ON [RDH].[TASK_ID] = [T].[TASK_ID]
											AND [T].[TRANS_TYPE] = 'INGRESO_GENERAL'
											AND [T].[STATUS] = 'PROCESSED'
		LEFT JOIN [wms].[OP_WMS_ERP_RECEPTION_DOCUMENT_DETAIL] [RDD] ON [RDD].[ERP_RECEPTION_DOCUMENT_HEADER_ID] = [RDH].[ERP_RECEPTION_DOCUMENT_HEADER_ID]
											AND [T].[MATERIAL_CODE] = [RDD].[MATERIAL_ID]
		INNER JOIN [wms].[OP_WMS_MATERIALS] [M] ON [T].[MATERIAL_CODE] = [M].[MATERIAL_ID]
		LEFT JOIN [wms].[OP_WMS_UNIT_MEASUREMENT_BY_MATERIAL] [UMM] ON (
											[UMM].[MATERIAL_ID] = [RDD].[MATERIAL_ID]
											AND [RDD].[UNIT] = [UMM].[MEASUREMENT_UNIT]
											)
		WHERE
			[RDH].[TASK_ID] = @SERIAL_NUMBER
			AND [RDD].[ERP_RECEPTION_DOCUMENT_DETAIL_ID] IS NULL
		GROUP BY
			[M].[MATERIAL_ID]
			,[M].[MATERIAL_NAME]
			,[M].[BARCODE_ID]
			,[RDD].[UNIT]);

	SELECT
		[MATERIAL_ID]
		,MAX([MATERIAL_NAME]) AS [MATERIAL_NAME]
		,MAX([QTY]) AS [QTY]
		,SUM([QTY_DOC]) AS [QTY_DOC]
		,CASE	WHEN SUM([QTY_DOC]) - MAX([QTY]) = 0 THEN 0
				WHEN SUM([QTY_DOC]) - MAX([QTY]) > 0
				THEN (SUM([QTY_DOC]) - MAX([QTY])) * -1
				WHEN SUM([QTY_DOC]) - MAX([QTY]) < 0
				THEN (SUM([QTY_DOC]) - MAX([QTY])) * -1
				WHEN SUM([QTY_DOC]) IS NULL
				THEN (0 - SUM([QTY_DOC])) * -1
			END [QTY_DIFFERENCE]
		,SUM([QTY_DIFFERENCE]) AS [QTY_DIFFERENCE]
		,MAX([TASK_COMMENTS]) AS [TASK_COMMENTS]
		,MAX([BARCODE_ID]) AS [BARCODE_ID]
		,MAX([SERIAL_NUMBER]) AS [SERIAL_NUMBER]
		,MAX([CODIGO_POLIZA_TARGET]) AS [CODIGO_POLIZA_TARGET]
		,MAX([CODIGO_POLIZA_SOURCE]) AS [CODIGO_POLIZA_SOURCE]
	FROM
		@RESULT
	GROUP BY
		[MATERIAL_ID];

END;