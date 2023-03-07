***********************************************



*** MAIN ***************************************
*(LPARAMETERS ccod_loc1

*PUBLIC ccod_loc2
cCaption = "Crear y modificar ciudades"

SELECT Ciudades
*USE Ciudades
SET ORDER TO cod_loc
GO BOTTOM
PUBLIC ccod_loc
ccod_loc =  cod_loc + 1
cNueva = "Ciudad..."
*USE


*opdfMod = CREATEOBJECT("pgfMod")
ofrmModificar = CREATEOBJECT("frmModificar")

ofrmModificar.Show()


RETURN ccod_loc
**** DEFINICIONES DE CLASES ************************


DEFINE CLASS grdciudad AS Grid
	Left = 65
	Top = 120
	ColumnCount = 2
	Height = 150
	ReadOnly = .T.
	Enabled = .T.
	PROCEDURE Init
		This.Columns(1).ReadOnly = .T.
		This.Columns(2).ReadOnly = .T.
		This.Columns(1).Header1.Caption = "Código"
		This.Columns(2).Header1.Caption = "Nombre"



*		MESSAGEBOX(STR(ccod_loc
		
		INSERT INTO Ciudades (cod_loc) VALUES (ccod_loc)
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
		GO BOTTOM
		IF ALLTRIM(nom_ciudad) == ""
			delete 
			pack
*			USE
			ccod_loc = 0
		ENDIF
	ENDPROC
ENDDEFINE

DEFINE CLASS pgfMod AS PageFrame 
	PageCount = 2
	Width = 500 
	Top = 20
	Left = 30
ENDDEFINE

*	ADD OBJECT opgfMod AS pgfMod ;
*		WITH PageCount = 2 
*	PROCEDURE opgfMod.Init
*		This.Pages(1).AddObject("oLabelCodLoc","LabelCodLoc")
*		This.Pages(1).AddObject("oCodLoc","CodLoc")
*		This.Pages(1).oLabelCodLoc.Visible = .T.
*		This.Pages(1).oCodLoc.Visible = .T.
*		This.Pages(1).AddObject("oLabelNom_Ciudad","LabelNom_Ciudad")
*		This.Pages(1).AddObject("oNom_Ciudad","Nom_Ciudad")
*		This.Pages(1).oLabelNom_Ciudad.Visible = .T.
*		This.Pages(1).oNom_Ciudad.Visible = .T.
*		This.Pages(1).AddObject("ogrdciudad","grdciudad")
*		This.Pages(1).ogrdciudad.Visible = .T.
*	ENDPROC


DEFINE CLASS frmModificar AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192, 192, 192)
	Caption = cCaption
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
		Value = ccod_loc, ;
		Top = 45, ;
		ReadOnly = .T., ;
		Enable = .F., ;
		TabStop = .T., ;
		ControlSource = "Ciudades.cod_loc", ;
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
	ADD OBJECT ogrdciudad AS grdciudad	
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
			Cancel = .T., ;
			Height = 30, ;
			Top = 320, ;
			Width = 90 
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
			REPLACE nom_ciudad WITH ThisForm.Nom_ciudad.Value
			ThisForm.Nom_Ciudad.Value = cNueva
*			ThisForm.opgfMod.Pages(1).oNom_Ciudad.ReadOnly = .T.
			This.Enabled = .F.
			Thisform.cmdModificar.Enabled = .T.
			ThisForm.Nom_Ciudad.SetFocus
		ENDIF
	PROCEDURE cmdSalir.Click
		IF (ThisForm.Nom_ciudad.Value = cNueva .OR. ;
				ThisForm.Nom_ciudad.Value == "")
			Release Thisform
		ELSE
			IF 6==MESSAGEBOX("Cancelar la carga de la ciudad  " ;
						 + nom_ciudad, 4 + 32 + 256, ;
						"Mensaje")
				REPLACE nom_ciudad WITH ""
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
		
