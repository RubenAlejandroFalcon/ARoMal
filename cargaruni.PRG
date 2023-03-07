
LPARAMETERS con

*SET STEP ON

SET SAFETY OFF
DEBUGCARGARUNI = .F.

PUBLIC nto,npi,cde

PUBLIC conP

PUBLIC conP2
*IF EMPTY(con)
*	con = 1
*	con = 2
*ENDIF

conP = con

IF !USED("Unidades")
	USE Unidades IN 0 EXCLUSIVE
	SELECT Unidades
ELSE
	SELECT Unidades
ENDIF

SET ORDER TO primario
PUBLIC ccod
*SET FILTER TO nro_consor = conP
GO BOTTOM
IF EOF()
	ccod = 1
ELSE
	ccod =  nro_unidad + 1
ENDIF

SET FILTER TO
SET ORDER TO

PUBLIC cargo
cargo = .F.



ofrm = CREATEOBJECT("frm")
ofrm.Show

*MESSAGEBOX("Se retorna " + STR(ccod))
*RETURN ccod

********************** Definiciones de Clases ************************
DEFINE CLASS grd AS Grid 
	Left = 50
	Top = 180
	ColumnCount = 8
	Height = 200
	Width = 630
	ReadOnly = .T.
	Enabled = .T.
	RecordSourceType = 1
	RecordSource = "tablacuni"
	DeleteMark = .F.
	RecordMark = .F.
	Partition = 0
	SplitBar = .F.
	ScrollBars = 2
	TabStop = .F.
*	LinkMaster = "Consorcios"
*	ChildOrder = "nro_consor"
*	RelationalExpr = "nro_consor"
	PROCEDURE Init
*		This.Column1.Header1.Caption = "Consorcio"
		This.Column1.Header1.Caption = "Unidad"
		This.Column2.Header1.Caption = "Torre"
		This.Column3.Header1.Caption = "Piso"
		This.Column4.Header1.Caption = "Depto."
		This.Column5.Header1.Caption = "Superficie"
		This.Column6.Header1.Caption = "Propietario"
		This.Column7.Header1.Caption = "Tipo Prop."
		This.Column8.Header1.Caption = "Catastro"
		This.Column1.ReadOnly = .T.
		This.Column2.ReadOnly = .T.
		This.Column3.ReadOnly = .T.
		This.Column4.ReadOnly = .T.
		This.Column5.ReadOnly = .T.
		This.Column6.ReadOnly = .T.
		This.Column7.ReadOnly = .T.
		This.Column8.ReadOnly = .T.
	ENDPROC
ENDDEFINE

DEFINE CLASS tbx AS ComboBox
	RowSource = "Consorcios.nombre"
	RowSourceType = 2
	Style = 2
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
		
	ENDPROC
	PROCEDURE Inicializar
				&& Habilitar controles			
				Thisform.ogrd.Visible = .T.
				This.visible = .F.

				Thisform.lbl.Left = Thisform.lbl.Left - 80

				Thisform.AddObject("nombre","Label")
				Thisform.nombre.AutoSize = .T.
				Thisform.nombre.Caption = This.Value
				Thisform.nombre.Visible = .T.
				Thisform.nombre.Top = 15
				Thisform.nombre.Left = 255
				Thisform.nombre.FontBold = .T.
				Thisform.nombre.FontItalic = .T.
				
				Thisform.AddObject("labelcaruni","Label")
				Thisform.labelcaruni.AutoSize = .T.
				Thisform.labelcaruni.Caption = "Unidades cargadas :"
				Thisform.labelcaruni.Visible = .T.
				Thisform.labelcaruni.Top = 15
				Thisform.labelcaruni.Left = 395
				
				Thisform.AddObject("caruni","Label")
				Thisform.caruni.AutoSize = .T.
				SELECT Unidades
				PUBLIC cargadas
				COUNT FOR nro_consor = Consorcios.nro_consor TO cargadas
				Thisform.caruni.Caption = STR(cargadas)
				Thisform.caruni.Visible = .T.
				Thisform.caruni.Top = 15
				Thisform.caruni.Left = 515

				Thisform.AddObject("labeltotuni","Label")
				Thisform.labeltotuni.AutoSize = .T.
				Thisform.labeltotuni.Caption = "Totales :"
				Thisform.labeltotuni.Visible = .T.
				Thisform.labeltotuni.Top = 15
				Thisform.labeltotuni.Left = 585

				Thisform.AddObject("totuni","Label")
				Thisform.totuni.AutoSize = .T.
				Thisform.totuni.Caption = STR(Consorcios.unidades)
				Thisform.totuni.Visible = .T.
				Thisform.totuni.Top = 15
				Thisform.totuni.Left = 655
				
