﻿


CREATE FUNCTION [wms].[OP_WMS_FUNC_GET_PASS_DETAIL]
(	
	@pPASS_ID VARCHAR(25)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		MAX(GETDATE())	FECHA,
		SUM(b.QTY)		CANTIDAD,
		b.BARCODE_ID	CODIGO,
		b.MATERIAL_NAME DESCRIPCION,
		(SELECT SUM(QTY) FROM [wms].OP_WMS_VIEW_AUDIT_DISPATCH 
		WHERE AUDIT_ID  IN (SELECT Z.AUDIT_ID FROM [wms].OP_WMS3PL_AUDITS_X_PASS Z WHERE Z.PASS_ID = @pPASS_ID)) AS GT_QTY
	FROM 
		[wms].OP_WMS_VIEW_AUDIT_DISPATCH b
	WHERE 
		b.AUDIT_ID IN (SELECT Z.AUDIT_ID FROM [wms].OP_WMS3PL_AUDITS_X_PASS Z WHERE Z.PASS_ID = @pPASS_ID) 
	GROUP BY
		b.BARCODE_ID, 
		b.MATERIAL_NAME
)