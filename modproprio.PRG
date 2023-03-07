SET PROCEDURE TO


IF USED("Docu_tipo2")
	SELECT Docu_tipo2
ELSE
	USE Docu_tipo2
	SELECT Docu_tipo2
ENDIF

IF USED("Ciudades")
	SELECT Ciudades
ELSE
	USE Ciudades IN 0
ENDIF

IF USED("Barrios")
	SELECT Barrios
ELSE
	USE Barrios IN 0
ENDIF


IF USED("Propietarios")
	SELECT Propietarios
ELSE
	USE Propietarios IN 0
	SELECT Propietarios
ENDIF

SET ORDER TO cod_prorio

GO BOTTOM

PUBLIC ccodp11

ccod11p =  cod_prorio + 1

cNuevop = "Apellido"
cAlias = "Propietarios"
ofrmModBarri = CREATEOBJECT("frmModifi")

ofrmModBarri.Closable = .T.
ofrmModBarri.Show()


RETURN ccod11p
PROCEDURE programa
	INSERT INTO Propietarios (cod_prorio) VALUES (ccod11p)
ENDPROC

PROCEDURE programa2
	SELECT Propietarios
	REPLACE apellido WITH ofrmModBarri.otxbApellido.Value
	REPLACE nombre WITH ofrmModBarri.otxbNombres.Value
	REPLACE direccion WITH ofrmModBarri.otxbNombres.Value
	REPLACE tipo_doc WITH Docu_tipo2.tipo_doc
	REPLACE nro_doc WITH ofrmModBarri.otxbNroDoc.Value
	REPLACE cod_loc WITH Ciudades.cod_loc
*	REPLACE cod_barrio WITH Barrios.cod_barrio
	REPLACE cod_barrio WITH ofrmModBarri.oCmbBxBarrios.ListItemID
	REPLACE telefono WITH ofrmModBarri.otxbTelefono.Value
ENDPROC

PROCEDURE programa3
		SELECT Propietarios
		GO BOTTOM
		IF ALLTRIM(apellido) == ""
		delete 
		pack
ENDIF


DEFINE CLASS grdbarrios AS Grid
	Left = 65
	Top = 120
	ColumnCount = 9
	Height = 150
	ReadOnly = .T.
	Enabled = .T.
	DeleteMark = .F.
	RecordMark = .F.
	Partition = 0
	SplitBar = .F.
	ScrollBars = 2
	TabStop = .F.
	RecordSource = "Propietarios"
	
	
	PROCEDURE Init
		This.Columns(1).ReadOnly = .T.
		This.Columns(2).ReadOnly = .T.
		This.Columns(3).ReadOnly = .T.
		This.Columns(4).ReadOnly = .T.
		This.Columns(5).ReadOnly = .T.
		This.Columns(6).ReadOnly = .T.
		This.Columns(7).ReadOnly = .T.
		This.Columns(8).ReadOnly = .T.
		This.Columns(9).ReadOnly = .T.
		This.Columns(1).Header1.Caption = "Cód."
		This.Columns(2).Header1.Caption = "Apellido"
		This.Columns(3).Header1.Caption = "Nombres"
		This.Columns(4).Header1.Caption = "Direccion"
		This.Columns(5).Header1.Caption = "T.Doc"
		This.Columns(6).Header1.Caption = "Doc"
		This.Columns(7).Header1.Caption = "Loc"
		This.Columns(8).Header1.Caption = "Barrio"
		This.Columns(9).Header1.Caption = "Teléfono"
		This.Columns(1).Width = 25
		This.Columns(2).Width = 100
		This.Columns(3).Width = 180
		This.Columns(4).Width = 137
		This.Columns(5).Width = 0
		This.Columns(6).Width = 40
		This.Columns(7).Width = 30
		This.Columns(8).Width = 40
		This.Columns(9).Width = 90

		This.Columns(5).Visible = .F.
		This.Columns(5).Enabled = .F.

		DO programa

	ENDPROC
 	PROCEDURE Click
		MESSAGEBOX(This.Columns(2).Controls(2).Name)
		Thisform.Refresh()
	ENDPROC
	PROCEDURE Column1.Click
		MESSAGEBOX("Se hizo click en la columna 1")
		Thisform.Refresh()
	ENDPROC
	
	PROCEDURE Destroy
		DO programa3
	ENDPROC
