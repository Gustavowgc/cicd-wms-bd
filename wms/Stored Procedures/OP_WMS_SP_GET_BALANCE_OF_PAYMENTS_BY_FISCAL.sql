﻿-- =============================================
-- Autor:    rudi.garcia
-- Fecha de Creacion:     2017-07-5 @ Team Epona 
-- Description:     Sp que que obtiene el balance de saldos
-- Autor:                rudi.garcia
-- Fecha de Creacion:     31-08-2017 @Team ERGON - Sprint Collin
-- Description:            Se puso aparte la consulta de obtener los saldos para luego solo utilizarlo en la [OP_WMS_INV_X_LICENSE]
/*
-- Ejemplo de Ejecucion:
            EXEC [wms].OP_WMS_SP_GET_BALANCE_OF_PAYMENTS_BY_FISCAL @LOGIN = 'ADMIN'
   
*/
-- =============================================
CREATE PROCEDURE [wms].OP_WMS_SP_GET_BALANCE_OF_PAYMENTS_BY_FISCAL (@LOGIN VARCHAR(25))
AS
BEGIN
  SET NOCOUNT ON;
  -- SE OBTIENEN BODEGAS DE USUARIO LOGUEADO 
  DECLARE @POLIZA TABLE (
    [DOC_ID] NUMERIC
   ,[CODIGO_POLIZA] VARCHAR(25)
   ,[NUMERO_ORDEN] VARCHAR(25)
   ,[FECHA_DOCUMENTO] DATETIME
   ,[REGIMEN] VARCHAR(15)
   ,[LICENSE_ID] INT
   ,[MATERIAL_ID] VARCHAR(50)
   ,[LINE_NUMBER] NUMERIC
   ,[CUSTOMS_AMOUNT] NUMERIC(18, 2)
   ,[VALOR_UNITARIO_CIF] NUMERIC(38, 6)
   ,[VALOR_UNITARIO_IMPUESTO] NUMERIC(38, 6)
  )
  DECLARE @WAREHOUSES TABLE (
    WAREHOUSE_ID VARCHAR(25)
   ,NAME VARCHAR(50)
   ,COMMENTS VARCHAR(150)
   ,ERP_WAREHOUSE VARCHAR(50)
   ,ALLOW_PICKING NUMERIC
   ,DEFAULT_RECEPTION_LOCATION VARCHAR(25)
   ,SHUNT_NAME VARCHAR(25)
   ,WAREHOUSE_WEATHER VARCHAR(50)
   ,WAREHOUSE_STATUS INT
   ,IS_3PL_WAREHUESE INT
   ,WAHREHOUSE_ADDRESS VARCHAR(250)
   ,GPS_URL VARCHAR(100)
   ,WAREHOUSE_BY_USER_ID INT
  )
  INSERT INTO @WAREHOUSES
  EXEC [wms].[OP_WMS_SP_GET_WAREHOUSE_ASSOCIATED_WITH_USER] @LOGIN_ID = @LOGIN
  -----
  INSERT INTO @POLIZA ([DOC_ID], [CODIGO_POLIZA], [NUMERO_ORDEN], [FECHA_DOCUMENTO], [REGIMEN], [LICENSE_ID], [MATERIAL_ID], [LINE_NUMBER], [CUSTOMS_AMOUNT], [VALOR_UNITARIO_CIF], [VALOR_UNITARIO_IMPUESTO])
    SELECT

      [PH].[DOC_ID]
     ,[PH].[CODIGO_POLIZA]
     ,[PH].[NUMERO_ORDEN]
     ,[PH].[FECHA_DOCUMENTO]
     ,[PH].[REGIMEN]
     ,[PTM].[LICENSE_ID]

     ,[PTM].[MATERIAL_CODE]
     ,[PD].[LINE_NUMBER]
     ,[PD].[CUSTOMS_AMOUNT]
     ,CASE [PD].[BULTOS]
        WHEN 0 THEN 0
        ELSE ([PD].[CUSTOMS_AMOUNT] / [PD].[BULTOS])
      END AS [VALOR_UNITARIO_CIF]
     ,CASE [PD].[CUSTOMS_AMOUNT]
        WHEN 0 THEN 0
        WHEN NULL THEN 0
        ELSE (([PD].[IVA] + [PD].[DAI]) / [PD].[BULTOS])
      END AS [VALOR_UNITARIO_IMPUESTO]
    FROM [wms].[OP_WMS3PL_POLIZA_TRANS_MATCH] [PTM]
    INNER JOIN [wms].[OP_WMS_POLIZA_HEADER] [PH]
      ON (
      [PH].[DOC_ID] = [PTM].[DOC_ID]
      )
    INNER JOIN [wms].[OP_WMS_POLIZA_DETAIL] [PD]
      ON (
      [PD].[DOC_ID] = [PH].[DOC_ID]
      AND [PD].[LINE_NUMBER] = [PTM].[LINENO_POLIZA]
      )
    --
    WHERE [PH].[TIPO] = 'INGRESO'
    AND [PH].[WAREHOUSE_REGIMEN] = 'FISCAL'

  --AND ([T].[TRANS_TYPE] = 'INGRESO_FISCAL' OR [T].[TRANS_TYPE] = 'INICIALIZACION_FISCAL' OR [T].[TRANS_TYPE] = 'REUBICACION_PARCIAL')
  --     [TRP].[TRANS_TYPE] = 'REUBICACION_PARCIAL')
  --    WHERE [T].CODIGO_POLIZA = '105728092017'
  --    AND [T].[STATUS] = 'PROCESSED'

  INSERT INTO @POLIZA ([DOC_ID], [CODIGO_POLIZA], [NUMERO_ORDEN], [FECHA_DOCUMENTO], [REGIMEN], [LICENSE_ID], [MATERIAL_ID], [LINE_NUMBER], [CUSTOMS_AMOUNT], [VALOR_UNITARIO_CIF], [VALOR_UNITARIO_IMPUESTO])
    SELECT
      [PH].[DOC_ID]
     ,[PH].[CODIGO_POLIZA]
     ,[PH].[NUMERO_ORDEN]
     ,[PH].[FECHA_DOCUMENTO]
     ,[PH].[REGIMEN]
     ,[T].[LICENSE_ID]
     ,[PTM].[MATERIAL_CODE]
     ,[PD].[LINE_NUMBER]
     ,[PD].[CUSTOMS_AMOUNT]
     ,CASE [PD].[BULTOS]
        WHEN 0 THEN 0
        ELSE ([PD].[CUSTOMS_AMOUNT] / [PD].[BULTOS])
      END AS [VALOR_UNITARIO_CIF]
     ,CASE [PD].[CUSTOMS_AMOUNT]
        WHEN 0 THEN 0
        WHEN NULL THEN 0
        ELSE (([PD].[IVA] + [PD].[DAI]) / [PD].[BULTOS])
      END AS [VALOR_UNITARIO_IMPUESTO]
    FROM [wms].[OP_WMS_TRANS] [T]
    INNER JOIN [wms].[OP_WMS3PL_POLIZA_TRANS_MATCH] [PTM]
      ON (
      [PTM].[LICENSE_ID] = [T].[ORIGINAL_LICENSE]
      AND [PTM].[MATERIAL_CODE] = [T].[MATERIAL_CODE]
      )
    INNER JOIN [wms].[OP_WMS_POLIZA_HEADER] [PH]
      ON (
      [PH].[DOC_ID] = [PTM].[DOC_ID]
      )
    INNER JOIN [wms].[OP_WMS_POLIZA_DETAIL] [PD]
      ON (
      [PD].[DOC_ID] = [PH].[DOC_ID]
      AND [PD].[LINE_NUMBER] = [PTM].[LINENO_POLIZA]
      )
    WHERE [T].[STATUS] = 'PROCESSED'


  --
  SELECT
    [C].[CLIENT_NAME]
   ,[P].[DOC_ID]
   ,[P].[CODIGO_POLIZA]
   ,[P].[NUMERO_ORDEN]
   ,[P].[FECHA_DOCUMENTO]
   ,[IL].[MATERIAL_NAME]
   ,[IL].[LICENSE_ID]
   ,[P].[LINE_NUMBER]
   ,[IL].[QTY] AS [BULTOS]
   ,[P].[CUSTOMS_AMOUNT] AS [CUSTOMS_AMOUNT]
   ,[IL].[QTY] * [P].[VALOR_UNITARIO_CIF] AS [VALOR_CIF]
   ,CASE [P].[CUSTOMS_AMOUNT]
      WHEN 0 THEN 0
      ELSE [IL].[QTY] * [P].[VALOR_UNITARIO_IMPUESTO]
    END AS IMPUESTO
   ,[P].[REGIMEN] AS REGIMEN_DOCUMENTO
   ,[CG].[SPARE1] AS GRUPO_REGIMEN
  FROM [wms].[OP_WMS_INV_X_LICENSE] [IL]
  INNER JOIN [wms].[OP_WMS_LICENSES] [L]
    ON (
    [IL].[LICENSE_ID] = [L].[LICENSE_ID]
    )
  INNER JOIN @WAREHOUSES [W]
    ON (
    [W].[WAREHOUSE_ID] = [L].[CURRENT_WAREHOUSE] COLLATE database_default
    )
  INNER JOIN [wms].[OP_WMS_VIEW_CLIENTS] [C]
    ON (
    [C].[CLIENT_CODE] = [L].[CLIENT_OWNER]
    )
  INNER JOIN @POLIZA [P]
    ON (
    [P].[LICENSE_ID] = [IL].[LICENSE_ID]
    AND [P].[MATERIAL_ID] = [IL].[MATERIAL_ID]
    )
  INNER JOIN [wms].[OP_WMS_CONFIGURATIONS] [CG]
    ON (
    [P].[REGIMEN] = [CG].[PARAM_NAME]
    AND [CG].[PARAM_GROUP] = 'REGIMEN'
    )
  WHERE [L].[REGIMEN] = 'FISCAL'
  AND [IL].[QTY] > 0
--  GROUP BY [C].[CLIENT_NAME]
--          ,[PH].[DOC_ID]
--          ,[PH].[CODIGO_POLIZA]
--          ,[PH].[NUMERO_ORDEN]
--          ,[PH].[FECHA_DOCUMENTO]
--          ,[IL].[MATERIAL_NAME]
--          ,[IL].[LICENSE_ID]
--           --,[PD].[LINE_NUMBER]
--          ,[PH].[REGIMEN]
--          ,[CG].[SPARE1]
END