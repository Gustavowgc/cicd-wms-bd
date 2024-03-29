﻿CREATE PROC [wms].[OP_WMS_SP_UPDATE_QUOTA_LETTER_STATUS]
	@DOC_ID NUMERIC(18,0)
	, @Status varchar(20)
	, @UserId varchar(25)
	, @pResult varchar(250) OUTPUT
AS
BEGIN TRY
	UPDATE [wms].[OP_WMS_QUOTA_LETTER]
	   SET [STATUS] = @Status		  
		  ,[LAST_UPDATED] = CURRENT_TIMESTAMP
		  ,[LAST_UPDATED_BY] = @UserId
	 WHERE DOC_ID = @DOC_ID 

	 SELECT @pResult = 'OK'
END TRY
	
BEGIN CATCH
	ROLLBACK TRAN;
	SELECT @pResult = ERROR_MESSAGE()
END CATCH