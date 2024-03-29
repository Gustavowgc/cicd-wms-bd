﻿-- =============================================
-- Autor:	pablo.aguilar
-- Fecha de Creacion: 	2017-02-21 @ Team ERGON - Sprint ERGON III
-- Description:	 Consulta de clientes por regimen de inventario.




/*
-- Ejemplo de Ejecucion:
				EXEC [wms].[OP_WMS_SP_GET_CLIENTS_BY_WAREHOUSE_CLIENT_LOCATION_OR_ZONE]   @WAREHOUSE = 'BODEGA_04' ,@REGIMEN = 'GENERAL' , @LOCATION = 'B04-TB-C02-NU'
*/
-- =============================================
CREATE PROCEDURE [wms].[OP_WMS_SP_GET_CLIENTS_BY_WAREHOUSE_CLIENT_LOCATION_OR_ZONE] (@WAREHOUSE VARCHAR(MAX),
@REGIMEN VARCHAR(50),
@ZONE VARCHAR(MAX) = NULL,
@LOCATION VARCHAR(MAX) = NULL)
AS
BEGIN
  SET NOCOUNT ON;
  --
  SELECT
    [W].[VALUE] [CODE_WAREHOUSE] INTO #WAREHOUSE
  FROM [wms].[OP_WMS_FN_SPLIT](@WAREHOUSE, '|') [W]

  SELECT
    [Z].[VALUE] [CODE_ZONE] INTO #ZONE
  FROM [wms].[OP_WMS_FN_SPLIT](@WAREHOUSE, '|') [Z]

  SELECT
    [L].[VALUE] [LOCATION] INTO #LOCATION
  FROM [wms].[OP_WMS_FN_SPLIT](@LOCATION, '|') [L]

  --
  SELECT
    [C].[CLIENT_CODE]
   ,[C].[CLIENT_NAME]
   ,[C].[CLIENT_ROUTE]
   ,[C].[CLIENT_CLASS]
   ,[C].[CLIENT_STATUS]
   ,[C].[CLIENT_REGION]
   ,[C].[CLIENT_ADDRESS]
   ,[C].[CLIENT_CA]
   ,[C].[CLIENT_ERP_CODE]
  FROM [wms].[OP_WMS_INV_X_LICENSE] [IL]
  INNER JOIN [wms].[OP_WMS_LICENSES] [L]
    ON [L].[LICENSE_ID] = [IL].[LICENSE_ID]
  INNER JOIN [wms].[OP_WMS_SHELF_SPOTS] [S]
    ON [S].[LOCATION_SPOT] = [L].[CURRENT_LOCATION]
  INNER JOIN [#WAREHOUSE] [W]
    ON [S].[WAREHOUSE_PARENT] = [W].[CODE_WAREHOUSE]
  INNER JOIN [wms].[OP_WMS_VIEW_CLIENTS] [C]
    ON [C].[CLIENT_CODE] = [L].[CLIENT_OWNER]
  LEFT JOIN [#ZONE] [Z]
    ON [Z].[CODE_ZONE] = [S].[ZONE]
  LEFT JOIN [#LOCATION] [LS]
    ON [LS].[LOCATION] = [L].[CURRENT_LOCATION]
  WHERE [IL].[QTY] > 0
  AND [L].[REGIMEN] = @REGIMEN
  AND (@ZONE IS NULL
  OR [Z].[CODE_ZONE] IS NOT NULL)
  AND (@LOCATION IS NULL
  OR [LS].[LOCATION] IS NOT NULL)

  GROUP BY  [C].[CLIENT_CODE]
   ,[C].[CLIENT_NAME]
   ,[C].[CLIENT_ROUTE]
   ,[C].[CLIENT_CLASS]
   ,[C].[CLIENT_STATUS]
   ,[C].[CLIENT_REGION]
   ,[C].[CLIENT_ADDRESS]
   ,[C].[CLIENT_CA]
   ,[C].[CLIENT_ERP_CODE]
END