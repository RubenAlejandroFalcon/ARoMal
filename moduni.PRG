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
	TabStop = .F.

*	PROCEDURE Init
*		This.Column1.Header1.Caption = "Unidad"
*		This.Column2.Header1.Caption = "Torre"
*		This.Column3.Header1.Caption = "Piso"
*		This.Column4.Header1.Caption = "Depto."
*		This.Column5.Header1.Caption = "Superficie"
*		This.Column6.Header1.Caption = "Propietario"
*		This.Column7.Header1.Caption = "Tipo Prop."
*		This.SetAll("ReadOnly", .T.)
*		This.SetAll("Movable", .F.)
*		This.SetAll("DynamicBackColor", ;
*			"IIF(MOD(RECNO( ), 2)=0, RGB(255,255,255), RGB(0,255,0))", "Column")  
*	ENDPROC
	
	PROCEDURE AfterRowColChange
	LPARAMETERS nind
		Thisform.LockScreen = .T.
		
		FOR i = 1 TO (Thisform.ocmbprop.Listcount - 2)
			IF ALLTRIM(Thisform.ocmbprop.List(i)) = ALLTRIM(tablacuni.propietari)
				Thisform.ocmbprop.Selected(i) = .T.
			ENDIF
		ENDFOR
				
		FOR i = 1 TO (Thisform.ocmbtipoprop.Listcount)
			IF ALLTRIM(Thisform.ocmbtipoprop.List(i)) = ALLTRIM(tablacuni.tipo_unida)
				Thisform.ocmbtipoprop.Selected(i) = .T.
			ENDIF
		ENDFOR
				
		Thisform.refresh()
		Thisform.otxbtorres.Enabled = .F.
		Thisform.ospnpisos.Enabled = .F.
		Thisform.otxbdepto.Enabled = .F.
		Thisform.otxbsuperficie.Enabled = .F.
		Thisform.otxbcatastro.Enabled = .F.
		Thisform.ocmbprop.Enabled = .F.
		Thisform.ocmbtipoprop.Enabled = .F.

		DO CASE
*			CASE This.ActiveColumn = 2
*				Thisform.otxbtorres.Enabled = .T.
*				Thisform.otxbtorres.SetFocus
				
			CASE This.ActiveColumn = 3
				Thisform.ospnpisos.Enabled = .T.
				Thisform.ospnpisos.SetFocus
			
			CASE This.ActiveColumn = 4
				Thisform.otxbdepto.Enabled = .T.
				Thisform.otxbdepto.SetFocus

			CASE This.ActiveColumn = 5
				Thisform.otxbsuperficie.Enabled = .T.
				Thisform.otxbsuperficie.SetFocus

			CASE This.ActiveColumn = 6
				Thisform.ocmbprop.Enabled = .T.
				Thisform.ocmbprop.SetFocus
				
			CASE This.ActiveColumn = 7
				Thisform.ocmbtipoprop.Enabled = .T.
				Thisform.ocmbtipoprop.SetFocus

			CASE This.ActiveColumn = 8
				Thisform.otxbcatastro.Enabled = .T.
				Thisform.otxbcatastro.SetFocus
		ENDCASE
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
*				select unidades
*				sum unidades.superficie FOR Unidades.nro_consor = Consorcios.nro_consor TO ss2
*				thisform.olblsuperf2.Caption = ALLTRIM(STR(ss2)) + " tot."  

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
				
				
				
				
*				Thisform.ogrd.SetAll("DynamicBackColor", ;
*					"IIF(tablacuni.torre = Thisform.otxbtorres.Value .AND. ;
*					tablacuni.piso = Thisform.ospnpisos.Value unidad .AND. ;
*					tablacuni.depto = Thisform.otxbdepto.Value, ;
*					RGB(0,255,255), RGB(0,255,0))", "Column")  
				
				Thisform.ogrd.SetAll("DynamicBackColor", ;
					"IIF(tablacuni.torre = Thisform.otxbtorres.Value .AND. ;
					tablacuni.piso = Thisform.ospnpisos.Value, ;
					RGB(150,250,250), RGB(255,255,255))", "Column")  
				
				
				
				
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
	WITH Caption = "Propietario", ;
		Left = 290, ;
		Top = 120
	
	ADD OBJECT olbltipoprop AS lblActual ;
	WITH Caption = "Tipo", ;
		Left = 540, ;
		Top = 120
	