*				PUBLIC lSalir
*				lSalir = IIF(cargadas = Consorcios.unidades, .T., .F.)
				

				Thisform.cmdAgregar.Enabled = IIF(cargadas == Consorcios.unidades, .F., .T.)
				
				FOR a = 5 TO Thisform.ControlCount
					Thisform.Controls(a).Visible = .T.
				ENDFOR
				
				
				
*				SELECT Consorcios

		LOCAL co
		co = Consorcios.nro_consor


		SELECT Unidades.nro_unidad AS Unidad, Unidades.torre AS Torre, ;
				Unidades.piso AS Piso, Unidades.Departamento AS Depto, ;
				Unidades.Superficie AS Superficie, ;
				(ALLTRIM(Propietarios.Apellido) + ", " + ;
				ALLTRIM(Propietarios.nombre)) AS Propietario, ;
				Tipo_unidad.descripcion AS Tipo_Unidad, ;
				Unidades.catastro AS Catastro ;
			FROM Unidades,Propietarios,Tipo_Unidad ;
			WHERE Unidades.nro_consor = co .AND. ;
				Unidades.cod_prorio = Propietarios.cod_prorio .AND. ;
				Unidades.tip_unidad = Tipo_Unidad.tip_unidad ;
			INTO TABLE tablacuni				
	
		USE tablacuni


				SELECT tablacuni
				
				SET FILTER TO 	
				
				
			Thisform.ogrd.RecordSource = "tablacuni"
				

*			Thisform.ogrd.Column1.Header1.Caption = "Consorcio"
			Thisform.ogrd.Column1.Header1.Caption = "Unidad"
			Thisform.ogrd.Column2.Header1.Caption = "Torre"
			Thisform.ogrd.Column3.Header1.Caption = "Piso"
			Thisform.ogrd.Column4.Header1.Caption = "Depto."
			Thisform.ogrd.Column5.Header1.Caption = "Superficie"
			Thisform.ogrd.Column6.Header1.Caption = "Propietario"
			Thisform.ogrd.Column7.Header1.Caption = "Tipo Prop."
			Thisform.ogrd.Column8.Header1.Caption = "Catastro"
			Thisform.ogrd.Column1.ReadOnly = .T.
			Thisform.ogrd.Column2.ReadOnly = .T.
			Thisform.ogrd.Column3.ReadOnly = .T.
			Thisform.ogrd.Column4.ReadOnly = .T.
			Thisform.ogrd.Column5.ReadOnly = .T.
			Thisform.ogrd.Column6.ReadOnly = .T.
			Thisform.ogrd.Column7.ReadOnly = .T.
			Thisform.ogrd.Column8.ReadOnly = .T.
	
			Thisform.ogrd.Column1.Width = 50
			Thisform.ogrd.Column2.Width = 35
			Thisform.ogrd.Column3.Width = 40
			Thisform.ogrd.Column4.Width = 40
			Thisform.ogrd.Column5.Width = 70
			Thisform.ogrd.Column6.Width = 150
			Thisform.ogrd.Column7.Width = 140
			Thisform.ogrd.Column8.Width = 60



					nto = Thisform.otxbtorres.Value
					npi = Thisform.ospnpisos.Value
					cde = UPPER(Thisform.otxbdepto.Value)
				
			PUBLIC prime
			prime = .T.


**control de superficie
*set step on
			Thisform.olblsuperf2.Visible = .T.

