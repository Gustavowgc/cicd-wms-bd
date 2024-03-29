﻿-- =============================================
-- Autor:	pablo.aguilar
-- Fecha de Creacion: 	2017-01-25 @ Team ERGON - Sprint ERGON II
-- Description:	 PROCEDIMIENTO QUE OBTIENE TODAS los materiales con sus UNIDADES DE MEDIDA 




/*
-- Ejemplo de Ejecucion:
			EXEC [wms].[OP_WMS_SP_GET_MATERIALS_WITH_MEASUREMENT_UNIT] @MASTER_PACK_MATERIAL_ID  = 'wms/RD001',  @CLIENT_ID = 'wms'
*/
-- =============================================
CREATE PROCEDURE [wms].[OP_WMS_SP_GET_MATERIALS_WITH_MEASUREMENT_UNIT] (@MASTER_PACK_MATERIAL_ID VARCHAR(50)
, @CLIENT_ID VARCHAR(50) = NULL)
AS
BEGIN
  SET NOCOUNT ON;
  --
  SELECT
    [M].[CLIENT_ID]
   ,[M].[MATERIAL_ID]
   ,[OWM].[MATERIAL_NAME]
   ,[OWM].[BARCODE_ID]
   ,[M].[MEASUREMENT_UNIT] [MEASURE_NAME]
   ,[M].[MEASUREMENT_UNIT_ID]
   ,0 [IS_SELECT]
   , [M].[QTY]
  FROM [wms].[OP_WMS_UNIT_MEASUREMENT_BY_MATERIAL] [M]
  INNER JOIN [wms].[OP_WMS_MATERIALS] [OWM]
    ON [M].[MATERIAL_ID] = [OWM].[MATERIAL_ID]
  LEFT JOIN [wms].[OP_WMS_COMPONENTS_BY_MASTER_PACK] [CM]
    ON [CM].[MASTER_PACK_CODE] = @MASTER_PACK_MATERIAL_ID AND [CM].[COMPONENT_MATERIAL] = [M].[MATERIAL_ID] 

  WHERE [CM].[MASTER_PACK_COMPONENT_ID] IS NULL
    AND [OWM].[IS_MASTER_PACK] = 0
  AND (@CLIENT_ID IS NULL
  OR [M].[CLIENT_ID] = @CLIENT_ID)




END