*!*		ADD OBJECT olblprop AS lblActual ;
*!*		WITH Caption = "Propietario", ;
*!*			Left = 100, ;
*!*			Top = 120
*!*		
*!*		ADD OBJECT olbltipoprop AS lblActual ;
*!*		WITH Caption = "Tipo de Propiedad", ;
*!*			Left = 400, ;
*!*			Top = 120
	
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
*		RowSourceType = 0

	
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
		RowSourceType = 2, ;
		RowSource = "Tipo_Unidad.descripcion"

	ADD OBJECT ogrd AS grd ;
	WITH Visible = .F.

	ADD OBJECT cmdModifi AS CommandButton ;
	WITH Top = 410, ;
		Left = 180, ;
		Width = 80, ;
		Height = 40, ;
		Caption = "Modificar"
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
		
	PROCEDURE otxbtorres.LostFocus
		Thisform.refresh()
	ENDPROC

	PROCEDURE ospnpisos.LostFocus
		Thisform.refresh()
	ENDPROC

	PROCEDURE otxbsuperficie.LostFocus
		Thisform.refresh
		select tablacuni
		sum tablacuni.superficie TO ss2

*		IF ss2 > Consorcios.superficie 
		IF ss2 > superff
			MESSAGEBOX("Se ha incrementado la superficie total del consorcio", 0, "Mensaje")
*			REPLACE superficie WITH ss2 IN Consorcios
			superff = ss2
		ELSE
*			IF ss2 < Consorcios.superficie 
			IF ss2 < superff
				MESSAGEBOX("Se ha decrementado la superficie total del consorcio", 0, "Mensaje")
*				REPLACE superficie WITH ss2 IN Consorcios
				superff = ss2
			ENDIF
		ENDIF
		thisform.olblsuperf2.Caption = ALLTRIM(STR(superff)) + " tot."
		
		SELECT tablacuni
		GO TOP
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
	ENDPROC

	PROCEDURE ocmbprop.InteractiveChange
		SELECT tablacuni
		REPLACE propietari WITH This.Value
		thisform.refresh
	ENDPROC

	PROCEDURE ocmbprop.LostFocus
		IF ALLTRIM(This.List(This.ListCount)) == ALLTRIM(This.Value)
			IF 6 == MESSAGEBOX("Desea cargar el nuevo propietario " ;
					,4+32,"Mensaje")
				ModProprio()
				This.Init
			ENDIF
		ENDIF
	ENDPROC
		
	PROCEDURE ocmbtipoprop.InteractiveChange
		SELECT tablacuni
		REPLACE tipo_unida WITH This.Value
		thisform.refresh
	ENDPROC
		
	PROCEDURE Init
		FOR a = 5 TO This.ControlCount
			This.Controls(a).Visible = .F.
		ENDFOR
	ENDPROC
		
	PROCEDURE cmdModifi.Click
	

*set step on
		SELECT tablacuni
		
		COPY TO ARRAY m_tablacuni
			
		LOCAL fila
		fila = 0
		SELECT Unidades
		SET ORDER TO PRIMARIO
*		SET FILTER TO Unidades.nro_consor = Consorcios.nro_consor
		GO TOP IN Unidades
		LOCATE FOR nro_consor = Consorcios.nro_consor .AND. ;
			nro_unidad = 1

		
*		DO WHILE .NOT. EOF("UnidadeConsorcios")
		FOR i = 1 TO ALEN("m_tablacuni", 1)
*			fila = fila + 1
*			SELECT Unidades
	
			REPLACE torre WITH m_tablacuni(i,2)
			REPLACE piso WITH m_tablacuni(i,3)
			REPLACE departamento WITH m_tablacuni(i,4)
			REPLACE superficie WITH m_tablacuni(i,5)
			REPLACE catastro WITH m_tablacuni(i,8)
				
			SELECT Propietarios
			SET ORDER TO apel_nom
			buscada = ","
			ap = LEFT(ALLTRIM(m_tablacuni[i,6]),(AT(buscada,ALLTRIM(m_tablacuni[i,6])))- 1)
			ap =  ap + SPACE(30 - LEN(ALLTRIM(ap)))
			lenna = LEN(ALLTRIM(m_tablacuni[i,6]))