*				SELECT Unidades
*				PUBLIC cargadas
*				COUNT FOR nro_consor = Consorcios.nro_consor TO cargadas

			select unidades
			sum unidades.superficie FOR Unidades.nro_consor = Consorcios.nro_consor TO ss2
			select consorcios
*			?? ss
			
			thisform.olblsuperf2.Caption = "<  " + ALLTRIM(STR((Consorcios.superficie - ss2),11,2))
			
*			MESSAGEBOX(STR(ss2))



	PROCEDURE Click
		SELECT Consorcios
*		IF !Thisform.ogrd.Visible
			IF !EMPTY(ALLTRIM(This.Value))
*				SET STEP ON
				This.Inicializar			
			ENDIF
*		ENDIF
	ENDPROC
ENDDEFINE

DEFINE CLASS lblActual AS Label
	Caption = "Actual"
	AutoSize = .T.
ENDDEFINE

DEFINE CLASS boxconten AS SHAPE
	Top = 4
	Left = 4
	Height = 100
	Width = 175
	Curvature = 1
	BackStyle = 0
ENDDEFINE

DEFINE CLASS containerbox AS Container
	Top = 60
	Left = 470
	Height = 190
	Width = 250
	BackStyle = 0
	BorderColor = RGB(192,192,192)
*	SpecialEffect = 1
	ADD OBJECT box1 AS boxconten ;
	WITH BorderColor = RGB(255,255,255), ;
		Left = 5, ;
		Top = 5
	ADD OBJECT box2 AS boxconten ;
	WITH BorderColor = RGB(128,128,128)
	
	
ENDDEFINE


DEFINE CLASS chkOrden AS CheckBox
	Caption = "orden lógico"
	FontSize = 8
ENDDEFINE

DEFINE CLASS opgnumalfa AS OptionGroup
	AutoSize = .T.
	ButtonCount = 2
	Top = 110
	Left = 390
	SpecialEffect = 1
	BorderColor = RGB(192,192,192)
ENDDEFINE

DEFINE CLASS frm AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192, 192, 192)
	Caption = "Carga de Unidades"
	Height = 480
	Width = 750
	Top = 5
	Left = 20
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
		Left = 240

	ADD OBJECT otbx AS tbx ;
	WITH Top = 11, ;
		Left = 330, ;
		Width = 200

	ADD OBJECT line1 AS Line ;
	WITH Left = 50, ;
		Top = 40, ;
		Height = 0, ;
		Width = 650, ;
		BorderColor = RGB(128,128,128)
	ADD OBJECT line2 AS Line ;
	WITH Left = 50, ;
		Top = 41, ;
		Height = 0, ;
		Width = 650, ;
		BorderColor = RGB(255,255,255)
	
	ADD OBJECT olbltorres AS lblActual ;
	WITH Caption = "Torre", ;
		Left = 60, ;
		Top = 70
	
	ADD OBJECT olblpisos AS lblActual ;
	WITH Caption = "Piso", ;
		Left = 220, ;
		Top = 70
	
	ADD OBJECT olbldepartamento AS lblActual ;
	WITH Caption = "Departamento", ;
		Left = 355, ;
		Top = 70
	
	ADD OBJECT olblsuperficie AS lblActual ;
	WITH Caption = "Superficie", ;
		Left = 540, ;
		Top = 70

	ADD OBJECT olblsuperf2 AS Label ;
	WITH Visible = .T., ;
		AutoSize = .T., ;
		Left = 670, ;
		Top = 70, ;
		Caption = "Prueba"



	ADD OBJECT olblcata AS lblActual ;
	WITH Caption = "Catastro", ;
		Left = 70, ;
		Top = 120
	
	ADD OBJECT olblprop AS lblActual ;
	WITH Caption = "Propietario", ;
		Left = 290, ;
		Top = 120
	
	ADD OBJECT olbltipoprop AS lblActual ;
	WITH Caption = "Tipo", ;
		Left = 540, ;
		Top = 120
	


	ADD OBJECT otxbtorres AS TextBox ;
		WITH Left = 120, ;
			Top = 68, ;
			Width = 35, ; 
			Format = "R", ;
			InputMask = "X", ;
			Value = "1" , ;
			Enabled = .F.


	ADD OBJECT ospnpisos AS Spinner ;
	WITH Left = 270, ;
		Top = 68, ;
		Width = 45, ; 
		KeyboardHighValue = 50, ; 
		KeyboardLowValue = 0, ; 
		SpinnerHighValue = 50, ; 
		SpinnerLowValue = 0, ; 
		Value = 1 


	ADD OBJECT otxbdepto AS TextBox ;
	WITH Left = 450, ;
		Top = 68, ;
		Width = 45, ;
		Format = "R", ;
		InputMask = "X"

	ADD OBJECT otxbsuperficie AS TextBox ;
	WITH Left = 600, ;
		Top = 68, ;
		Width = 60 
