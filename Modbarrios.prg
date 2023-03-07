LPARAMETER icod_loc

PUBLIC icod_loc2 
icod_loc2 = icod_loc
IF EMPTY(icod_loc)
	icod_loc2 = 1
ENDIF
*SET PROCEDURE TO pp
SET PROCEDURE TO
SELECT Barrios
SET ORDER TO cod_barrio
PUBLIC ccod

GO BOTTOM

*LOCAL ccod
ccod =  cod_barrio + 1

SET FILTER TO cod_loc = icod_loc2

*LOCATE FOR cod_loc = icod_loc

cNueva = "Aca va el string"

ofrmModBarri = CREATEOBJECT("frmModifi")

ofrmModBarri.Closable = .T.
ofrmModBarri.Show()
*USE


SET FILTER TO


RETURN ccod
PROCEDURE programa
	INSERT INTO Barrios (cod_barrio, cod_loc) VALUES ;
				(ccod, icod_loc2)
ENDPROC

PROCEDURE programa2
	REPLACE descripcion WITH ofrmModBarri.Nom_ciudad.Value
ENDPROC

PROCEDURE programa3
		GO BOTTOM
		IF ALLTRIM(descripcion) == ""
		delete 
		pack
*		USE
ENDIF

DEFINE CLASS grdbarrios AS Grid
	Left = 65
	Top = 120
	ColumnCount = 4
	Height = 150
	ReadOnly = .T.
	Enabled = .T.
	PROCEDURE Init
		This.Columns(1).ReadOnly = .T.
		This.Columns(2).ReadOnly = .T.
		This.Columns(1).Header1.Caption = "Barrio"
		This.Columns(2).Header1.Caption = "Ciudad"
		This.Columns(3).Header1.Caption = "Nombre"
		This.Columns(4).Header1.Caption = "Cod.Postal"
		DO programa
*		INSERT INTO Ciudades (cod_loc) VALUES (ccod_loc)
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
*		GO BOTTOM
*		IF ALLTRIM(nom_ciudad) == ""
*			delete 
*			pack
*			USE
*			ccod_loc = 0
*		ENDIF
	ENDPROC
ENDDEFINE


DEFINE CLASS frmModifi AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192, 192, 192)
	Caption = "Crear o modificar Barrios"
	Height = 400
	Width = 470
	Top = 45
	Left = 100
	ScaleMode = 3
	WindowType = 1
	ShowWindow = 1
	Visible = .T.
	Closable = .F.
	ADD OBJECT LabelCodLoc AS Label ;
	WITH Left = 30, ;
		AutoSize = .T., ;
		Top = 48, ; 
		Caption = "Código"
	ADD OBJECT CodLoc AS TextBox ;
	WITH Left = 90, ;
		Value = ccod, ;
		Top = 45, ;
		ReadOnly = .T., ;
		Enable = .F., ;
		TabStop = .T., ;
		Width = 50
	ADD OBJECT LabelNom_Ciudad AS Label ;
	WITH Caption = "Nombre", ;
		Left = 185, ;
		AutoSize = .T., ;
		Top = 48
	ADD OBJECT Nom_Ciudad AS TextBox ;
	WITH Left = 265, ;
		Height = 25, ;
		Top = 45, ;
		Width = 125
	ADD OBJECT ogrdbarrios AS grdbarrios	
	PROCEDURE Nom_Ciudad.Init
		This.Value = cNueva
		This.SelectOnEntry = .T.
		This.SetFocus
	ENDPROC
	PROCEDURE Nom_Ciudad.GotFocus
		ThisForm.CodLoc.Refresh()
	ENDPROC
	ADD OBJECT cmdCargar AS CommandButton ;
		WITH Left = 80, ;
			Caption = "Cargar", ;
			Default = .T., ;
			Height = 30, ;
			Top = 320, ;
			Width = 90 
	ADD OBJECT cmdSalir AS CommandButton ;
		WITH Left = 170, ;
			Caption = "Salir", ;
			Height = 30, ;
			Top = 320, ;
			Width = 90 

*			Cancel = .T., ;

	ADD OBJECT cmdModificar AS CommandButton ;
		WITH Left = 260, ;
			Caption = "Modificar", ;
			Height = 30, ;
			Top = 320, ;
			Enabled = .F., ;
			Width = 90
	PROCEDURE cmdCargar.Click
		IF ThisForm.Nom_Ciudad.Value = cNueva .OR. ;
				ALLTRIM(ThisForm.Nom_Ciudad.Value) == ""
			MESSAGEBOX("Ingrese el nombre de la ciudad " + ;
							" a cargar","Mensaje")
			ThisForm.Nom_Ciudad.SetFocus
		ELSE
			DO programa2
*			REPLACE nom_ciudad WITH ThisForm.Nom_ciudad.Value
			ThisForm.Nom_Ciudad.Value = cNueva
*			ThisForm.opgfMod.Pages(1).oNom_Ciudad.ReadOnly = .T.
			This.Enabled = .F.
			Thisform.cmdModificar.Enabled = .T.
			ThisForm.Nom_Ciudad.SetFocus
		ENDIF
	PROCEDURE cmdSalir.Click
		IF (ThisForm.Nom_ciudad.Value = cNueva .OR. ;
				ALLTRIM(ThisForm.Nom_ciudad.Value) == "")



*			Release Thisform
			Thisform.Release




		ELSE
			IF 6==MESSAGEBOX("Cancelar la carga del barrio  " ;
						 + Thisform.Nom_ciudad.Value, 4 + 32 + 256, ;
						"Mensaje")
				REPLACE descripcion WITH ""
				ThisForm.Nom_ciudad.Value = cNueva
				ThisForm.Nom_ciudad.SetFocus
			ENDIF
		ENDIF
	ENDPROC
	PROCEDURE cmdModificar.Click
		Thisform.cmdCargar.Click()
*		Thisform.opgfMod.Pages(1).ogrdciudad.Columns(2).Controls(Thisform.opgfMod.Pages(1).ogrdciudad.Columns(2).ControlCount).ReadOnly = .F.
*		IF ActivateRow != 
	Procedure Click
		MessageBox("Click en el form")
ENDDEFINE
		
