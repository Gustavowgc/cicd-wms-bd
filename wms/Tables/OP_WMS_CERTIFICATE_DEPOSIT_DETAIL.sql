﻿CREATE TABLE [wms].[OP_WMS_CERTIFICATE_DEPOSIT_DETAIL] (
    [CERTIFICATE_DEPOSIT_ID_DETAIL] INT             IDENTITY (1, 1) NOT NULL,
    [CERTIFICATE_DEPOSIT_ID_HEADER] INT             NULL,
    [MATERIAL_CODE]                 VARCHAR (50)    NULL,
    [SKU_DESCRIPTION]               VARCHAR (200)   NULL,
    [LOCATIONS]                     VARCHAR (200)   NULL,
    [BULTOS]                        NUMERIC (18)    NULL,
    [QTY]                           NUMERIC (18, 3) NULL,
    [CUSTOMS_AMOUNT]                NUMERIC (18, 2) NULL,
    [DOC_ID]                        NUMERIC (18)    NULL,
    CONSTRAINT [PK_OP_WMS_CERTIFICATE_DEPOSIT_DETAIL] PRIMARY KEY CLUSTERED ([CERTIFICATE_DEPOSIT_ID_DETAIL] ASC) WITH (FILLFACTOR = 80)
);

