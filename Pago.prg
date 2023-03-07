
PUBLIC interes1
PUBLIC unav
unav = .T.
IF !USED("Unidades")
	USE Unidades IN 0 EXCLUSIVE
	SELECT Unidades
ELSE
	SELECT Unidades
ENDIF

SET ORDER TO primario

PUBLIC uni
uni = ''
PUBLIC mes1
PUBLIC anio1
PUBLIC messelect
messelect = .T.
PUBLIC concat
concat = ""


ofrm = CREATEOBJECT("frm")
ofrm.Show


********************** Definiciones de Clases ************************
DEFINE CLASS grd AS Grid 
	Left = 30
	Top = 170
	ColumnCount = 9
	Height = 150
	Width = 630
	ReadOnly = .T.
	Enabled = .T.
	RecordSourceType = 1
	RecordSource = "Expensas"
	DeleteMark = .F.
	RecordMark = .F.
	Partition = 0
	SplitBar = .F.
	ScrollBars = 2
	TabStop = .F.
	LinkMaster = "Consorcios"
	ChildOrder = "nro_consor"
	RelationalExpr = "nro_consor"
	PROCEDURE Init
		This.Column1.Header1.Caption = "Recibo"
		This.Column2.Header1.Caption = "Consorcio"
		This.Column3.Header1.Caption = "Unidad"
		This.Column4.Header1.Caption = "Torre"
		This.Column5.Header1.Caption = "Año"
		This.Column6.Header1.Caption = "Mes"
		This.Column7.Header1.Caption = "Monto neto"
		This.Column8.Header1.Caption = "Fecha pago"
		This.Column9.Header1.Caption = "Monto pagado"
		This.Column1.ReadOnly = .T.
		This.Column2.ReadOnly = .T.
		This.Column3.ReadOnly = .T.
		This.Column4.ReadOnly = .T.
		This.Column5.ReadOnly = .T.
		This.Column6.ReadOnly = .T.
		This.Column7.ReadOnly = .T.
		This.Column8.ReadOnly = .T.
		This.Column9.ReadOnly = .T.

		This.Column1.Width = 40
		This.Column2.Width = 60
		This.Column3.Width = 50
		This.Column4.Width = 50
		This.Column5.Width = 50
		This.Column6.Width = 50
		This.Column7.Width = 100
		This.Column8.Width = 100
		This.Column9.Width = 100

	ENDPROC
ENDDEFINE

DEFINE CLASS tbx AS ComboBox
	Style = 2
	RowSource = "Consorcios.nombre"
	RowSourceType = 2
	
	PROCEDURE LostFocus
		Select Consorcios
	ENDPROC
	
	PROCEDURE GotFocus
		SELECT Consorcios
	ENDPROC
	
	PROCEDURE Init
		IF !USED("Consorcios")
			USE Consorcios IN 0
			SELECT Consorcios
		ELSE
			SELECT Consorcios
		ENDIF
		SET ORDER TO
		SET FILTER TO
	ENDPROC
	
	PROCEDURE Click
		SELECT Consorcios
		IF !Thisform.ogrd.Visible
			IF !EMPTY(ALLTRIM(This.Value))
			
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
				
				Thisform.otxbFechaPago.Visible = .F.
				Thisform.olblFechaPago.Caption = "Vencimiento"
				
				SELECT Expensas
				SET FILTER TO nro_consor = Consorcios.nro_consor
				
				PUBLIC actualiza
				IF SEEK(Consorcios.nro_consor,"Tipo_Administracion","nro_consor")
					IF Tipo_Administracion.cobra_atraz == 'S'
						actualiza = .T.
					ELSE
						actualiza = .F.
					ENDIF
				ELSE
					MESSAGEBOX("No se encontró el número del consorcio en Tipo_Administracion",0,"Mensaje del Sistema")
				ENDIF
			
				IF actualiza 
					Thisform.ocmbmeses.Visible = .F.
					Thisform.olblactua.Caption = "Total Neto"
				ELSE
					Thisform.otxbTotalNeto.Visible = .F.
					Thisform.olblactua.Caption = "   Mes(es)"
				ENDIF

				SELECT Unidades
				SET FILTER TO nro_consor = Consorcios.nro_consor
				
				SELECT Consorcios
			ENDIF
		ENDIF
	ENDPROC
