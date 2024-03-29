﻿CREATE TABLE [wms].[OP_WMS_POLIZA_HEADER] (
    [DOC_ID]                        NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [NUMERO_ORDEN]                  VARCHAR (25)    NULL,
    [ADUANA_ENTRADA_SALIDA]         VARCHAR (25)    NULL,
    [NUMERO_DUA]                    VARCHAR (50)    NULL,
    [FECHA_ACEPTACION_DMY]          VARCHAR (25)    NULL,
    [ADUANA_DESPACHO_DESTINO]       VARCHAR (25)    NULL,
    [REGIMEN]                       VARCHAR (15)    NULL,
    [CLASE]                         VARCHAR (5)     NULL,
    [PAIS_PROCEDENCIA]              VARCHAR (6)     NULL,
    [NATURALEZA_TRANS]              VARCHAR (5)     NULL,
    [DEPOSITO_FISCAL_ZF]            VARCHAR (15)    NULL,
    [MODO]                          NUMERIC (18)    NULL,
    [FECHA_LLEGADA]                 DATETIME        NULL,
    [TIPO_CAMBIO]                   NUMERIC (18, 5) NULL,
    [TOTAL_VALOR_ADUANA]            NUMERIC (18, 2) NULL,
    [TOTAL_NUMERO_LINEAS]           NUMERIC (18)    NULL,
    [TOTAL_BULTOS]                  NUMERIC (18)    NULL,
    [TOTAL_PESO_BRUTO_KG]           NUMERIC (18, 2) NULL,
    [TOTAL_FOB_USD]                 NUMERIC (18, 2) NULL,
    [TOTAL_FLETE_USD]               NUMERIC (18, 2) NULL,
    [TOTAL_SEGURO_USD]              NUMERIC (18, 2) NULL,
    [TOTAL_OTROS_USD]               NUMERIC (18, 2) NULL,
    [NUMERO_SAT]                    VARCHAR (25)    NULL,
    [TIPO_IMPORTADOR]               VARCHAR (5)     NULL,
    [ID_TRIB_IMPORTADOR]            VARCHAR (25)    NULL,
    [PAIS_IMPORTADOR]               VARCHAR (5)     NULL,
    [RAZON_SOCIAL_IMPORTADOR]       VARCHAR (250)   NULL,
    [DOMICILIO_IMPORTADOR]          VARCHAR (250)   NULL,
    [TIPO_REPRESENTANTE]            VARCHAR (5)     NULL,
    [ID_TRIB_REPRESENTANTE]         VARCHAR (5)     NULL,
    [PAIS_REPRESENTANTE]            VARCHAR (5)     NULL,
    [TIPO_DECLARANTE_REPRESENTANTE] VARCHAR (5)     NULL,
    [RAZON_SOCIAL_REPRESENTANTE]    VARCHAR (250)   NULL,
    [DOMICILIO_REPRESENTANTE]       VARCHAR (250)   NULL,
    [TIPO_CONTENEDOR]               NUMERIC (18)    NULL,
    [NUMERO_CONTENEDOR]             VARCHAR (50)    NULL,
    [ENTIDAD_CONTENEDOR]            VARCHAR (5)     NULL,
    [NUMERO_MARCHAMO_CONTENEDOR]    VARCHAR (50)    NULL,
    [TOTAL_LIQUIDAR]                NUMERIC (18, 2) NULL,
    [TOTAL_OTROS]                   NUMERIC (18, 2) NULL,
    [TOTAL_GENERAL]                 NUMERIC (18, 2) NULL,
    [CODIGO_POLIZA]                 VARCHAR (25)    NULL,
    [LAST_UPDATED_BY]               VARCHAR (25)    NULL,
    [LAST_UPDATED]                  DATETIME        NULL,
    [STATUS]                        VARCHAR (15)    CONSTRAINT [DF_OP_WMS_POLIZA_HEADER_STATUS] DEFAULT ('CREATED') NOT NULL,
    [ACUERDO_COMERCIAL]             VARCHAR (25)    NOT NULL,
    [WAREHOUSE_REGIMEN]             VARCHAR (25)    CONSTRAINT [DF_POLIZA_WAREHOUSE_REGIMEN] DEFAULT (N'GENERAL') NULL,
    [CLIENT_CODE]                   VARCHAR (25)    NULL,
    [FECHA_DOCUMENTO]               DATETIME        NULL,
    [TIPO]                          VARCHAR (25)    NULL,
    [REFERENCIA_EXTRA]              VARCHAR (150)   NULL,
    [POLIZA_ASEGURADA]              VARCHAR (50)    NULL,
    [POLIZA_ASSIGNEDTO]             VARCHAR (25)    NULL,
    [TRANSLATION]                   VARCHAR (10)    NULL,
    [PENDIENTE_RECTIFICACION]       INT             DEFAULT ((0)) NULL,
    [CODIGO_POLIZA_RECTIFICACION]   VARCHAR (50)    NULL,
    [COMENTARIO_RECTIFICACION]      VARCHAR (250)   NULL,
    [CLASE_POLIZA_RECTIFICACION]    VARCHAR (200)   NULL,
    [DOC_ID_RECTIFICACION]          NUMERIC (18)    NULL,
    [COMENTARIO_RECTIFICADO]        VARCHAR (250)   NULL,
    [IS_EXTERNAL_INVENTORY]         INT             DEFAULT ((0)) NOT NULL,
    [IS_BLOCKED]                    INT             DEFAULT ((0)) NOT NULL,
    [DOCUMENTO_DESBLOQUEO]          VARCHAR (25)    NULL,
    [COMENTARIO_DESBLOQUEO]         VARCHAR (250)   NULL,
    [USUARIO_DESBLOQUEO]            VARCHAR (25)    NULL,
    [FECHA_DESBLOQUEO]              DATETIME        NULL,
    [BLOCKED_STATUS]                VARCHAR (250)   NULL,
    CONSTRAINT [PK_OP_WMS_POLIZA_HEADER] PRIMARY KEY CLUSTERED ([DOC_ID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [IN_OP_WMS_POLIZA_HEADER_CODIGO_POLIZA]
    ON [wms].[OP_WMS_POLIZA_HEADER]([CODIGO_POLIZA] ASC)
    INCLUDE([CLIENT_CODE], [DOC_ID], [FECHA_LLEGADA], [NUMERO_DUA], [NUMERO_ORDEN], [REGIMEN], [WAREHOUSE_REGIMEN]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IN_OP_WMS_POLIZA_HEADER_WAREHOUSE_REGIMEN_TIPO_FECHA_DOCUMENTO]
    ON [wms].[OP_WMS_POLIZA_HEADER]([WAREHOUSE_REGIMEN] ASC, [TIPO] ASC, [FECHA_DOCUMENTO] ASC)
    INCLUDE([IS_EXTERNAL_INVENTORY], [NUMERO_ORDEN], [REGIMEN], [CLIENT_CODE], [CODIGO_POLIZA], [DOC_ID]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IN_OP_WMS_POLIZA_HEADER_WAREHOUSE_REGIMEN_TIPO_DOC_ID]
    ON [wms].[OP_WMS_POLIZA_HEADER]([WAREHOUSE_REGIMEN] ASC, [TIPO] ASC, [DOC_ID] ASC)
    INCLUDE([ACUERDO_COMERCIAL], [CLIENT_CODE]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IN_OP_WMS_POLIZA_HEADER_WAREHOUSE_REGIMEN_DOC_ID]
    ON [wms].[OP_WMS_POLIZA_HEADER]([WAREHOUSE_REGIMEN] ASC, [DOC_ID] ASC)
    INCLUDE([ACUERDO_COMERCIAL], [CODIGO_POLIZA], [FECHA_DOCUMENTO], [NUMERO_DUA], [NUMERO_ORDEN], [REGIMEN], [STATUS], [TIPO]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IN_OP_WMS_POLIZA_HEADER_WAREHOUSE_REGIMEN_CLIENT_CODE]
    ON [wms].[OP_WMS_POLIZA_HEADER]([WAREHOUSE_REGIMEN] ASC, [CLIENT_CODE] ASC)
    INCLUDE([ACUERDO_COMERCIAL], [ADUANA_DESPACHO_DESTINO], [ADUANA_ENTRADA_SALIDA], [BLOCKED_STATUS], [CLASE], [CLASE_POLIZA_RECTIFICACION], [CODIGO_POLIZA], [CODIGO_POLIZA_RECTIFICACION], [COMENTARIO_RECTIFICACION], [COMENTARIO_RECTIFICADO], [DEPOSITO_FISCAL_ZF], [DOC_ID], [DOC_ID_RECTIFICACION], [DOMICILIO_IMPORTADOR], [DOMICILIO_REPRESENTANTE], [ENTIDAD_CONTENEDOR], [FECHA_ACEPTACION_DMY], [FECHA_DOCUMENTO], [FECHA_LLEGADA], [ID_TRIB_IMPORTADOR], [ID_TRIB_REPRESENTANTE], [IS_BLOCKED], [LAST_UPDATED], [LAST_UPDATED_BY], [MODO], [NATURALEZA_TRANS], [NUMERO_CONTENEDOR], [NUMERO_DUA], [NUMERO_MARCHAMO_CONTENEDOR], [NUMERO_ORDEN], [NUMERO_SAT], [PAIS_IMPORTADOR], [PAIS_PROCEDENCIA], [PAIS_REPRESENTANTE], [PENDIENTE_RECTIFICACION], [POLIZA_ASEGURADA], [POLIZA_ASSIGNEDTO], [RAZON_SOCIAL_IMPORTADOR], [RAZON_SOCIAL_REPRESENTANTE], [REFERENCIA_EXTRA], [REGIMEN], [STATUS], [TIPO], [TIPO_CAMBIO], [TIPO_CONTENEDOR], [TIPO_DECLARANTE_REPRESENTANTE], [TIPO_IMPORTADOR], [TIPO_REPRESENTANTE], [TOTAL_BULTOS], [TOTAL_FLETE_USD], [TOTAL_FOB_USD], [TOTAL_GENERAL], [TOTAL_LIQUIDAR], [TOTAL_NUMERO_LINEAS], [TOTAL_OTROS], [TOTAL_OTROS_USD], [TOTAL_PESO_BRUTO_KG], [TOTAL_SEGURO_USD], [TOTAL_VALOR_ADUANA], [TRANSLATION]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IN_OP_WMS_POLIZA_HEADER_REGIMEN_WAREHOUSE_REGIMEN]
    ON [wms].[OP_WMS_POLIZA_HEADER]([REGIMEN] ASC, [WAREHOUSE_REGIMEN] ASC)
    INCLUDE([CODIGO_POLIZA]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [INX_OP_WMS_POLIZA_HEADER_TIPO_IS_BLOCKED]
    ON [wms].[OP_WMS_POLIZA_HEADER]([TIPO] ASC, [IS_BLOCKED] ASC)
    INCLUDE([ACUERDO_COMERCIAL], [CLIENT_CODE], [CODIGO_POLIZA], [DOC_ID], [FECHA_DOCUMENTO], [NUMERO_DUA], [NUMERO_ORDEN], [WAREHOUSE_REGIMEN]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IN_OP_WMS_POLIZA_HEADER_CODIGO_POLIZA_ACUERDO_COMERCIAL]
    ON [wms].[OP_WMS_POLIZA_HEADER]([CODIGO_POLIZA] ASC, [ACUERDO_COMERCIAL] ASC)
    INCLUDE([FECHA_DOCUMENTO]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IN_OP_WMS_POLIZA_HEADER_CODIGO_POLIZA_REGIMEN]
    ON [wms].[OP_WMS_POLIZA_HEADER]([CODIGO_POLIZA] ASC, [REGIMEN] ASC) WITH (FILLFACTOR = 80);


GO
CREATE STATISTICS [20150916]
    ON [wms].[OP_WMS_POLIZA_HEADER]([DOC_ID], [LAST_UPDATED], [WAREHOUSE_REGIMEN], [CLIENT_CODE], [FECHA_DOCUMENTO], [TIPO]);

