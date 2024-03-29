﻿

CREATE PROCEDURE [wms].[sp_OP_WMS3PL_PASSES]
@PASS_ID NUMERIC(18,0) = NULL OUTPUT,
@CLIENT_CODE VARCHAR(25), 
@CLIENT_NAME VARCHAR(200),  
@LAST_UPDATED_BY VARCHAR(25), 
@ISEMPTY VARCHAR(1), 
@VEHICLE_PLATE VARCHAR(25), 
@VEHICLE_DRIVER VARCHAR(200), 
@VEHICLE_ID VARCHAR(50), 
@DRIVER_ID VARCHAR(50), 
@AUTORIZED_BY VARCHAR(250), 
@HANDLER VARCHAR(250),
@CARRIER VARCHAR(250),
@TXT VARCHAR(4000),
@LOADUNLOAD VARCHAR(1),
@LOADWITH VARCHAR(4000),
@AUDIT_ID NUMERIC(18,0),
@PRESULT VARCHAR(4000) OUTPUT
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			IF NOT EXISTS (SELECT * FROM [wms].OP_WMS3PL_PASSES WHERE PASS_ID = @PASS_ID)
				BEGIN
					INSERT INTO [wms].OP_WMS3PL_PASSES
					   (CLIENT_CODE,CLIENT_NAME,LAST_UPDATED_BY,LAST_UPDATED
					   ,ISEMPTY,VEHICLE_PLATE,VEHICLE_DRIVER,VEHICLE_ID
					   ,DRIVER_ID,AUTORIZED_BY,HANDLER,CARRIER
					   ,TXT,LOADUNLOAD,LOADWITH,AUDIT_ID)
					VALUES
					   (@CLIENT_CODE,@CLIENT_NAME,@LAST_UPDATED_BY,GETDATE(),
					   @ISEMPTY,@VEHICLE_PLATE,@VEHICLE_DRIVER,@VEHICLE_ID,
					   @DRIVER_ID, @AUTORIZED_BY, @HANDLER, @CARRIER
					   ,@TXT,@LOADUNLOAD,@LOADWITH,@AUDIT_ID);
					   
					SET @PASS_ID = SCOPE_IDENTITY();
				END
			ELSE
				BEGIN
					UPDATE [wms].OP_WMS3PL_PASSES
				    SET CLIENT_CODE = @CLIENT_CODE
					  ,CLIENT_NAME = @CLIENT_NAME
					  ,LAST_UPDATED_BY = @LAST_UPDATED_BY
					  ,LAST_UPDATED = GETDATE()
					  ,ISEMPTY = @ISEMPTY
					  ,VEHICLE_PLATE = @VEHICLE_PLATE
					  ,VEHICLE_DRIVER = @VEHICLE_DRIVER
					  ,VEHICLE_ID = @VEHICLE_ID
					  ,DRIVER_ID = @DRIVER_ID
					  ,AUTORIZED_BY = @AUTORIZED_BY
					  ,HANDLER = @HANDLER
					  ,CARRIER = @CARRIER
					  ,TXT = @TXT
					  ,LOADUNLOAD = @LOADUNLOAD
					  ,LOADWITH = @LOADWITH
					  ,AUDIT_ID = @AUDIT_ID
					WHERE PASS_ID = @PASS_ID;
				END
		COMMIT TRAN
		UPDATE [wms].OP_WMS_AUDIT_DISPATCH_CONTROL SET PASS_DATE = GETDATE() WHERE AUDIT_ID = @AUDIT_ID;
		
		SELECT @PRESULT = 'OK';
	END TRY
	
	BEGIN CATCH
		ROLLBACK TRAN;
		SELECT @PRESULT = ERROR_MESSAGE()
	END CATCH
END