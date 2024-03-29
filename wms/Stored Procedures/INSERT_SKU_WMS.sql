﻿

-- =============================================
-- Autor:	pablo.aguilar
-- Fecha de Creacion: 	2017-01-31 @ Team ERGON - Sprint ERGON II
-- Description:	 NA




/*
-- Ejemplo de Ejecucion:
			EXEC [wms].INSERT_SKU_WMS
*/
-- =============================================  
CREATE PROCEDURE [wms].INSERT_SKU_WMS
AS
  MERGE [wms].[OP_WMS_MATERIALS] OWM
  USING (SELECT
      CLIENT_OWNER
     ,MATERIAL_ID
     ,BARCODE_ID
     ,ALTERNATE_BARCODE
     ,MATERIAL_NAME
     ,SHORT_NAME
     ,VOLUME_FACTOR
     ,MATERIAL_CLASS
     ,HIGH
     ,LENGTH
     ,WIDTH
     ,MAX_X_BIN
     ,SCAN_BY_ONE
     ,REQUIRES_LOGISTICS_INFO
     ,WEIGTH
     ,IMAGE_1
     ,IMAGE_2
     ,IMAGE_3
     ,LAST_UPDATED
     ,LAST_UPDATED_BY
     ,IS_CAR
     ,MT3
     ,BATCH_REQUESTED
     ,SERIAL_NUMBER_REQUESTS
     ,ERP_AVERAGE_PRICE
    FROM [wms].VIEW_SKU_ERP) AS ISW
  ON OWM.MATERIAL_ID = ISW.MATERIAL_ID COLLATE database_default
  WHEN MATCHED
    THEN UPDATE

      SET OWM.[CLIENT_OWNER] = ISW.[CLIENT_OWNER]
         ,OWM.[MATERIAL_ID] = ISW.[MATERIAL_ID]
         ,OWM.[BARCODE_ID] = ISW.[BARCODE_ID]
         ,OWM.[ALTERNATE_BARCODE] = ISW.[ALTERNATE_BARCODE]
         ,OWM.[MATERIAL_NAME] = ISW.[MATERIAL_NAME]
         ,OWM.[SHORT_NAME] = ISW.[SHORT_NAME]
         ,OWM.[VOLUME_FACTOR] = ISW.[VOLUME_FACTOR]
         ,OWM.[MATERIAL_CLASS] = ISW.[MATERIAL_CLASS]
         ,OWM.[HIGH] = ISW.[HIGH]
         ,OWM.[LENGTH] = ISW.[LENGTH]
         ,OWM.[WIDTH] = ISW.[WIDTH]
         ,OWM.[MAX_X_BIN] = ISW.[MAX_X_BIN]
         ,OWM.[SCAN_BY_ONE] = ISW.[SCAN_BY_ONE]
         ,OWM.[REQUIRES_LOGISTICS_INFO] = ISW.[REQUIRES_LOGISTICS_INFO]
         ,OWM.[WEIGTH] = ISW.[WEIGTH]
         ,OWM.[IMAGE_1] = ISW.[IMAGE_1]
         ,OWM.[IMAGE_2] = ISW.[IMAGE_2]
         ,OWM.[IMAGE_3] = ISW.[IMAGE_3]
         ,OWM.[LAST_UPDATED] = ISW.[LAST_UPDATED]
         ,OWM.[LAST_UPDATED_BY] = ISW.[LAST_UPDATED_BY]
         ,OWM.[IS_CAR] = ISW.[IS_CAR]
         ,OWM.[MT3] = ISW.[MT3]
         ,OWM.[BATCH_REQUESTED] = ISW.[BATCH_REQUESTED]
         ,OWM.[SERIAL_NUMBER_REQUESTS] = ISW.[SERIAL_NUMBER_REQUESTS]
         ,OWM.[ERP_AVERAGE_PRICE] = ISW.[ERP_AVERAGE_PRICE]

  WHEN NOT MATCHED
    THEN INSERT ([CLIENT_OWNER]
      , [MATERIAL_ID]
      , [BARCODE_ID]
      , [ALTERNATE_BARCODE]
      , [MATERIAL_NAME]
      , [SHORT_NAME]
      , [VOLUME_FACTOR]
      , [MATERIAL_CLASS]
      , [HIGH]
      , [LENGTH]
      , [WIDTH]
      , [MAX_X_BIN]
      , [SCAN_BY_ONE]
      , [REQUIRES_LOGISTICS_INFO]
      , [WEIGTH]
      , [IMAGE_1]
      , [IMAGE_2]
      , [IMAGE_3]
      , [LAST_UPDATED]
      , [LAST_UPDATED_BY]
      , [IS_CAR]
      , [MT3]
      , [BATCH_REQUESTED]
      , [SERIAL_NUMBER_REQUESTS]
      , [ERP_AVERAGE_PRICE])
        VALUES ([ISW].[CLIENT_OWNER], [ISW].[MATERIAL_ID], [ISW].[BARCODE_ID], [ISW].[ALTERNATE_BARCODE], [ISW].[MATERIAL_NAME], [ISW].[SHORT_NAME], [ISW].[VOLUME_FACTOR], [ISW].[MATERIAL_CLASS], [ISW].[HIGH], [ISW].[LENGTH], [ISW].[WIDTH], [ISW].[MAX_X_BIN], [ISW].[SCAN_BY_ONE], [ISW].[REQUIRES_LOGISTICS_INFO], [ISW].[WEIGTH], [ISW].[IMAGE_1], [ISW].[IMAGE_2], [ISW].[IMAGE_3], [ISW].[LAST_UPDATED], [ISW].[LAST_UPDATED_BY], [ISW].[IS_CAR], [ISW].[MT3], [ISW].[BATCH_REQUESTED], [ISW].[SERIAL_NUMBER_REQUESTS], [ISW].[ERP_AVERAGE_PRICE]);