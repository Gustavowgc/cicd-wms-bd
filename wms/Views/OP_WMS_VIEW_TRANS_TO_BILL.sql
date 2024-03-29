﻿CREATE VIEW [wms].OP_WMS_VIEW_TRANS_TO_BILL
AS
SELECT     SERIAL, TRANS_WEIGTH, TERMS_OF_TRADE, LOGIN_ID, LOGIN_NAME, TRANS_TYPE, TRANS_DESCRIPTION, MATERIAL_BARCODE, MATERIAL_CODE, 
                      MATERIAL_DESCRIPTION, SOURCE_LICENSE, TARGET_LICENSE, SOURCE_LOCATION, TARGET_LOCATION, CLIENT_OWNER, CLIENT_NAME, QUANTITY_UNITS, 
                      SOURCE_WAREHOUSE, TARGET_WAREHOUSE, CODIGO_POLIZA, LICENSE_ID, STATUS, WAVE_PICKING_ID, NUMERO_ORDEN, TRANS_DATE, REGIMEN, ACTION, 
                      POSTED_TO_ERP_STAMP
FROM         [wms].OP_WMS_VIEW_TRANS_BASIC
WHERE     (POSTED_TO_ERP_STAMP IS NULL)