*		RowSourceType = 0

	ADD OBJECT otxbcatastro AS TextBox ;
	WITH Left = 120, ;
		Top = 117, ;
		Width = 130 
*		RowSourceType = 0

	ADD OBJECT ocmbprop AS ComboBox ;
	WITH Left = 360, ;
		Style = 2, ;
		Top = 117, ;
		Width = 120, ; 
		RowSourceType = 0
*		RowSource = "Propietarios.apellido"

	ADD OBJECT ocmbtipoprop AS ComboBox ;
	WITH Left = 570, ;
		Style = 2, ;
		Top = 116, ;
		Width = 110, ; 
		RowSourceType = 2, ;
		RowSource = "Tipo_Unidad.descripcion"


	ADD OBJECT ogrd AS grd ;
	WITH Visible = .F.
	ADD OBJECT cmdAgregar AS CommandButton ;
	WITH Top = 410, ;
		Left = 180, ;
		Width = 80, ;
		Default = .T., ;
		Height = 40, ;
		Caption = "Agregar"
	ADD OBJECT cmdCancelar AS CommandButton ;
	WITH Top = 410, ;
		Left = 300, ;
		Width = 80, ;
		Cancel= .T., ;
		Enabled = .F., ;
		Height = 40, ;
		Caption = "Cancelar"
	ADD OBJECT cmdSalir AS CommandButton ;
	WITH Top = 410, ;
		Left = 420, ;
		Width = 80, ;
		Height = 40, ;
		Caption = "Salir"
		
		
	PROCEDURE Load	
			
			
		SET SAFETY OFF
			
*		SELECT Unidades.nro_unidad AS Unidad, Unidades.torre AS Torre, ;
*				Unidades.piso AS Piso, Unidades.Departamento AS Depto, ;
*				Unidades.Superficie AS Superficie, ;
*				(ALLTRIM(Propietarios.Apellido) + ", " + ;
*				ALLTRIM(Propietarios.nombre)) AS Propietario, ;
*				Tipo_unidad.descripcion AS Tipo_Unidad ;
*			FROM Unidades,Propietarios,Tipo_Unidad ;
*			WHERE Unidades.cod_prorio = Propietarios.cod_prorio .AND. ;
*				Unidades.tip_unidad = Tipo_Unidad.tip_unidad ;
*			INTO TABLE tablacuni				
*	
*		USE tablacuni
		
	PROCEDURE Init
		FOR a = 5 TO This.ControlCount
			This.Controls(a).Visible = .F.
		ENDFOR
		
		IF !EMPTY(conP)
			IF SEEK(conP,"Consorcios","nro_consor")
				Thisform.otbx.Selected(Consorcios.nro_consor) = .T.
				Thisform.otbx.Inicializar
			ENDIF
		ENDIF				
*		IF !Thisform.ogrd.Visible
*			IF !EMPTY(ALLTRIM(This.Value))
		
	ENDPROC
		
	PROCEDURE ocmbprop.Init
		SELECT Propietarios
		SET ORDER TO TAG apel_nom &&IN Propietarios
		This.Clear
		SCAN 
			This.AddItem(ALLTRIM(apellido) + ", " + ALLTRIM(nombre))
		ENDSCAN
		
		This.AddItem("\-")
		This.AddItem("Otro Propietario")


	PROCEDURE ocmbprop.LostFocus
		IF This.ListItemID == This.ListCount .OR. ;
				This.ListItemID == (This.ListCount - 1) .OR. ;
				(EMPTY(This.Value))
			
			IF 6 == MESSAGEBOX("Desea cargar el nuevo propietario " ;
					,4+32,"Mensaje")
				
				ModProprio()
				This.Init
				
			ENDIF
		ENDIF
	ENDPROC
		

	PROCEDURE otxbsuperficie.Init