ENDDEFINE




DEFINE CLASS cCmbBxCiudades AS ComboBox 
	RowSourceType = 0
	ReadOnly = .T.
	Style = 2
	Left = 70
	Top = 180
	Width = 120

	PROCEDURE Renovar
	LPARAMETERS lcod_loc
		LOCAL contador
		contador = 1

	IF !USED("Ciudades")
		USE Ciudades IN 0
	ELSE
		SELECT Ciudades
	ENDIF
		SELECT Ciudades


		SET ORDER TO nom_ciudad
		This.Clear
		IF EMPTY(lcod_loc)
			lcod_loc = 1
		ENDIF
		SCAN
			This.AddListItem(nom_ciudad)
			IF cod_loc == lcod_loc
				This.Selected(contador) = .T.
			ENDIF
			contador = contador + 1
		ENDSCAN
	ENDPROC

	PROCEDURE Init
		PUBLIC CCODDLOC
		CCODDLOC = 1
		This.Renovar()
		This.AddListItem("\-")

		This.AddListItem("Otra ciudad")
		Thisform.refresh()
	ENDPROC
	PROCEDURE LostFocus
	
		IF !USED("Ciudades")
			USE Ciudades IN 0
		ELSE
			SELECT Ciudades
		ENDIF
	
		SET ORDER TO nom_ciudad
		GO TOP
		
		IF This.ListCount == 2
				CCODDLOC = 0
		ELSE
			SKIP This.ListIndex - 1
			CCODDLOC = cod_loc
		ENDIF

		IF (This.ListItemID == This.ListCount)
			LOCAL ccod_loc1
			ccod_loc1 = Modificar()
			This.Renovar(ccod_loc1)
			CCODDLOC = ccod_loc1
			This.AddListItem("\-")
			This.AddListItem("Otra ciudad")
		ENDIF
	ENDPROC
	PROCEDURE Click
		SELECT Ciudades
		SET ORDER TO nom_ciudad
		GO TOP
		
		IF (Thisform.oCmbBxCiudades.ListIndex == 2)
			cod_loc23 = 0
			Thisform.oCmbBxBarrios.Renovar(1)
		ELSE
			SKIP (Thisform.oCmbBxCiudades.ListItemID - 1)				
			cod_loc23 = cod_loc
			Thisform.oCmbBxBarrios.Renovar(cod_loc23)
		ENDIF
	ENDPROC
ENDDEFINE

DEFINE CLASS cLabelBarrios AS Label
	Caption = "Barrio"
	Left = 50
	AutoSize = .T.
	Top = 225
ENDDEFINE

DEFINE CLASS cCmbBxBarrios AS ComboBox
	RowSourceType = 0
	RowSource = ""
	Style = 2
	Left = 100
	Top = 220
	Width = 120

	PROCEDURE Renovar
	LPARAMETERS lcod_loc, ccod4
		LOCAL vacio
		vacio = .T.
		IF !USED("Barrios")
			USE Barrios IN 0
			SELECT Barrios
		ELSE
			SELECT Barrios
		ENDIF
	
		SET ORDER TO descrip
		This.Clear
		IF EMPTY(ccod4)
			ccod4 = 0
		ENDIF
		IF EMPTY(lcod_loc)
			SCAN
				This.AddListItem(descripcion)
			ENDSCAN
		ELSE
			LOCATE FOR lcod_loc = cod_loc
			local contad 
			contad = 1
			DO WHILE FOUND()
				This.AddListItem(descripcion)
				IF cod_barrio = ccod4
					This.Selected(contad) = .T.
				ENDIF
				vacio = .F.
				contad = contad + 1
				CONTINUE
			ENDDO
		ENDIF
		RETURN vacio
	ENDPROC
	PROCEDURE Init
		This.Renovar(1)
		THIS.AddListItem("\-")
		THIS.AddListItem("Otro Barrio")
	ENDPROC
	
	PROCEDURE GotFocus
	
		IF CCODDLOC = 0
			cvacio = This.Renovar(1)
		ELSE
			cvacio = This.Renovar(CCODDLOC)
		ENDIF		
		This.AddListItem("\-")

		This.AddListItem("Otro Barrio")
		IF cvacio
			This.Selected(This.ListCount) = .T.
		ENDIF
	ENDPROC

	PROCEDURE LostFocusError
		IF This.ListItemID == This.ListCount .OR. ;
				This.ListItemID == (This.ListCount - 1) .OR. ;
				(EMPTY(This.Value))
			IF 6 == MESSAGEBOX("Desea cargar el barrio para la ciudad " + ;
				Thisform.ocmbBxCiudades.Value,4+32,"Mensaje")
				SELECT Ciudades
			
				SET ORDER TO nom_ciudad
				GO TOP
				SKIP (Thisform.oCmbBxCiudades.ListItemID - 1)				
				
				cod_loc23 = cod_loc
