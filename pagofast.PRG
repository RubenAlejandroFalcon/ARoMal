*********************************************************************
*
*	Autor: Falcón, Rubén Alejandro 	(c) 2000
*
*	email: hawks1@bbs.frc.utn.edu.ar
*
************************ Seteos **************************************

SET DATE DMY
SET SAFETY OFF


************************* Principal ***********************************


PUBLIC Cambio		&&Se efectuo algun cambio
Cambio = .F.

PUBLIC nvencs		&&Número de vencimientos actuales

PUBLIC cantvenc		&&Cantidad de vencimientos posibles
cantvenc = 3

DIMENSION m_fechas(cantvenc,2) &&Array de las fechas de los vencimientos y los intereses

DIMENSION nmes(1)		&&Mes a pagar
DIMENSION nanio(1)		&&Año a pagar

PUBLIC nfields		&&Número de campos reales de la consulta

PUBLIC m_expen		&&Matriz Expensas

oPagoFast= CREATEOBJECT("PagoFast")
oPagoFast.Show





******************************* Definiciones de Clases ****************

DEFINE CLASS chkVenc AS CheckBox
	Tag1 = .F.
	Tag2 = 0
	PROCEDURE InteractiveChange
		PUBLIC bool
		bool = .T.
		SELECT tempcur
		SET ORDER TO Rec
		SEEK Con_expen.rec
		IF !EMPTY(tempcur.fecha_pago)
			This.Value = !This.Value
			n = MESSAGEBOX("El pago de la unidad " + ALLTRIM(STR(Con_expen.unidad)) + " ya fue asentado en una oportunidad anterior. ¿Desea cambiar el estado que posee?",4 + 32 + 256," Advertencia ")
			IF n = 6
				This.Value = !This.Value
				bool = .T.
				REPLACE tempcur.fecha_pago WITH CTOD('')
				RETURN
			ELSE
				bool = .F.
			ENDIF
		ELSE
			RETURN
		ENDIF
	ENDPROC

	PROCEDURE Click
		SELECT Con_expen
		IF bool
			IF This.Value
				FOR i = 1 TO nvencs
					c = "Venc" + ALLTRIM(STR(i))
					REPLACE &c WITH .F.
				ENDFOR
				This.Value = .T.
	
*				SEEK((STR(Consorcios.nro_consor)+STR(nanio)+STR(nmes)+DTOC(mat_fechas(Thisform.ogrd.ActiveColumn - nfields,1)))),"Vencimientos","Primario")
	
				SELECT Con_expen
				REPLACE Fecha_Pago WITH m_fechas(Thisform.ogrd.ActiveColumn - nfields,1)
				REPLACE Abonado WITH (A_pagar * ;
						m_fechas(Thisform.ogrd.ActiveColumn - nfields,2) + A_pagar)
				Thisform.refresh()
			ELSE
				REPLACE Con_expen.Fecha_Pago WITH CTOD('')
				REPLACE Con_expen.Abonado WITH 0.00
			ENDIF
			Cambio = .T.
		ENDIF
	ENDPROC
ENDDEFINE

DEFINE CLASS tbx AS ComboBox
	Style = 2
	RowSource = "Consorcios.nombre"
	RowSourceType = 2
	
	PROCEDURE InteractiveChange
		IF !Cambio

			&& Habilitar controles			
			Thisform.ogrd.Visible = .T.
			This.visible = .F.
			Thisform.lbl.Left = Thisform.lbl.Left + 40
	
			Thisform.AddObject("nombre","Label")
			Thisform.nombre.AutoSize = .T.
			Thisform.nombre.Caption = This.Value
			Thisform.nombre.Visible = .T.
			Thisform.nombre.Top = 15
			Thisform.nombre.Left = 355
			Thisform.nombre.FontBold = .T.
			Thisform.nombre.FontItalic = .T.
				
			FOR a = 5 TO Thisform.ControlCount
				Thisform.Controls(a).Visible = .T.
			ENDFOR
		
			 

			SELECT Expensas

			SELECT MAX(Expensas.mes) FROM Expensas ;
				WHERE Expensas.nro_consor = Consorcios.nro_consor INTO ARRAY nmes
			SELECT MAX(anio) FROM Expensas ;
				WHERE Expensas.nro_consor = Consorcios.nro_consor INTO ARRAY nanio
	
			IF TYPE("nmes") = "L"
				MESSAGEBOX("No existen los datos necesarios sobre " + Consorcios.nombre, 0, "ERROR")
				Thisform.SetAll("Enabled", .F.)
				Thisform.ocmdSalir.Enabled = .T.
				RETURN
			ENDIF
	
		ENDIF
		