ENDDEFINE

DEFINE CLASS frm AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192, 192, 192)
	Caption = " Pago de Expensas"
	Height = 430
	Width = 670
	Top = 5
	Left = 75
	ScaleMode = 3
	WindowType = 1
	ShowWindow = 1
	Visible = .T.
	Closable = .T.
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
		
	ADD OBJECT olblunidad AS Label ;
	WITH Caption = "Unidad :", ;
		AutoSize = .T., ;
		Top = 60, ;
		Left = 40, ;
		Visible = .F.
		
	ADD OBJECT ocmbunidad AS ComboBox ;
	WITH Left = 90, ;
		Style = 0, ;
		Top = 57, ;
		SelectOnEntry = .T., ;
		Width = 45, ; 
		RowSourceType = 2, ;
		RowSource = "Unidades.nro_unidad", ;
		Visible = .F.

	ADD OBJECT olblprop AS Label ;
	WITH Caption = "Propietario:", ;
		AutoSize = .T., ;
		Top = 60, ;
		Left = 145, ;
		Visible = .F.
		
	ADD OBJECT otxbprop AS TextBox ;
	WITH Left = 210, ;
		Top = 57, ;
		Width = 175, ;
		Height = 25, ;
		TabStop = .F., ;
		ReadOnly = .T., ;
		Visible = .F.

	ADD OBJECT ochkEnVenc AS CheckBox ;
	WITH Caption = "En Venc.", ;
		Top = 57, ;
		Left = 590, ;
		Value = .T., ;
		Visible = .F., ;
		Tabstop = .F.

	ADD OBJECT olblactua AS Label ;
	WITH Caption = "En Venc.", ;
		AutoSize = .T., ;
		Top = 110, ;
		Left = 75, ;
		Visible = .F.

	ADD OBJECT otxbTotalNeto AS TextBox ;
	WITH Left = 135, ;
		Top = 107, ;
		Width = 105, ;
		Height = 25, ;
		TabStop = .F., ;
		ReadOnly = .T., ;
		Visible = .F.

	ADD OBJECT ocmbmeses AS ComboBox ;
	WITH Left = 135, ;
		Top = 107, ;
		Style = 2, ;
		Width = 105, ; 
		RowSourceType = 0, ;
		Visible = .F.
		
	ADD OBJECT olblintereses AS Label ;
	WITH Caption = "Intereses :", ;
		AutoSize = .T., ;
		Top = 110, ;
		Left = 260, ;
		Visible = .F.

	ADD OBJECT otxbIntereses AS TextBox ;
	WITH Left = 320, ;
		Top = 107, ;
		Width = 70, ;
		ReadOnly = .T., ;
		TabStop = .F., ;
		Value = 0.00, ;
		Visible = .F.


	ADD OBJECT olblMontoTotal AS Label ;
	WITH Caption = "Monto Total :", ;
		AutoSize = .T., ;
		Top = 110, ;
		TabStop = .F., ;
		Left = 430, ;
		Visible = .F.

	ADD OBJECT otxbMontoTotal AS TextBox ;
	WITH Left = 500, ;
		Top = 107, ;
		ReadOnly = .T., ;
		Value = 0.00, ;
		TabStop = .F., ;
		Visible = .F.


	ADD OBJECT olblFechaPago AS Label ;
	WITH Caption = "Fecha Pago :", ;
		AutoSize = .T., ;
		Top = 60, ;
		Left = 410, ;
		Visible = .F.

	ADD OBJECT otxbFechaPago AS TextBox ;
	WITH Left = 470, ;
		Top = 57, ;
		Value = CTOD(''), ;
		Visible = .F.

	ADD OBJECT ocmbVenc AS ComboBox ;
	WITH RowSourceType = 0, ;
		Top = 57, ;
		Width = 50, ;
		SelectOnEntry = .T., ;
		Left = 490, ;
		Visible = .F.

	ADD OBJECT ogrd AS grd ;
	WITH Visible = .F.
	ADD OBJECT cmdCobrar AS CommandButton ;
	WITH Top = 350, ;
		Left = 90, ;
		Width = 90, ;
		Height = 30, ;
		Enabled = .F., ;
		Default = .T., ;
		Caption = "Cobrar"
	ADD OBJECT cmdCancelarCobro AS CommandButton ;
	WITH Top = 350, ;
		Left = 202, ;
		Width = 90, ;
		Height = 30, ;
		Cancel = .T., ;
		Enabled = .F., ;
		Caption = "Cancelar cobro"
	ADD OBJECT cmdSalir AS CommandButton ;
	WITH Top = 350, ;
		Left = 314, ;
		Width = 90, ;
		Height = 30, ;
		Caption = "Salir"
	ADD OBJECT cmdAyuda AS CommandButton ;
	WITH Top = 350, ;
		Left = 426, ;
		Width = 90, ;
		Height = 30, ;
		Caption = "Ayuda"


	PROCEDURE ocmbunidad.InteractiveChange
		Thisform.ocmbVenc.Selected(1) = .T.
	ENDPROC
	
	
	PROCEDURE ocmbunidad.Valid
		IF !EMPTY(ALLTRIM(This.Value))
			This.Renovar
		ENDIF
	ENDPROC
	
	PROCEDURE ocmbVenc.Valid
		IF !EMPTY(ALLTRIM(This.Value))
			Thisform.ocmbmeses.InteractiveChange
		ENDIF

	PROCEDURE ocmbVenc.When
		Thisform.ocmbmeses.RenovarVenc
	ENDPROC

	PROCEDURE ochkEnVenc.InteractiveChange
		IF !This.Value
			Thisform.ocmbVenc.Visible = .F.
			Thisform.otxbFechaPago.Visible = .T.
			Thisform.olblFechaPago.Caption = "Fecha Pago :"
			Thisform.olblFechaPago.Left = Thisform.olblFechaPago.Left - 10

		ELSE
			Thisform.ocmbVenc.Visible = .T.
			Thisform.otxbFechaPago.Visible = .F.
			Thisform.olblFechaPago.Caption = "Vencimiento"
			Thisform.olblFechaPago.Left = Thisform.olblFechaPago.Left + 10
		ENDIF
	ENDPROC

	PROCEDURE ocmbunidad.Renovar
	LPARAMETERS Anio33, Mes33
		SELECT Expensas
		SET FILTER TO (nro_consor = Unidades.nro_consor .AND. nro_unidad = VAL(ALLTRIM(Thisform.ocmbunidad.Value)))
		Thisform.refresh()
			
		IF SEEK(Unidades.cod_prorio,"Propietarios","cod_prorio")
			Thisform.otxbprop.Value = ALLTRIM(Propietarios.apellido) + ;
										",  " + Propietarios.nombre
		ELSE
			Thisform.otxbprop.Value = "No se encontró"
		ENDIF

		SELECT Expensas
		
		SET ORDER TO TAG periodo
		SET ORDER TO TAG nro IN Meses

		IF (EMPTY(Anio33) .AND. EMPTY(Mes33))
			Thisform.ocmbmeses.Clear()
			Thisform.ocmbmeses.Value = ""
			primer = .T.
			SCAN FOR .NOT. Abonado
				IF SEEK(Expensas.mes,"Meses","nro")
					IF primer
						mes1 = Expensas.mes
						anio1 = Expensas.anio
						primer = .F.
					ENDIF
				ENDIF
				Thisform.ocmbmeses.AddItem(ALLTRIM(Meses.mes) + "," + ALLTRIM(STR(Expensas.anio)))

				IF !primer
					Thisform.ocmbmeses.Value = ALLTRIM(Meses.mes) + "," + ALLTRIM(STR(Expensas.anio))
				ENDIF
			ENDSCAN
					
			Thisform.ocmbmeses.Selected(1) = .T.

			IF Thisform.ocmbmeses.ListCount == 1
				Thisform.ocmbmeses.TabStop = .F.
			ELSE
				Thisform.ocmbmeses.TabStop = .T.
			ENDIF
		ENDIF

		IF actualiza 
			GO BOTTOM
			Thisform.otxbTotalNeto.Value = monto_paga
		ENDIF

		LOCAL l
		IF !actualiza 
			GO TOP IN Expensas
			IF EMPTY(Anio33) .AND. EMPTY(Mes33)
				LOCATE FOR .NOT. Expensas.Abonado
			ELSE
				IF SEEK(STR(Anio33) + STR(Mes33), "Expensas", "periodo")
				ENDIF 
			ENDIF
			l = FOUND()
		ELSE
			l = .NOT. Expensas.Abonado
		ENDIF
		
		PUBLIC cobrar
		IF l
			IF Thisform.otxbFechaPago.Value != CTOD('') .OR. ;
					!EMPTY(ALLTRIM(Thisform.ocmbVenc.Value)) 
				cobrar = RECNO("Expensas")			
				
				IF Thisform.ochkEnVenc.Value .AND. ;
					  !EMPTY(ALLTRIM(Thisform.ocmbVenc.Value)) 
						SELECT Vencimientos
					SET ORDER TO TAG fecha
				
					SET FILTER TO nro_consor = Consorcios.nro_consor ;
						.AND. mes = Expensas.mes ;
						.AND. anio = Expensas.anio
						GO TOP
					SKIP (VAL(ALLTRIM(Thisform.ocmbVenc.Value)) - 1)
						interes1 = Vencimientos.interes
					Thisform.cmdCobrar.Enabled = .T.
				ELSE
					IF Thisform.otxbFechaPago.Value != CTOD('')
							SELECT Vencimientos
						SET ORDER TO TAG fecha
			
						SET FILTER TO nro_consor = Consorcios.nro_consor ;
							.AND. anio = Expensas.anio ;
							.AND. mes = Expensas.mes 
							LOCATE FOR fecha > Thisform.otxbFechaPago.Value
						IF FOUND()
							interes1 = Vencimientos.interes
							Thisform.otxbIntereses.ReadOnly = .T.
							Thisform.cmdCobrar.Enabled = .T.
						ELSE
							MESSAGEBOX("Se aplica el interés mensual que se especificó al crear el consorcio", 0 , "Ha pasado el último vencimiento")
							interes1 = (Tipo_administracion.intereses / 30) * (Thisform.otxbFechaPago.Value - CTOD("01" + "/" + STR(Expensas.mes) + "/" + STR(Expensas.anio)))
						ENDIF
						
					ENDIF

				ENDIF
				Thisform.cmdCobrar.Enabled = .T.
				Thisform.otxbIntereses.Value = interes1 * Expensas.Monto_paga
				Thisform.otxbMontoTotal.Value = Expensas.Monto_paga + ;
										Thisform.otxbIntereses.Value 
				Thisform.refresh
			ENDIF
			IF !actualiza
				Thisform.ocmbVenc.Visible = .T.
				Thisform.otxbFechaPago.Visible = .F.
				Thisform.olblFechaPago.Caption = "Vencimiento"
				Thisform.olblFechaPago.Left = 410

				LOCAL mm, ann
				
				mm = Expensas.mes
				ann = Expensas.anio
				mes1 = Expensas.mes
				anio1 = Expensas.anio
				select expensas
				
				calculate max(fecha_pago) ;
						FOR nro_consor = Consorcios.nro_consor to juju2
				LOCAL jv

				IF !EMPTY(juju2)
					jv = .T.
				ENDIF

				IF ann <= YEAR(juju2) .AND. mm < MONTH(juju2)
					jv = .T.
				ELSE
					jv = .F.
				ENDIF

				select consorcios 

				IF  jv .OR. Thisform.ocmbmeses.ListCount > 1
					IF jv .OR. !(Thisform.ocmbmeses.Value = Thisform.ocmbmeses.List(Thisform.ocmbmeses.ListCount))

						Thisform.ochkEnVenc.Value = .T.
						Thisform.ochkEnVenc.Enabled = .F.

						IF Thisform.ochkEnVenc.Value
							Thisform.ocmbVenc.Visible = .F.
							Thisform.otxbFechaPago.Visible = .T.
							Thisform.olblFechaPago.Caption = "Fecha Pago :"
							Thisform.olblFechaPago.Left = 400

						ELSE
							Thisform.ocmbVenc.Visible = .T.
							Thisform.otxbFechaPago.Visible = .F.
							Thisform.olblFechaPago.Caption = "Vencimiento"
							Thisform.olblFechaPago.Left = 390
						ENDIF

					ELSE
						Thisform.ochkEnVenc.Enabled = .T.
					ENDIF
				ELSE
					Thisform.ochkEnVenc.Enabled = .T.
				ENDIF
			ENDIF
		ELSE
			MESSAGEBOX("Propietario al día", 0, "Mensaje del sistema")
			Thisform.cmdCobrar.Enabled = .F.
		ENDIF
		
		SET ORDER TO TAG nro_consor IN Expensas
		GO TOP IN Expensas

		SELECT Consorcios
		Thisform.ogrd.refresh
		Thisform.refresh

		uni = This.Value
	ENDPROC
	
	PROCEDURE otxbFechaPago.LostFocus
		IF This.Value != CTOD('') 