*		SELECT Unidades
		PUBLIC ss
		ss = 0.00
		This.ControlSource = "ss"		


	PROCEDURE otxbsuperficie.Valid
*	LPARAMETERS nCódigoTecla, nMayúsAltCtrl
		select unidades
		sum unidades.superficie FOR Unidades.nro_consor = Consorcios.nro_consor TO ss2
		select consorcios
*		?? ss
*		MESSAGEBOX(STR(ss2))
		LOCAL vari22
		vari22 = Consorcios.superficie - ss2 - This.Value
		
		IF vari22 < 0.00
*			thisform.olblsuperf2.Caption = "<  " + ALLTRIM(STR((vari22),11,2))
			RETURN .F.
		ELSE
			thisform.olblsuperf2.Caption = "<  " + ALLTRIM(STR((vari22),11,2))
			RETURN .T.
		ENDIF

	ENDPROC

	PROCEDURE Load
		close tables all
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
		
		IF !USED("Propietarios")
			USE Propietarios IN 0 EXCLUSIVE
		ELSE
			SELECT Propietarios
		ENDIF
		
		IF !USED("Tipo_Unidad")
			USE Tipo_Unidad IN 0 EXCLUSIVE
		ELSE
			SELECT Tipo_Unidad
		ENDIF
		
		PUBLIC l
		l = .F.
	ENDPROC
	PROCEDURE cmdAgregar.Click
		IF cargadas < Consorcios.unidades