*				ccod3 = ModBarrios2(cod_loc)
				ccod3 = ModBarrios(cod_loc)
				This.Renovar(cod_loc23,ccod3)
*				This.AddListItem("\-")
*				This.AddListItem("Otro Barrio")
			ENDIF
		ENDIF
	ENDPROC
ENDDEFINE


DEFINE CLASS frmModifi AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192, 192, 192)
	Caption = "    Crear Propietarios"
	Height = 430
	Width = 758
	Top = 15
	Left = 30
	ScaleMode = 3
	WindowType = 1
	ShowWindow = 1
	Visible = .T.
	Closable = .F.
	ADD OBJECT LabelCodLoc AS Label ;
	WITH Left = 17, ;
		AutoSize = .T., ;
		Top = 48, ; 
		Caption = "Cód.:"
	ADD OBJECT CodLoc AS TextBox ;
	WITH Left = 53, ;
		Value = ccod11p, ;
		Top = 45, ;
		ReadOnly = .T., ;
		Enable = .F., ;
		TabStop = .T., ;
		Width = 35
	ADD OBJECT olblApellido AS Label ;
	WITH Caption = "Apellido:", ;
		Left = 115, ;
		AutoSize = .T., ;
		Top = 48
	ADD OBJECT otxbApellido AS TextBox ;
	WITH Left = 168, ;
		Height = 25, ;
		Top = 45, ;
		Width = 125
		
	ADD OBJECT olblNombre AS Label ;
	WITH Caption = "Nombres:", ;
		Left = 310, ;
		AutoSize = .T., ;
		Top = 48
	ADD OBJECT otxbNombres AS TextBox ;
	WITH Left = 370, ;
		Height = 25, ;
		Top = 45, ;
		Width = 165
		
	ADD OBJECT olblTelefono AS Label ;
	WITH Caption = "teléfono:", ;
		Left = 570, ;
		AutoSize = .T., ;
		Top = 48
	ADD OBJECT otxbTelefono AS TextBox ;
	WITH Left = 630, ;
		Height = 25, ;
		Top = 45, ;
		Width = 90
		
		
	ADD OBJECT olblTipoDoc AS Label ;
	WITH Caption = "Tipo doc.:", ;
		Left = 40, ;
		AutoSize = .T., ;
		Top = 100
	ADD OBJECT ocmbTipoDoc AS ComboBox;
	WITH Left = 100, ;
		Height = 25, ;
		Top = 97, ;
		Width = 47, ;
		RowSourceType = 6, ;
		RowSource = "docu_tipo2.descripcion", ;
		Style = 2
		
	ADD OBJECT olblNroDoc AS Label ;
	WITH Caption = "Nro.doc:", ;
		Left = 170, ;
		AutoSize = .T., ;
		Top = 100
		
	ADD OBJECT otxbNroDoc AS TextBox ;
	WITH Left = 220, ;
		Height = 25, ;
		Top = 98, ;
		Width = 70, ;
		Value = 0
		
		
	ADD OBJECT lbl3 AS Label ;
	WITH Caption = "Ciudad:", ;
		AutoSize = .T., ;
		Top = 100, ;
		Left = 335
	ADD OBJECT oCmbBxCiudades AS cCmbBxCiudades ;
	WITH Top = 98, ;
		Left = 390
	ADD OBJECT lbl4 AS Label ;
	WITH Caption = "Barrio:", ;
		AutoSize = .T., ;
		Top = 100, ;
		Left = 550
	ADD OBJECT oCmbBxBarrios AS cCmbBxBarrios ;
	WITH Top = 98, ;
		Left = 600