*		set step on		
		SELECT Expensas.rec_numero AS Recibo, Expensas.nro_unidad AS Unidad, ;
				Unidades.piso AS Piso, Unidades.departamento AS Depto, ;
				(ALLTRIM(Propietarios.apellido) + ", " + ALLTRIM(Propietarios.nombre)) ;
					AS Propietario, expensas.monto_paga AS A_pagar, ;
				Expensas.fecha_pago AS Fecha_Pago, Expensas.monto_pago AS Monto_Pago ;
			FROM Expensas, Unidades, Propietarios ;
 			WHERE Expensas.nro_unidad = Unidades.nro_unidad .AND. ;
				Expensas.nro_consor = Unidades.nro_consor .AND. ;
		 		Unidades.cod_prorio = Propietarios.cod_prorio .AND. ;
				Unidades.nro_unidad = Expensas.nro_unidad .AND. ;
				Expensas.nro_consor = Consorcios.nro_consor .AND. ;
				Expensas.mes = nmes(1) .AND. Expensas.anio = nanio(1) ;
			GROUP BY 1 ;
			INTO ARRAY m_expen


 		SELECT Vencimientos.fecha, Vencimientos.interes FROM Vencimientos ;
			WHERE Vencimientos.anio = nanio(1) .AND. Vencimientos.mes = nmes(1) .AND.;
				Vencimientos.nro_consor = Consorcios.nro_consor ;
			INTO ARRAY m_fechas
				
		Thisform.olblMes.Caption = CMONTH(m_fechas(1,1)) + ", " + ALLTRIM(STR(nanio))
					
		SELECT Vencimientos
		SET FILTER TO nro_consor = Consorcios.nro_consor
		SET ORDER TO Fecha

		COUNT FOR anio = nanio(1) .AND. mes = nmes(1) TO nvencs
		
		Thisform.ogrd.ColumnCount = nfields + nvencs
			
		
		SELECT con_expen
		ZAP
		APPEND FROM ARRAY m_expen

		CREATE CURSOR tempcur (Rec N(5), Fecha_pago D)
		INDEX ON Rec TAG Rec

		SELECT con_expen.rec AS Rec, Con_expen.Fecha_pago AS Fecha_pago ;
			FROM con_expen ;
			INTO ARRAY tempmat
		SELECT tempcur	
		APPEND FROM ARRAY tempmat

		SELECT Con_expen
		SET ORDER TO Rec
		GO TOP
		LOCAL contador

		SCAN 
			contador = 1
			IF !EMPTY(fecha_pago)
				DO WHILE m_fechas(contador, 1) < Con_expen.fecha_pago
					contador = contador + 1
				ENDDO

				cvenc = "venc" + ALLTRIM(STR(contador))
				REPLACE &cvenc WITH .T.
			ENDIF
		ENDSCAN 
		GO TOP
		Thisform.ogrd.RecordSource = "con_expen"
	ENDPROC
ENDDEFINE



DEFINE CLASS hea AS HEADER
	Tag = '0'
	Ascendent = .F.
	PROCEDURE Click
	PROCEDURE Click
		IF This.Ascendent = .F.
			SET ORDER TO VAL(This.Tag) IN Con_expen ASCENDING
			This.Ascendent = .T.
		ELSE
			SET ORDER TO VAL(This.Tag) IN con_Expen DESCENDING
			This.Ascendent = .F.
		ENDIF
		GO TOP IN Con_Expen
		Thisform.refresh
	ENDPROC
