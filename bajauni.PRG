SET DELETE ON
ofrm = CREATEOBJECT("frm")
ofrm.Show


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
	TabStop = .T.

	PROCEDURE AfterRowColChange
	LPARAMETERS nind
		Thisform.LockScreen = .T.
		
		Thisform.ocmbprop.Clear
		Thisform.ocmbprop.AddItem(tablacuni.propietari)
		Thisform.ocmbprop.Value = tablacuni.propietari
		Thisform.ocmbtipoprop.Clear
		Thisform.ocmbtipoprop.AddItem(tablacuni.tipo_unida)
		Thisform.ocmbtipoprop.Value = tablacuni.tipo_unida
				
		Thisform.refresh
		Thisform.LockScreen = .F.

	ENDPROC	
ENDDEFINE

DEFINE CLASS tbx AS ComboBox
	RowSource = "Consorcios.nombre"
	RowSourceType = 2
	Style = 2

	PROCEDURE InteractiveChange
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

				FOR a = 5 TO Thisform.ControlCount
					Thisform.Controls(a).Visible = .T.
				ENDFOR

				LOCAL co
				co = Consorcios.nro_consor


				SELECT Unidades.nro_unidad AS Unidad, Unidades.torre AS Torre, ;
						Unidades.piso AS Piso, Unidades.Departamento AS Depto, ;
						Unidades.Superficie AS Superficie, ;
						(ALLTRIM(Propietarios.Apellido) + ", " + ;
						ALLTRIM(Propietarios.nombre)) AS Propietario, ;
						Tipo_unidad.descripcion AS Tipo_Unidad, ;
						Unidades.catastro as Catastro ;
					FROM Unidades,Propietarios,Tipo_Unidad ;
					WHERE Unidades.nro_consor = co .AND. ;
						Unidades.cod_prorio = Propietarios.cod_prorio .AND. ;
						Unidades.tip_unidad = Tipo_Unidad.tip_unidad ;
					ORDER BY 2, 1 ;
					INTO TABLE tablacuni				
	
				USE tablacuni
				SELECT tablacuni
				SET FILTER TO 	
			
				Thisform.ogrd.RecordSource = "tablacuni"
				
				Thisform.ogrd.Column1.Header1.Caption = "Unidad"
				Thisform.ogrd.Column2.Header1.Caption = "Torre"
				Thisform.ogrd.Column3.Header1.Caption = "Piso"
				Thisform.ogrd.Column4.Header1.Caption = "Depto."
				Thisform.ogrd.Column5.Header1.Caption = "Superficie"
				Thisform.ogrd.Column6.Header1.Caption = "Propietario"
				Thisform.ogrd.Column7.Header1.Caption = "Tipo Prop."
				Thisform.ogrd.Column8.Header1.Caption = "Catastro"
				Thisform.ogrd.SetAll("ReadOnly", .T.)
				Thisform.ogrd.SetAll("Movable", .F.)

				Thisform.ogrd.Column1.Width = 50
				Thisform.ogrd.Column2.Width = 35
				Thisform.ogrd.Column3.Width = 40
				Thisform.ogrd.Column4.Width = 40
				Thisform.ogrd.Column5.Width = 70
				Thisform.ogrd.Column6.Width = 150
				Thisform.ogrd.Column7.Width = 140
				Thisform.ogrd.Column8.Width = 60
				
				Thisform.olblsuperf2.Visible = .T.

				PUBLIC superff
				select tablacuni
				sum tablacuni.superficie TO superff
				thisform.olblsuperf2.Caption = ALLTRIM(STR(superff)) + " tot."  

				select consorcios

				Thisform.otxbtorres.ControlSource = "tablacuni.torre"
				Thisform.ospnpisos.ControlSource = "tablacuni.piso"
				Thisform.otxbdepto.ControlSource = "tablacuni.depto"
				Thisform.otxbsuperficie.ControlSource = "tablacuni.superficie"
				Thisform.otxbcatastro.ControlSource = "tablacuni.catastro"

				Thisform.ogrd.Column1.Text1.SetFocus
				Thisform.refresh
				
				Thisform.ogrd.SetAll("DynamicBackColor", ;
					"IIF(tablacuni.torre = Thisform.otxbtorres.Value .AND. ;
					tablacuni.piso = Thisform.ospnpisos.Value, ;
					RGB(150,250,250), RGB(255,255,255))", "Column")  
					
					
				Thisform.otxbtorres.Enabled = .F.
				Thisform.ospnpisos.Enabled = .F.
				Thisform.otxbdepto.Enabled = .F.
				Thisform.otxbsuperficie.Enabled = .F.
				Thisform.otxbcatastro.Enabled = .F.
				Thisform.ocmbprop.Enabled = .F.
				Thisform.ocmbtipoprop.Enabled = .F.
		ENDPROC
