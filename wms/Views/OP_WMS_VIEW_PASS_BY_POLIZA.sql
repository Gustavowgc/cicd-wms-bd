﻿CREATE VIEW [wms].OP_WMS_VIEW_PASS_BY_POLIZA
AS
SELECT
  P.CODIGO_POLIZA
 ,M.MATERIAL_ID
 ,M.BARCODE_ID
 ,M.MATERIAL_NAME
 ,P.NUMERO_ORDEN
 ,(T.QUANTITY_UNITS * -1) AS QTY
 ,P.TIPO
 ,PS.PASS_ID
 , '' AS PACKING
 ,[CDD].[CERTIFICATE_DEPOSIT_ID_HEADER]
 ,(SELECT TOP 1  [VUA].[VALOR_UNITARIO] from [wms].[OP_WMS_FUNC_GET_SKU_VALOR_UNITARIO_ALMGEN]([PH].[DOC_ID], '%' + [M].[BARCODE_ID] + '%') VUA) AS UNIT_VALUE
 ,(SELECT TOP 1  [VUA].[VALOR_UNITARIO] * (T.QUANTITY_UNITS * -1) from [wms].[OP_WMS_FUNC_GET_SKU_VALOR_UNITARIO_ALMGEN]([PH].[DOC_ID], '%' + [M].[BARCODE_ID] + '%') VUA) AS TOTAL_LINE 
FROM [wms].OP_WMS_POLIZA_HEADER P
INNER JOIN [wms].OP_WMS_TRANS T ON (
  P.CODIGO_POLIZA = T.CODIGO_POLIZA
)
INNER JOIN [wms].OP_WMS_MATERIALS M ON (
  T.MATERIAL_CODE = M.MATERIAL_ID
)
INNER JOIN [wms].OP_WMS3PL_POLIZA_X_PASS PS ON (
  P.CODIGO_POLIZA = PS.CODE_POLIZA
)
LEFT JOIN [wms].[OP_WMS_LICENSES] [L] ON (
  [L].[LICENSE_ID] = [T].[LICENSE_ID]
)
LEFT JOIN [wms].[OP_WMS_POLIZA_HEADER] [PH] ON(
  [PH].[CODIGO_POLIZA] = [L].[CODIGO_POLIZA]
  AND [PH].[TIPO] = 'INGRESO' 
)
LEFT JOIN [wms].[OP_WMS_CERTIFICATE_DEPOSIT_DETAIL] [CDD] ON (
  [CDD].[DOC_ID] = [PH].[DOC_ID]
)

WHERE P.TIPO = 'EGRESO'
AND T.TRANS_SUBTYPE = 'PICKING'