ENDDEFINE


DEFINE CLASS grdExpensas AS Grid
	Left = 24
	Top = 100
	Width = 715
	Height = 320
	Visible = .T.
	DeleteMark = .F.
	RecordMark = .F.
	Partition = 0
	SplitBar = .F.
	ScrollBars = 2
	TabStop = .F.
	RecordSource = "con_expen"	
	ColumnCount = 8

	PROCEDURE Init
		nfields = This.ColumnCount
		DIMENSION m_expen(1,nfields)


		FOR i = 1 TO nfields
			c = "Column" + ALLTRIM(STR(i)) + "."
			This.&c.AddObject("ohead","hea")
			This.&c.ohead.Tag = ALLTRIM(STR(i))
		ENDFOR
	
		FOR i = 1 TO cantvenc
			c = "Column" + ALLTRIM(STR(This.ColumnCount + 1))
			This.AddObject(c, "Column")
			c = c + "."
			This.&c.width = 45
			This.&c.AddObject("ohead", "hea")
			This.&c.ohead.Tag = STR(This.ColumnCount) 
			This.&c.Visible = .T.
			
			This.&c.AddObject("ochk","chkVenc")
			This.&c.CurrentControl = "ochk"
			This.&c.ochk.Visible = .T.
			This.&c.ochk.Caption = ""
			This.&c.Sparse = .F.
		ENDFOR

		This.Column1.Width = 25
		This.Column2.Width = 42
		This.Column3.Width = 28
		This.Column4.Width = 35
		This.Column5.Width = 170
		This.Column6.Width = 70
		This.Column7.Width = 70
		This.Column8.Width = 70
		This.Column9.Width = 50
		This.Column10.Width = 50
		This.Column11.Width = 50

		This.Column1.Ohead.Caption = "Rec"
		This.Column2.Ohead.Caption = "Unidad"
		This.Column3.Ohead.Caption = "Piso"
		This.Column4.Ohead.Caption = "Depto."
		This.Column5.Ohead.Caption = "Propietario"
		This.Column6.Ohead.Caption = "A Pagar"
		This.Column7.Ohead.Caption = "Fecha Pago"
		This.Column8.Ohead.Caption = "Abonado"
		This.Column9.Ohead.Caption = "1er."
		This.Column10.Ohead.Caption = "2do."
		This.Column11.Ohead.Caption = "3er."

	ENDPROC