*			MESSAGEBOX(


			SELECT Unidades

			SET ORDER TO primario
		
*			SET DELETE OFF
*			PUBLIC ccod
			SET FILTER TO nro_consor = Consorcios.nro_consor
			GO BOTTOM
			IF EOF()
				ccod = 1
			ELSE
				ccod =  nro_unidad + 1
			ENDIF

*			SET DELETE ON
	
*			SET FILTER TO
			SET ORDER TO


*			MESSAGEBOX("Consorcio " + STR(Consorcios.nro_consor) + "     Unidad " + STR(ccod))
*		
*			SELECT Consorcios
*		
			Thisform.Refresh()
		
			IF ALLTRIM(Thisform.otxbdepto.Value) == "" .OR. ALLTRIM(Thisform.ocmbprop.Value) == "" .OR. ALLTRIM(Thisform.ocmbtipoprop.Value) == ""
				MESSAGEBOX("Falta especificar algun dato", "Entrada inválida")
			ELSE
*			  	set step on 	
				IF (nto = (Thisform.otxbtorres.Value) .AND. ;
					npi = (Thisform.ospnpisos.Value) .AND. ;
					cde = UPPER(Thisform.otxbdepto.Value) .AND. !prime ;
					.AND. Thisform.cmdCancelar.Enabled = .T.)
					
					MESSAGEBOX("Ingrese una nueva unidad", "Entrada inválida")
				ELSE


					prime = .F.
						
	*				SELECT Propietarios
					SET ORDER TO TAG apel_nom In Propietarios
					GO TOP IN Propietarios
					SKIP (Thisform.ocmbprop.ListIndex - 1) IN Propietarios
			
*					MessageBox(Propietarios.apellido)
			

	*				INSERT INTO Unidades (nro_consor,nro_unidad,torre,piso,departamento,superficie,cod_prorio,tip_prodad) VALUES (Consorcios.nro_consor,ccod,Thisform.otxbtorres.Value,Thisform.ospnpisos.Value,Thisform.otxbdepto.Value,Thisform.otxbsuperficie.Value,Thisform.ocmbprop.ListIndex, Thisform.ocmbtipoprop.ListIndex)
	
					INSERT INTO Unidades (nro_consor,nro_unidad,torre,piso,departamento,superficie,cod_prorio,tip_unidad) VALUES (Consorcios.nro_consor,ccod,Thisform.otxbtorres.Value,Thisform.ospnpisos.Value,UPPER(Thisform.otxbdepto.Value),Thisform.otxbsuperficie.Value,Propietarios.cod_prorio, Thisform.ocmbtipoprop.ListIndex)
	



				



					select unidades
					sum unidades.superficie FOR Unidades.nro_consor = Consorcios.nro_consor TO ss2
					select consorcios
*					?? ss
			
					thisform.olblsuperf2.Caption = "<  " + ALLTRIM(STR((Consorcios.superficie - ss2),11,2))
				
*					MESSAGEBOX(STR(ss2))
















				
					nto = Thisform.otxbtorres.Value
					npi = Thisform.ospnpisos.Value
					cde = UPPER(Thisform.otxbdepto.Value)
				

*					PUBLIC agrego
	*				agrego = .T.
					Thisform.cmdCancelar.Enabled = .T.
					cargadas = cargadas + 1
					Thisform.caruni.Caption = STR(cargadas)

**aca
		LOCAL co
		co = Consorcios.nro_consor


		SELECT Unidades.nro_unidad AS Unidad, Unidades.torre AS Torre, ;
				Unidades.piso AS Piso, Unidades.Departamento AS Depto, ;
				Unidades.Superficie AS Superficie, ;
				(ALLTRIM(Propietarios.Apellido) + ", " + ;
				ALLTRIM(Propietarios.nombre)) AS Propietario, ;
				Tipo_unidad.descripcion AS Tipo_Unidad ;
			FROM Unidades,Propietarios,Tipo_Unidad ;
			WHERE Unidades.nro_consor = co .AND. ;
				Unidades.cod_prorio = Propietarios.cod_prorio .AND. ;
				Unidades.tip_unidad = Tipo_Unidad.tip_unidad ;
			INTO TABLE tablacuni				
	
		USE tablacuni


				SELECT tablacuni
				
				SET FILTER TO 	
				
				
			Thisform.ogrd.RecordSource = "tablacuni"
				

*			Thisform.ogrd.Column1.Header1.Caption = "Consorcio"
			Thisform.ogrd.Column1.Header1.Caption = "Unidad"
			Thisform.ogrd.Column2.Header1.Caption = "Torre"
			Thisform.ogrd.Column3.Header1.Caption = "Piso"
			Thisform.ogrd.Column4.Header1.Caption = "Depto."
			Thisform.ogrd.Column5.Header1.Caption = "Superficie"
			Thisform.ogrd.Column6.Header1.Caption = "Propietario"
			Thisform.ogrd.Column7.Header1.Caption = "Tipo Prop."
			Thisform.ogrd.Column8.Header1.Caption = "Catastro"
			Thisform.ogrd.Column1.ReadOnly = .T.
			Thisform.ogrd.Column2.ReadOnly = .T.
			Thisform.ogrd.Column3.ReadOnly = .T.
			Thisform.ogrd.Column4.ReadOnly = .T.
			Thisform.ogrd.Column5.ReadOnly = .T.
			Thisform.ogrd.Column6.ReadOnly = .T.
			Thisform.ogrd.Column7.ReadOnly = .T.
			Thisform.ogrd.Column8.ReadOnly = .T.
	
			Thisform.ogrd.Column1.Width = 50
			Thisform.ogrd.Column2.Width = 35
			Thisform.ogrd.Column3.Width = 40
			Thisform.ogrd.Column4.Width = 40
			Thisform.ogrd.Column5.Width = 70
			Thisform.ogrd.Column6.Width = 150
			Thisform.ogrd.Column7.Width = 140
			Thisform.ogrd.Column8.Width = 60



















			ENDIF
			ENDIF
			Thisform.Refresh()
		ELSE
			MESSAGEBOX("Carga de unidades del consorcio completada", 0, "Mensaje del Sistema")
		ENDIF
	ENDPROC	
	PROCEDURE cmdSalir.Click
		Release thisform
	PROCEDURE cmdCancelar.Click
	
*	set step on
		SELECT Unidades

		SET ORDER TO primario
		SET FILTER TO nro_consor = Consorcios.nro_consor
		GO BOTTOM
*		IF EOF()
*			ccod = 1
*		ELSE
*
***aca

*			ccod =  nro_unidad + 1
*			ccod =  nro_unidad


*
*		ENDIF

*		SET FILTER TO



*		SET ORDER TO

		IF 6 == MESSAGEBOX("Desea cancelar la reciente carga ?", 4+32, "Mensaje del Sistema")



			delete
			SET DELETE ON
			This.Enabled = .F.
			cargadas = cargadas - 1
			Thisform.caruni.Caption = STR(cargadas)


			pack








			select unidades
			sum unidades.superficie FOR Unidades.nro_consor = Consorcios.nro_consor TO ss2
			select consorcios
*			?? ss
			
			thisform.olblsuperf2.Caption = "<  " + ALLTRIM(STR((Consorcios.superficie - ss2),11,2))
			
*			MESSAGEBOX(STR(ss2))





















***aca			
		LOCAL co
		co = Consorcios.nro_consor


		SELECT Unidades.nro_unidad AS Unidad, Unidades.torre AS Torre, ;
				Unidades.piso AS Piso, Unidades.Departamento AS Depto, ;
				Unidades.Superficie AS Superficie, ;
				(ALLTRIM(Propietarios.Apellido) + ", " + ;
				ALLTRIM(Propietarios.nombre)) AS Propietario, ;
				Tipo_unidad.descripcion AS Tipo_Unidad ;
			FROM Unidades,Propietarios,Tipo_Unidad ;
			WHERE Unidades.nro_consor = co .AND. ;
				Unidades.cod_prorio = Propietarios.cod_prorio .AND. ;
				Unidades.tip_unidad = Tipo_Unidad.tip_unidad ;
			INTO TABLE tablacuni				
	
		USE tablacuni


				SELECT tablacuni
				
				SET FILTER TO 	
				
				
			Thisform.ogrd.RecordSource = "tablacuni"
				

*			Thisform.ogrd.Column1.Header1.Caption = "Consorcio"
			Thisform.ogrd.Column1.Header1.Caption = "Unidad"
			Thisform.ogrd.Column2.Header1.Caption = "Torre"
			Thisform.ogrd.Column3.Header1.Caption = "Piso"
			Thisform.ogrd.Column4.Header1.Caption = "Depto."
			Thisform.ogrd.Column5.Header1.Caption = "Superficie"
			Thisform.ogrd.Column6.Header1.Caption = "Propietario"
			Thisform.ogrd.Column7.Header1.Caption = "Tipo Prop."
			Thisform.ogrd.Column8.Header1.Caption = "Catastro"
			Thisform.ogrd.Column1.ReadOnly = .T.
			Thisform.ogrd.Column2.ReadOnly = .T.
			Thisform.ogrd.Column3.ReadOnly = .T.
			Thisform.ogrd.Column4.ReadOnly = .T.
			Thisform.ogrd.Column5.ReadOnly = .T.
			Thisform.ogrd.Column6.ReadOnly = .T.
			Thisform.ogrd.Column7.ReadOnly = .T.
			Thisform.ogrd.Column8.ReadOnly = .T.
	
			Thisform.ogrd.Column1.Width = 50
			Thisform.ogrd.Column2.Width = 35
			Thisform.ogrd.Column3.Width = 40
			Thisform.ogrd.Column4.Width = 40
			Thisform.ogrd.Column5.Width = 70
			Thisform.ogrd.Column6.Width = 150
			Thisform.ogrd.Column7.Width = 140
			Thisform.ogrd.Column8.Width = 60







			
			
			thisform.refresh()
		ENDIF
				
*	ENDIF
			
		
	PROCEDURE Destroy
		IF DEBUGCARGARUNI
			CLOSE TABLES ALL
		ENDIF
		SET SAFETY ON
	ENDPROC
ENDDEFINE