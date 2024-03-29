﻿-- =============================================
-- Autor:	pablo.aguilar
-- Fecha de Creacion: 	2017-02-20 @ Team ERGON - Sprint ERGON 1
-- Description:	 Obtener ubicaciones para conteo fisico detalle 




/*
-- Ejemplo de Ejecucion:
			EXEC [wms].[OP_WMS_SP_GET_LOCATIONS_FOR_PHISICAL_COUNT_BY_FILTERS]  @WAREHOUSE = 'BODEGA_04' ,@REGIMEN = 'GENERAL'
 , @CLIENT_CODE = 'C00030', @MATERIAL = 'C00030/LECHE-CONDE'  , @LOCATION = 'B04-TA-C03-NU|B04-TA-C07-NU|B04-TA-C08-NU' ,@EMPTY_LOCATIONS = 1

    EXEC [wms].OP_WMS_SP_GET_LOCATIONS_FOR_PHISICAL_COUNT_BY_FILTERS @WAREHOUSE = N'BODEGA_02'
                                                                  ,@REGIMEN = N'GENERAL'
                                                                  ,@ZONE = N'BODEGA_02'
*/
-- =============================================
CREATE PROCEDURE [wms].[OP_WMS_SP_GET_LOCATIONS_FOR_PHISICAL_COUNT_BY_FILTERS] (@WAREHOUSE VARCHAR(MAX),
@REGIMEN VARCHAR(50),
@ZONE VARCHAR(MAX) = NULL,
@CLIENT_CODE VARCHAR(MAX) = NULL,
@LOCATION VARCHAR(MAX) = NULL,
@MATERIAL VARCHAR(MAX) = NULL,
@EMPTY_LOCATIONS INT = 0)
AS
BEGIN
  SET NOCOUNT ON;
  --

  SELECT
    [W].[VALUE] [CODE_WAREHOUSE] INTO #WAREHOUSE
  FROM [wms].[OP_WMS_FN_SPLIT](@WAREHOUSE, '|') [W]

  SELECT
    [Z].[VALUE] [CODE_ZONE] INTO #ZONE
  FROM [wms].[OP_WMS_FN_SPLIT](@ZONE, '|') [Z]

  SELECT
    [C].[VALUE] [CODE_CLIENT] INTO #CLIENT
  FROM [wms].[OP_WMS_FN_SPLIT](@CLIENT_CODE, '|') [C]

  SELECT
    [L].[VALUE] [LOCATION] INTO #LOCATION
  FROM [wms].[OP_WMS_FN_SPLIT](@LOCATION, '|') [L]

  SELECT
    [M].[VALUE] [MATERIAL] INTO #MATERIAL
  FROM [wms].[OP_WMS_FN_SPLIT](@MATERIAL, '|') [M]



  SELECT
    [S].[LOCATION_SPOT]
   ,[S].[WAREHOUSE_PARENT] 
   ,[M].[MATERIAL_ID]
   ,[M].[MATERIAL_NAME]
   ,[M].[CLIENT_OWNER] [CLIENT_CODE]
   ,[VC].[CLIENT_NAME]
   ,[S].[ZONE]
   ,[L].[REGIMEN] INTO #INVENTORY_LOCATIONS
  FROM [wms].[OP_WMS_INV_X_LICENSE] [IL]
  INNER JOIN [wms].[OP_WMS_LICENSES] [L]
    ON [L].[LICENSE_ID] = [IL].[LICENSE_ID]
  INNER JOIN [wms].[OP_WMS_SHELF_SPOTS] [S]
    ON [S].[LOCATION_SPOT] = [L].[CURRENT_LOCATION]
  INNER JOIN [#WAREHOUSE] [W]
    ON [S].[WAREHOUSE_PARENT] = [W].[CODE_WAREHOUSE]
  LEFT JOIN [#ZONE] [Z]
    ON [Z].[CODE_ZONE] = [S].[ZONE]
  LEFT JOIN [#CLIENT] [C]
    ON [C].[CODE_CLIENT] = [L].[CLIENT_OWNER]
  INNER JOIN [wms].[OP_WMS_MATERIALS] [M]
    ON [M].[MATERIAL_ID] = [IL].[MATERIAL_ID]
  INNER JOIN [wms].[OP_WMS_VIEW_CLIENTS] [VC]
    ON [L].[CLIENT_OWNER] = [VC].[CLIENT_CODE]
  LEFT JOIN [#LOCATION] [LS]
    ON [LS].[LOCATION] = [L].[CURRENT_LOCATION]
  LEFT JOIN [#MATERIAL] [M1]
    ON [IL].[MATERIAL_ID] = [M1].[MATERIAL]
  WHERE [IL].[QTY] > 0
    AND @MATERIAL IS NOT NULL 
  AND ([L].[REGIMEN] = @REGIMEN)
  AND (@ZONE IS NULL
  OR [Z].[CODE_ZONE] IS NOT NULL)
  AND (@CLIENT_CODE IS NULL
  OR [C].[CODE_CLIENT] IS NOT NULL)
  AND (@LOCATION IS NULL
  OR [LS].[LOCATION] IS NOT NULL)
  AND (@MATERIAL IS NULL
  OR [M1].[MATERIAL] IS NOT NULL)
  GROUP BY [S].[LOCATION_SPOT]
          ,[S].[WAREHOUSE_PARENT]
          ,[S].[ZONE]
          ,[S].[MAX_MT2_OCCUPANCY]
          ,[L].[REGIMEN]
          ,[M].[MATERIAL_ID]
          ,[M].[MATERIAL_NAME]
          ,[M].[CLIENT_OWNER]
          ,[VC].[CLIENT_NAME]

  SELECT
    [S].[LOCATION_SPOT]
   ,[S].[WAREHOUSE_PARENT] [CODE_WAREHOUSE]
   ,CAST(NULL AS VARCHAR) [MATERIAL_ID]
   ,CAST(NULL AS VARCHAR) [MATERIAL_NAME]
   ,CAST(NULL AS VARCHAR) [CLIENT_CODE]
   ,CAST(NULL AS VARCHAR) [CLIENT_NAME]
   ,[S].[ZONE]
   ,CAST(@REGIMEN AS VARCHAR) [REGIMEN]
  FROM [wms].[OP_WMS_SHELF_SPOTS] [S]
  INNER JOIN [#WAREHOUSE] [W]
    ON [W].[CODE_WAREHOUSE] = [S].[WAREHOUSE_PARENT]
  LEFT JOIN [#ZONE] [Z]
    ON [Z].[CODE_ZONE] = [S].[ZONE]
  LEFT JOIN [#LOCATION] [LS]
    ON [LS].[LOCATION] = [S].[LOCATION_SPOT]
  LEFT JOIN #INVENTORY_LOCATIONS [IL]
    ON [S].[LOCATION_SPOT] = [IL].[LOCATION_SPOT]
  WHERE (@EMPTY_LOCATIONS = 1 OR @MATERIAL IS NULL )
  AND [IL].[LOCATION_SPOT] IS NULL
  AND (@ZONE IS NULL
  OR [Z].[CODE_ZONE] IS NOT NULL)
  AND (@LOCATION IS NULL
  OR [LS].[LOCATION] IS NOT NULL)
  GROUP BY [S].[LOCATION_SPOT]
          ,[S].[WAREHOUSE_PARENT]
          ,[S].[ZONE]
          ,[S].[MAX_MT2_OCCUPANCY]

  UNION
  SELECT
    [IL].[LOCATION_SPOT]
   ,[IL].[WAREHOUSE_PARENT] [CODE_WAREHOUSE]
   ,[IL].[MATERIAL_ID]
   ,[IL].[MATERIAL_NAME]
   ,[IL].[CLIENT_CODE]
   ,[IL].[CLIENT_NAME]
   ,[IL].[ZONE]
   ,[IL].[REGIMEN]
  FROM [#INVENTORY_LOCATIONS] [IL]


END

/*
SELECT * FROM [wms].[OP_WMS_SHELF_SPOTS] [S] 
LEFT JOIN [wms].[OP_WMS_LICENSES] [L]
  ON [L].[CURRENT_LOCATION] = [S].[LOCATION_SPOT]
LEFT JOIN [wms].[OP_WMS_INV_X_LICENSE] [IL]
  ON [IL].[LICENSE_ID] = [L].[LICENSE_ID]

  WHERE [L].[LICENSE_ID] IS NULL  AND [S].[WAREHOUSE_PARENT] = 'BODEGA_04'
*/