ENDDEFINE

 
DEFINE CLASS PagoFast AS FORM
	Top = 10
	Left = 25
	Width = 750
	Height = 470
	WindowType = 1 
	ShowWindow = 1 
	Caption = "Pago de la última liquidación"

	ADD OBJECT lbl AS Label ;
	WITH Caption = "Consorcio", ;
		AutoSize = .T., ;
		FontBold = .T., ;
		Top = 15, ;
		Left = 200

	ADD OBJECT otbx AS tbx ;
	WITH Top = 11, ;
		Left = 290, ;
		Width = 200

	ADD OBJECT line1 AS Line ;
	WITH Left = 20, ;
		Top = 40, ;
		Height = 0, ;
		Width = 650, ;
		BorderColor = RGB(128,128,128)
	ADD OBJECT line2 AS Line ;
	WITH Left = 20, ;
		Top = 41, ;
		Height = 0, ;
		Width = 650, ;
		BorderColor = RGB(255,255,255)
		
	ADD OBJECT olblMes AS Label ;
	WITH AutoSize = .T., ;
		Caption = "Mes de la Expensa", ;
		ForeColor = RGB(0,0,255), ;
		Top = 15, ;
		Left = 530, ;
		FontBold = .T., ;
		FontSize = 10, ;
		Visible = .F.
	
	ADD OBJECT olblVencc AS Label ;
	WITH AutoSize = .T., ;
		Caption = "Vencimientos", ;
		Top = 78, ;
		Left = 545, ;
		FontSize = 10, ;
		Visible = .F.
	
	ADD OBJECT ogrd AS grdExpensas ;
	WITH Visible = .F.

	ADD OBJECT ocmdActualizar AS CommandButton ;
	WITH Top = 432, ;
		Left = 140, ;
		Width = 85, ;
		Height = 27, ;
		Default = .T., ;
		Caption = "Actualizar"
	ADD OBJECT ocmdCancelar AS CommandButton ;
	WITH Top = 432, ;
		Left = 254, ;
		Width = 85, ;
		Height = 27, ;
		Cancel = .T., ;
		Caption = "Cancelar"
	ADD OBJECT ocmdSalir AS CommandButton ;
	WITH Top = 432, ;
		Left = 366, ;
		Width = 85, ;
		Height = 27, ;
		Caption = "Salir"
	ADD OBJECT ocmdAyuda AS CommandButton ;
	WITH Top = 432, ;
		Left = 478, ;
		Width = 85, ;
		Height = 27, ;
		Caption = "Ayuda"


	PROCEDURE Destroy
		SET SAFETY ON
		Thisform.release
	ENDPROC

	PROCEDURE ocmdActualizar.Click
		IF Cambio
			n = MESSAGEBOX("		Actualizar los pagos (o cambios) efectuados a disco		", 1 ,"Mensaje")
			IF n = 1
				SELECT Con_expen
				COPY TO ARRAY m_expen
				SELECT Expensas
				SET ORDER TO Rec_numero
				FOR i = 1 TO ALEN(m_expen,1)
					SEEK m_expen(i,1)
					REPLACE Fecha_Pago WITH m_expen(i,7)
					REPLACE Monto_Pago WITH m_expen(i,8)
					REPLACE Abonado WITH IIF(EMPTY(Fecha_Pago), .F., .T.)
				ENDFOR
				Thisform.otbx.InteractiveChange
			ENDIF
		ENDIF
	ENDPROC

	PROCEDURE ocmdCancelar.Click
		IF Cambio
			n = MESSAGEBOX("	¿Cancelar todos los cambios efectuados?		", 1 + 16 + 256,"Mensaje")
			IF n = 1
				Thisform.otbx.InteractiveChange		
			ENDIF
		ENDIF
	ENDPROC

	PROCEDURE ocmdSalir.Click
		Thisform.Release
	ENDPROC
	
	PROCEDURE Load
		close TABLES ALL

		IF !USED("Consorcios")
			USE Consorcios IN 0 EXCLUSIVE
		ELSE
			SELECT Consorcios
		ENDIF
		
		IF !USED("Unidades")
			USE Unidades IN 0 EXCLUSIVE
		ELSE
			SELECT Unidades
		ENDIF
		
		IF !USED("Expensas")
			USE Expensas IN 0 EXCLUSIVE
		ELSE
			SELECT Expensas
		ENDIF
		
		IF !USED("Propietarios")
			USE Propietarios IN 0 EXCLUSIVE
		ELSE
			SELECT Propietarios
		ENDIF
		
		IF !USED("Vencimientos")
			USE Vencimientos IN 0 EXCLUSIVE
		ELSE
			SELECT Vencimientos
		ENDIF
		
		SELECT Expensas
		
		CREATE CURSOR con_expen (Rec N(5), Unidad N(3), Piso N(2), Depto C(1), ;
				Propietario C(62), A_Pagar N(9,2), Fecha_Pago D, Abonado N(9,2), ;
				Venc1 L, Venc2 L, Venc3 L)
		
		INDEX ON Rec TAG Rec
		INDEX ON Unidad TAG Unidad
		INDEX ON Piso TAG Piso
		INDEX ON Depto TAG Depto
		INDEX ON Propietario TAG Proprio
		INDEX ON A_Pagar TAG A_Pagar
		INDEX ON Fecha_Pago TAG Fecha_Pago
		INDEX ON Abonado TAG Abonado
		INDEX ON Venc1 TAG Venc1
		INDEX ON Venc2 TAG Venc2
		INDEX ON Venc3 TAG Venc3

		SELECT con_expen
ENDDEFINE