*			IF actualiza
				GO BOTTOM IN Expensas
*			ENDIF
			
			eval = (Expensas.anio * 100) + Expensas.mes
			eval2 = (YEAR(This.Value) * 100) + MONTH(This.Value)
			IF eval =< eval2
				IF !actualiza
					LOCAL anio22
					LOCAL mes11
					LOCAL mes22
					anio22 = VAL(RIGHT(Thisform.ocmbmeses.Value,4))
					mes11 = (LEFT(Thisform.ocmbmeses.Value,(LEN(Thisform.ocmbmeses.Value) - 5)))
					IF SEEK(mes11,"Meses","nombre")
						mes22 = Meses.nro
					ENDIF
					Thisform.ocmbunidad.Renovar(anio22, mes22)
				ELSE
					Thisform.ocmbunidad.Renovar
				ENDIF
			ELSE
				MESSAGEBOX("La fecha especificada pertenece a un tiempo anterior al de la liquidación de la actual expensa", 0,"Entrada inválida") 
			ENDIF
		ENDIF	
	ENDPROC
	
	PROCEDURE ocmbmeses.InteractiveChange
		LOCAL anio22
		LOCAL mes11
		LOCAL mes22
		anio22 = VAL(RIGHT(This.Value,4))
		mes11 = LEFT(This.Value,(LEN(This.Value) - 5))
		IF SEEK(mes11,"Meses","nombre")
			mes22 = Meses.nro
		ENDIF
		concat = This.Value
		Thisform.otxbFechaPago.Value = CTOD('')
		Thisform.otxbIntereses.Value = 0.00
		Thisform.otxbMontoTotal.Value = 0.00
		Thisform.cmdCobrar.Enabled = .F.

		Thisform.ocmbunidad.Renovar(anio22, mes22)

		IF !actualiza
			LOCAL mm, ann
				
			mm = Expensas.mes
			ann = Expensas.anio

			select expensas
					
			calculate max(fecha_pago) ;
						FOR nro_consor = Consorcios.nro_consor to juju2
			LOCAL jv
			IF !EMPTY(juju2)
				jv = .T.
			ENDIF
					
			IF anio1 <= YEAR(juju2) .AND. mes1 < MONTH(juju2)
				jv = .T.
			ELSE
				jv = .F.
			ENDIF
					
			select consorcios 
				
			IF  jv .OR. Thisform.ocmbmeses.ListCount > 1
				IF  (jv .OR. !(Thisform.ocmbmeses.Value = Thisform.ocmbmeses.List(Thisform.ocmbmeses.ListCount)))
					IF jv
						Thisform.ochkEnVenc.Enabled = .F.
						IF Thisform.ochkEnVenc.Value
							Thisform.ocmbVenc.Visible = .F.
							Thisform.otxbFechaPago.Visible = .T.
							Thisform.olblFechaPago.Caption = "Fecha Pago :"
							Thisform.olblFechaPago.Left = 400

						ELSE
							Thisform.ocmbVenc.Visible = .T.
							Thisform.otxbFechaPago.Visible = .F.
							Thisform.olblFechaPago.Caption = "Vencimiento"
							Thisform.olblFechaPago.Left = 390
						ENDIF
					ENDIF
				ELSE
					Thisform.ochkEnVenc.Enabled = .T.
					Thisform.ochkEnVenc.Value = .T.
					Thisform.ocmbVenc.Visible = .T.
					Thisform.otxbFechaPago.Visible = .F.
					Thisform.olblFechaPago.Caption = "Vencimiento"
					Thisform.olblFechaPago.Left = Thisform.olblFechaPago.Left + 10
				ENDIF
			ELSE
				Thisform.ochkEnVenc.Enabled = .T.
			ENDIF
		ENDIF
	ENDPROC
						
	PROCEDURE ocmbmeses.RenovarVenc
		LOCAL anio22
		LOCAL mes11
		LOCAL mes22
		anio22 = VAL(RIGHT(This.Value,4))
		mes11 = LEFT(This.Value,(LEN(This.Value) - 5))
		IF SEEK(mes11,"Meses","nombre")
			mes22 = Meses.nro
		ENDIF

		SELECT Vencimientos
		SET FILTER TO nro_consor = Consorcios.nro_consor ;
				.AND. mes = mes22 ;
				.AND. anio = anio22

		COUNT TO aa
		SET FILTER TO
		LOCAL n
		IF This.ListCount >= 1
			Thisform.ocmbVenc.Clear()
			FOR n = 1 TO aa
				Thisform.ocmbVenc.AddItem(ALLTRIM(STR(n)))
			ENDFOR
		ENDIF
	ENDPROC
	
	PROCEDURE cmdCobrar.Click
		PUBLIC cobrar2
		cobrar2 = cobrar
		GO RECORD cobrar2 IN Expensas