*			no = ALLTRIM(RIGHT(ALLTRIM(m_tablacuni[i,6]), lenna - (AT(buscada,ALLTRIM(m_tablacuni[i,6]))- 1))))
*			no = ALLTRIM(RIGHT(ALLTRIM(m_tablacuni[i,6]),(AT(buscada,ALLTRIM(m_tablacuni[i,6])))))
			no = RIGHT(ALLTRIM(m_tablacuni[i,6]), lenna - AT(buscada,ALLTRIM(m_tablacuni[i,6])) - 1)
			no =  no + SPACE(30 - LEN(ALLTRIM(no)))

			SEEK ap + no
			IF !FOUND()
				MESSAGEBOX("Error")
				RETURN
			ENDIF
*			MESSAGEBOX(ap + no)

*			MESSAGEBOX(Propietarios.apellido + Propietarios.nombre)
*			RETURN
			
			*SEEK m_tablacuni(i,6)
			REPLACE cod_prorio WITH Propietarios.cod_prorio IN Unidades
						
			SELECT Tipo_unidad
			LOCATE FOR descripcion = m_tablacuni(i,7)
			
			REPLACE tip_unidad WITH Tipo_unidad.tip_unidad IN Unidades

			SELECT Unidades			
			SKIP
*		ENDDO
		ENDFOR
		
		REPLACE superficie WITH superff IN Consorcios
		Thisform.refresh
	ENDPROC	
	
	PROCEDURE cmdSalir.Click
		Release thisform
	ENDPROC

	PROCEDURE cmdCancelar.Click
		SELECT Unidades
		SET ORDER TO primario
		SET FILTER TO nro_consor = Consorcios.nro_consor
		GO BOTTOM
		IF 6 == MESSAGEBOX("Desea cancelar los cambios efectuados?", 4+32, "Mensaje del Sistema")
			
			Thisform.LockScreen = .T.
			LOCAL co
			co = Consorcios.nro_consor


				SELECT Unidades.nro_unidad AS Unidad, Unidades.torre AS Torre, ;
						Unidades.piso AS Piso, Unidades.Departamento AS Depto, ;
						Unidades.Superficie AS Superficie, ;
						(ALLTRIM(Propietarios.Apellido) + ", " + ;
						ALLTRIM(Propietarios.nombre)) AS Propietario, ;
						Tipo_unidad.descripcion AS Tipo_Unidad, ;
						Unidades.catastro AS catastro ;
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

				Thisform.ogrd.SetAll("DynamicBackColor", ;
					"IIF(tablacuni.torre = Thisform.otxbtorres.Value .AND. ;
					tablacuni.piso = Thisform.ospnpisos.Value, ;
					RGB(150,250,250), RGB(255,255,255))", "Column")  
				Thisform.ogrd.Column1.Width = 50
				Thisform.ogrd.Column2.Width = 35
				Thisform.ogrd.Column3.Width = 40
				Thisform.ogrd.Column4.Width = 40
				Thisform.ogrd.Column5.Width = 70
				Thisform.ogrd.Column6.Width = 150
				Thisform.ogrd.Column7.Width = 140
				Thisform.ogrd.Column8.Width = 60
				
				Thisform.olblsuperf2.Visible = .T.
*				select unidades
*				sum unidades.superficie FOR Unidades.nro_consor = Consorcios.nro_consor TO ss2
*				thisform.olblsuperf2.Caption = ALLTRIM(STR(ss2)) + " tot."  

				PUBLIC superff
				select tablacuni
				sum tablacuni.superficie TO superff
				thisform.olblsuperf2.Caption = ALLTRIM(STR(superff)) + " tot."  

				select consorcios

				Thisform.otxbtorres.ControlSource = "tablacuni.torre"
				Thisform.ospnpisos.ControlSource = "tablacuni.piso"
				Thisform.otxbdepto.ControlSource = "tablacuni.depto"
				Thisform.otxbsuperficie.ControlSource = "tablacuni.superficie"

				Thisform.ogrd.Column1.Text1.SetFocus
				Thisform.refresh
				Thisform.LockScreen = .F.

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