ENDDEFINE

DEFINE CLASS lblActual AS Label
	Caption = "Actual"
	AutoSize = .T.
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
	WITH Caption = "Propietarios", ;
		Left = 290, ;
		Top = 120
	
	ADD OBJECT olbltipoprop AS lblActual ;
	WITH Caption = "Tipo de Propiedad", ;
		Left = 540, ;
		Top = 120
	
	ADD OBJECT otxbtorres AS TextBox ;
		WITH Left = 120, ;
			Top = 68, ;
			Width = 35, ; 
			Format = "R", ;
			InputMask = "X"

	ADD OBJECT ospnpisos AS Spinner ;
	WITH Left = 270, ;
		Top = 68, ;
		Width = 45, ; 
		KeyboardHighValue = 50, ; 
		KeyboardLowValue = 0, ; 
		SpinnerHighValue = 50, ; 
		SpinnerLowValue = 0 

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
	
	ADD OBJECT otxbcatastro AS TextBox ;
	WITH Left = 120, ;
		Top = 117, ;
		Width = 130 

	ADD OBJECT ocmbprop AS ComboBox ;
	WITH Left = 360, ;
		Style = 2, ;
		Top = 117, ;
		Width = 120, ; 
		RowSourceType = 0

	ADD OBJECT ocmbtipoprop AS ComboBox ;
	WITH Left = 570, ;
		Style = 2, ;
		Top = 116, ;
		Width = 110, ; 
		RowSourceType = 0
		
**		RowSourceType = 2, ;
**		RowSource = "Tipo_Unidad.descripcion"

	ADD OBJECT ogrd AS grd ;
	WITH Visible = .F.

	ADD OBJECT cmdModifi AS CommandButton ;
	WITH Top = 410, ;
		Left = 180, ;
		Width = 80, ;
		Height = 40, ;
		Caption = "Eliminar!"
	ADD OBJECT cmdCancelar AS CommandButton ;
	WITH Top = 410, ;
		Left = 300, ;
		Width = 80, ;
		Enabled = .T., ;
		Height = 40, ;
		Caption = "Cancelar"
	ADD OBJECT cmdSalir AS CommandButton ;
	WITH Top = 410, ;
		Left = 420, ;
		Width = 80, ;
		Height = 40, ;
		Caption = "Salir"
		

	PROCEDURE Init
		FOR a = 5 TO This.ControlCount
			This.Controls(a).Visible = .F.
		ENDFOR
	ENDPROC
		
	PROCEDURE cmdModifi.Click
		IF 6 == MESSAGEBOX("ELIMINAR LA UNIDAD SELECCIONADA?? ";
										,4 + 16 + 256,"Mensaje")
					
			SELECT tablacuni
			DELETE 
				
			Thisform.refresh
			MESSAGEBOX("Unidad eliminada con éxito")
		ENDIF
	ENDPROC	
	
	PROCEDURE cmdSalir.Click
		
		SET DELETE OFF
		SELECT tablacuni
		GO TOP
		SELECT Unidades
		DO WHILE !EOF("tablacuni")
			IF DELETED("tablacuni")
				LOCATE FOR nro_consor = Consorcios.nro_consor .AND. ;
						nro_unidad = tablacuni.unidad
				DELETE
				REPLACE unidades WITH (unidades - 1) IN Consorcios
				REPLACE superficie WITH (superficie - tablacuni.superficie) IN Consorcios
			ENDIF
			SKIP IN tablacuni
		ENDDO
		SET DELETE ON
			
		Release thisform
	ENDPROC

	PROCEDURE cmdCancelar.Click
		IF 6==MESSAGEBOX("Cancelar los cambios efectuados?", ;
				4 + 32 + 256, Thisform.Caption)
				
			SELECT tablacuni
			SET DELETE OFF
			RECALL ALL
			SET DELETE ON
			GO TOP
			Thisform.refresh
		ENDIF	
		
	ENDPROC
	
	PROCEDURE Load
*		CLOSE TABLES ALL
		SET SAFETY OFF
			
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
		
	ENDPROC

	PROCEDURE Destroy
		SET SAFETY ON
	ENDPROC
ENDDEFINE