*		IF Thisform.ochkEnVenc.Value
*			Thisform.otxbFechaPago.Value = Vencimientos.fecha
*		ENDIF
		
		IF Thisform.ochkEnVenc.Enabled
			Thisform.otxbFechaPago.Value = Vencimientos.fecha
		ENDIF
		
		IF actualiza
			REPLACE Expensas.Monto_Pago WITH Thisform.otxbMontoTotal.Value ;
					IN Expensas
			REPLACE Expensas.Abonado WITH .T. ;
					ALL FOR .NOT. Expensas.Abonado IN Expensas
				
			REPLACE Expensas.Fecha_pago WITH Thisform.otxbFechaPago.Value ;
					ALL FOR EMPTY(Expensas.fecha_pago) IN Expensas
		ELSE
			REPLACE Expensas.Fecha_pago WITH Thisform.otxbFechaPago.Value, ;
					Expensas.Abonado WITH .T., ;
					Expensas.Monto_Pago WITH Thisform.otxbMontoTotal.Value ;
					IN Expensas
		ENDIF
		MESSAGEBOX(Thisform.ocmbmeses.Value + "   Abonado",4+64,"Mensaje del sistema")
		Thisform.otxbIntereses.ReadOnly = .T.
		Thisform.cmdCancelarCobro.Enabled = .T.

		Thisform.otxbFechaPago.Value = CTOD('')

		Thisform.ocmbunidad.Renovar
		Thisform.refresh()

		SELECT Consorcios

		Thisform.otxbFechaPago.Value = CTOD('')
		Thisform.otxbIntereses.Value = 0.00
		Thisform.otxbMontoTotal.Value = 0.00

		Thisform.ocmbVenc.Selected(1) = .F.
		Thisform.ocmbVenc.Selected(2) = .F.
		Thisform.ocmbVenc.Selected(3) = .F.

		This.Enabled = .F.

		Thisform.ocmbunidad.SetFocus
	ENDPROC

	PROCEDURE cmdCancelarCobro.Click
		GO RECORD cobrar2 IN Expensas
		LOCAL expenss
		expenss = Expensas.fecha_pago
		
		IF actualiza
			REPLACE Expensas.Monto_Pago WITH 0.00 ;
					IN Expensas
			REPLACE Expensas.Abonado WITH .F. ALL FOR ;
					Expensas.fecha_pago = expenss IN Expensas
			REPLACE Expensas.Fecha_pago WITH CTOD('') ;
					ALL FOR ;
					(Expensas.fecha_pago == expenss) ;
					IN Expensas
		ELSE
			REPLACE Expensas.Fecha_pago WITH CTOD(''), ;
				Expensas.Monto_Pago WITH 0.00, ;
				Expensas.Abonado WITH .F. ;
				IN Expensas
		ENDIF
		MESSAGEBOX("Cobro Cancelado",4+64,"Mensaje del sistema")
		Thisform.cmdCancelarCobro.Enabled = .F.
		
		Thisform.cmdCobrar.Enabled = .F.
		Thisform.ocmbunidad.Renovar
		Thisform.otxbFechaPago.Value = CTOD('')
		Thisform.otxbIntereses.Value = 0.00
		Thisform.otxbMontoTotal.Value = 0.00

		Thisform.ocmbVenc.Selected(1) = .F.
		Thisform.ocmbVenc.Selected(2) = .F.
		Thisform.ocmbVenc.Selected(3) = .F.

		Thisform.ocmbunidad.SetFocus
		Thisform.refresh()
		SELECT Consorcios
	ENDPROC	
	
	PROCEDURE cmdSalir.Click
		Release Thisform
	ENDPROC
	
	PROCEDURE Load
		close TABLES ALL
		IF !USED("Ciudades")
			USE Ciudades IN 0 EXCLUSIVE
		ELSE
			SELECT Ciudades
		ENDIF
		
		IF !USED("Barrios")
			USE Barrios IN 0 EXCLUSIVE
		ELSE
			SELECT Barrios
		ENDIF
		
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
		
		IF !USED("Tipo_Administracion")
			USE Tipo_Administracion IN 0 EXCLUSIVE
		ELSE
			SELECT Tipo_Administracion
		ENDIF

		IF !USED("Meses")
			USE Meses IN 0 EXCLUSIVE
		ELSE
			SELECT Meses
		ENDIF

		IF !USED("Vencimientos")
			USE Vencimientos IN 0 EXCLUSIVE
		ELSE
			SELECT Vencimientos
		ENDIF

		PUBLIC l
		l = .F.
	ENDPROC
	
	PROCEDURE Destroy
		CLOSE TABLES ALL
	ENDPROC
ENDDEFINE