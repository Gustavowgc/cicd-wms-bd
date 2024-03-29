﻿CREATE TABLE [wms].[OP_WMS_SAT_SERVICES] (
    [ID]                 NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [XML]                VARCHAR (MAX) NOT NULL,
    [STATUS]             VARCHAR (10)  NOT NULL,
    [TYPE]               VARCHAR (25)  NOT NULL,
    [MESSAGE]            VARCHAR (250) NULL,
    [MESSAGE_CODE]       VARCHAR (15)  NULL,
    [UPDATE_DATE]        DATETIME      NOT NULL,
    [NUMBER_OF_ATTEMPTS] INT           NULL,
    [ACUSE_DOC_ID]       NUMERIC (18)  NULL,
    CONSTRAINT [PK_OP_WMS_SAT_SERVICES] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);

