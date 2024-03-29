﻿


CREATE PROCEDURE [wms].[OP_WMS_SP_PROCESS_TXN_FROM_ERP]
	-- Add the parameters for the stored procedure here
	@pMESSAGE_FROM_ERP      VARCHAR(250),
	@pTERMS_OF_TRADE        VARCHAR(25), 
	@pCLIENT_OWNER          VARCHAR(25), 
	@pTRANS_DATE_INI        DATETIME,
	@pTRANS_DATE_FIN        DATETIME,
	@pINVOICE_REFERENCE		VARCHAR(30),
	@pResult				varchar(250) OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;
		
	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;
	DECLARE @pALLOW_REALLOC INT;
	DECLARE @pCURRENT_LOCATION VARCHAR(50)
	
	BEGIN TRY
		UPDATE [wms].OP_WMS_TRANS
		SET 
			POSTED_TO_ERP_STAMP	=	CURRENT_TIMESTAMP,
			MESSAGE_FROM_ERP	=	@pMESSAGE_FROM_ERP,
			INVOICE_REFERENCE	=	@pINVOICE_REFERENCE
		WHERE
			TERMS_OF_TRADE		=	@pTERMS_OF_TRADE	AND
			TRANS_DATE		BETWEEN @pTRANS_DATE_INI	AND
									@pTRANS_DATE_FIN
		
		SELECT @pResult = 'OK'
	
	END TRY
	BEGIN CATCH
		SELECT	@pResult	= ERROR_MESSAGE()
	END CATCH
   
END