*	ADD OBJECT text1 AS TextBox ;
*	WITH Top = 50, ;
*		Left = 280, ;
*		ControlSource = "Sucursales.direccion"		
		
		

	ADD OBJECT olblDireccion AS Label ;
	WITH Caption = "Direccion:", ;
		Left = 190, ;
		AutoSize = .T., ;
		Top = 150
		
	ADD OBJECT otxbDireccion AS TextBox ;
	WITH Left = 260, ;
		Height = 25, ;
		Top = 147, ;
		Width = 250
		
		


		
	ADD OBJECT ogrdbarrios AS grdbarrios ;
	WITH Top = 195, ;
		Left = 40, ;
		Width = 670, ;
		Height = 165
		
	PROCEDURE otxbApellido.Init
		This.Value = cNuevop
		This.SelectOnEntry = .T.
		This.SetFocus
	ENDPROC
	PROCEDURE otxbApellido.GotFocus
		ThisForm.CodLoc.Refresh()
	ENDPROC
	ADD OBJECT cmdCargar AS CommandButton ;
		WITH Left = 150, ;
			Caption = "Cargar", ;
			Height = 30, ;
			Top = 385, ;
			Width = 90 
*			Default = .T., ;

	ADD OBJECT cmdSalir AS CommandButton ;
		WITH Left = 290, ;
			Caption = "Salir", ;
			Height = 30, ;
			Top = 385, ;
			Width = 90 

*			Cancel = .T., ;


	ADD OBJECT cmdModificar AS CommandButton ;
		WITH Left = 430, ;
			Caption = "Modificar", ;
			Height = 30, ;
			Top = 385, ;
			Enabled = .F., ;
			Width = 90
	PROCEDURE cmdCargar.Click
*		set step on
		IF ThisForm.otxbApellido.Value == cNuevop .OR. ;
				ALLTRIM(ThisForm.otxbApellido.Value) == '' .OR. ;
				ALLTRIM(Thisform.otxbNombres.Value) == "" .OR. ;
				ALLTRIM(Thisform.ocmbTipoDoc.Value) == "" .OR. ;
				EMPTY(Thisform.otxbNroDoc.Value) .OR. ;
				Thisform.otxbNroDoc.Value > 99999999 .OR. ;
				ALLTRIM(Thisform.otxbDireccion.Value) == "" 
				
			MESSAGEBOX("Falta especificar aulgun dao para la carga " + ;
							" a cargar","Mensaje")
			ThisForm.otxbApellido.SetFocus
		ELSE
			DO programa2
*			REPLACE nom_ciudad WITH ThisForm.Nom_ciudad.Value
			ThisForm.otxbApellido.Value = cNuevop
*			ThisForm.opgfMod.Pages(1).oNom_Ciudad.ReadOnly = .T.
			This.Enabled = .F.
			Thisform.cmdModificar.Enabled = .T.
			ThisForm.otxbApellido.SetFocus
		ENDIF
	PROCEDURE cmdSalir.Click
		IF (ThisForm.otxbApellido.Value = cNuevop .OR. ;
				ThisForm.otxbApellido.Value == "")
			Release Thisform
		ELSE
			SELECT Propietarios
			IF 6==MESSAGEBOX("Cancelar la carga del propietario  " ;
						 + apellido, 4 + 32 + 256, ;
						"Mensaje")
				REPLACE apellido WITH ""
				ThisForm.otxbApellido.Value = cNuevop
				ThisForm.otxbApellido.SetFocus
			ENDIF
		ENDIF
	ENDPROC
	PROCEDURE cmdModificar.Click
		Thisform.cmdCargar.Click()
*		Thisform.opgfMod.Pages(1).ogrdciudad.Columns(2).Controls(Thisform.opgfMod.Pages(1).ogrdciudad.Columns(2).ControlCount).ReadOnly = .F.
*		IF ActivateRow != 
ENDDEFINE
		



