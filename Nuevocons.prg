****************************************************************
*		
*
*
*
*
*
****************************************************************



**************** SETEOS  ***********************************
*SET STEP ON
SET DELETE ON


*SET PROCEDURE TO PP
************* DEFINICIONES  *********************************


DEBUGNUEVOCONS = .F.

IF !USED("Administracion")
	USE Administracion IN 0
	SELECT Administracion
ELSE
	SELECT Administracion
ENDIF


IF !USED("Tipo_Administracion")
	USE Tipo_Administracion IN 0
	SELECT Tipo_Administracion
ELSE
	SELECT Tipo_Administracion
ENDIF


**************** MAIN ***************************************


oCiudades = CREATEOBJECT("cCiudades")

oConsorcio = CREATEOBJECT("cConsorcio")

frmNuevoConsorcio = CREATEOBJECT("cfrmNuevoConsorcio")



PUBLIC unid1
unid1 = .F.

frmNuevoConsorcio.Show(1)

IF unid1
	DO cargaruni WITH Consorcios.nro_consor
ENDIF



IF DEBUGNUEVOCONS
	CLOSE TABLES ALL
ENDIF

*********** DEFINICIONES DE CLASES ***************************

DEFINE CLASS cConsorcio AS Custom
	 nro_consor = 0
	 cod_loc = 0
	 cod_banco = 0
	 nro_suc = 0
	 cod_barrio = 0
	 nombre = ''
	 direccion = ''
	 superficie = 0.00
	 unidades = 1 
	 cta_cte = ''
	 PROCEDURE Init

SET DELETE OFF
*	 	USE Consorcios IN 0 ALIAS Consorcios
	IF !USED("Consorcios")
		USE Consorcios IN 0
	ELSE
		SELECT Consorcios
	ENDIF
		SELECT Consorcios

	 	SET ORDER TO nro_consor
	 	GO BOTTOM
	 	IF EOF()
	 		THIS.nro_consor = 1
	 	ELSE
	 		THIS.nro_consor = nro_consor + 1
	 	ENDIF
SET DELETE ON
	 	
	 ENDPROC
	 PROCEDURE CargarCons
	 	INSERT INTO Consorcios (nro_consor, nombre, direccion, ;
	 		superficie, unidades, cod_banco, nro_suc, cod_barrio, cod_loc, cta_cte) ;
	    	VALUES (THIS.nro_consor, THIS.nombre, ;
	 		THIS.direccion, THIS.superficie, THIs.unidades, ;
	 		this.cod_banco, this.nro_suc, this.cod_barrio, this.cod_loc, this.cta_cte)
			THIS.ClearCons
	 ENDPROC
	 PROCEDURE ClearCons
	 
*		 USE Consorcios
	IF !USED("Consorcios")
		USE Consorcios IN 0
	ELSE
		SELECT Consorcios
	ENDIF
*		 SELECT Consorcios
     
     
         GO BOTTOM
	 	 THIS.nro_consor = nro_consor + 1
		 THIS.nombre = ''
		 THIS.direccion = ''
		 THIS.superficie = 0.00
		 THIS.unidades = 1
	 PROCEDURE Destroy


*	 	USE 


	 ENDPROC
ENDDEFINE	

DEFINE CLASS cCiudades AS Custom
	cod_loc = 0
	nom_ciudad = ""
	PROCEDURE Destroy
	
*	 	USE 
	 	
	 	
	ENDPROC
ENDDEFINE

DEFINE CLASS cLabelCiudades AS Label
	Caption = "Ciudad" 
	Left = 17
	AutoSize = .T.
	Top = 185
ENDDEFINE

DEFINE CLASS cCmbBxCiudades AS ComboBox 
	RowSourceType = 0
	RowSource = ""
	Style = 2
	Left = 70
	Top = 180
	Width = 120
	PROCEDURE Renovar
	LPARAMETERS lcod_loc
		LOCAL contador
		contador = 1


*		USE Ciudades
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
*				THISFORM.CmbBxCiudades.AddListItem;
*									(nom_ciudad)
				This.AddListItem(nom_ciudad)
*				IF cod_loc == 1
				IF cod_loc == lcod_loc
*					Thisform.CmbBxCiudades.Selected(contador) = .T.
					This.Selected(contador) = .T.
*					CCODDLOC = cod_loc - 1
				ENDIF
				contador = contador + 1
			ENDSCAN
*		ELSE
*			SET ORDER TO 1
*			SEEK lcod_loc
*			THISFORM.CmbBxCiudades.AddListItem(nom_ciudad)
*			Thisform.CmbBxCiudades.Selected(1) = .T.
*		ENDIF


*		USE



*		USE &cAlias
	ENDPROC
	PROCEDURE Init
		PUBLIC CCODDLOC
		CCODDLOC = 1
		This.Renovar()
*		THISFORM.CmbBxCiudades.AddListItem("\-------------------------")
*		THISFORM.CmbBxCiudades.AddListItem("Otra ciudad")
*		This.AddListItem("\-------------------------")

		This.AddListItem("\")

		This.AddListItem("Otra ciudad")
		Thisform.refresh()
	ENDPROC
	PROCEDURE LostFocus
	
	
*		USE Ciudades
	IF !USED("Ciudades")
		USE Ciudades IN 0
	ELSE
		SELECT Ciudades
	ENDIF
*		SELECT Ciudades
		
		
		
		SET ORDER TO nom_ciudad
		GO TOP
		
		IF This.ListCount == 2
				CCODDLOC = 0
		ELSE

*			MESSAGEBOX(STR(This.ListIndex))
			SKIP This.ListIndex - 1
			CCODDLOC = cod_loc
			
		ENDIF
		
*		USE
		
		
		
*		This.Value
		IF (This.ListItemID == This.ListCount)
			LOCAL ccod_loc1
			ccod_loc1 = Modificar()
*			MESSAGEBOX(STR(ccod_loc1))
			This.Renovar(ccod_loc1)
			CCODDLOC = ccod_loc1
*			This.AddListItem("\-------------------------")

			This.AddListItem("\-")

			This.AddListItem("Otra ciudad")
*			THISFORM.CmbBxCiudades.AddListItem("\-------------------------")
*			THISFORM.CmbBxCiudades.AddListItem("Otra ciudad")
*			frmCrearCiu = CREATEOBJECT("Form")
*			frmCrearCiu.Show(1)
*			CREATE CLASSLIB comun
*			ADD CLASS frmModificar TO comun
*			This.Init
		ENDIF
*		USE &cAlias
	ENDPROC
	PROCEDURE Click
	
	
		SELECT Ciudades
*		USE Ciudades
		
		
		
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
		
*		MESSAGEBOX("Click en combo")
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
		
		
		
*		USE Barrios
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
*				THISFORM.CmbBxCiudades.AddListItem;
*										(nom_ciudad,recno())
				This.AddListItem(descripcion)
			ENDSCAN
		ELSE
			LOCATE FOR lcod_loc = cod_loc
			local contad 
			contad = 1
			DO WHILE FOUND()
*				THISFORM.CmbBxBarrios.AddListItem(descripcion)
				This.AddListItem(descripcion)
				IF cod_barrio = ccod4
					This.Selected(contad) = .T.
				ENDIF
				vacio = .F.
				contad = contad + 1
				CONTINUE
			ENDDO
		ENDIF
		
		
*		USE
		
		
		RETURN vacio
	ENDPROC
	PROCEDURE Init
		This.Renovar(1)
		THIS.AddListItem("\-")
		THIS.AddListItem("Otro Barrio")
*	ENDPROC
	PROCEDURE GotFocus
	
		IF CCODDLOC = 0
			cvacio = This.Renovar(1)
		ELSE
			cvacio = This.Renovar(CCODDLOC)
		ENDIF		
*		This.Renovar(2)
*		THISFORM.CmbBxBarrios.AddListItem("\-------------------------")
*		THISFORM.CmbBxBarrios.AddListItem("Otro Barrio")
*		This.AddListItem("\-------------------------")

		This.AddListItem("\-")

		This.AddListItem("Otro Barrio")
		IF cvacio
			This.Selected(This.ListCount) = .T.
		ENDIF
		
		
*		USE
		
		
	ENDPROC
	PROCEDURE LostFocus
		IF This.ListItemID == This.ListCount .OR. ;
				This.ListItemID == (This.ListCount - 1) .OR. ;
				(EMPTY(This.Value))
*			IF 6 == MESSAGEBOX("Desea cargar el barrio para la ciudad " + ;
*				Thisform.CmbBxCiudades.Value,4+32,"Mensaje")
			IF 6 == MESSAGEBOX("Desea cargar el barrio para la ciudad " + ;
				Thisform.ocmbBxCiudades.Value,4+32,"Mensaje")
				
				
*				USE Ciudades
				SELECT Ciudades
				
				
				
				SET ORDER TO nom_ciudad
				GO TOP
				SKIP (Thisform.oCmbBxCiudades.ListItemID - 1)				
*				DO ModBarrios WITH cod_loc
				cod_loc23 = cod_loc
				ccod3 = ModBarrios(cod_loc)
*				MESSAGEBOX(STR(ccod3))
				This.Renovar(cod_loc23,ccod3)
				
			ENDIF
		ENDIF
	ENDPROC
ENDDEFINE
	

DEFINE CLASS boxconten AS SHAPE
	Top = 4
	Left = 4
	Height = 140
	Width = 240
	Curvature = 1
	BackStyle = 0
ENDDEFINE

DEFINE CLASS containerbox AS Container
	Top = 150
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


DEFINE CLASS cfrmNuevoConsorcio AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192, 192, 192)
	Caption = "Crea un nuevo consorcio"
	Height = 400
	Width = 750
	Top = 30
	Left = 20
	ScaleMode = 3
	ShowWindow = 1
	Visible = .T.
	ADD OBJECT LabelNuevoCons AS Label ;
		WITH Caption = "Ingrese los datos del nuevo consorcio a administrar", ;
			Left = 10, ;
			AutoSize = .T., ; 
			FontItalic = .T., ; 
			Top = 20 
	ADD OBJECT LabelNroCons AS Label ;
		WITH Caption = "Código de Consorcio", ;
			Left = 10, ;
			AutoSize = .T., ; 
			Top = 55 
	ADD OBJECT NroCons AS TextBox ;
		WITH Left = 170, ;
			Top = 55, ;
			ReadOnly = .T., ;
			Enable = .F., ;
			TabStop = .F., ;
			Width = 50, ;
			ControlSource = "oConsorcio.nro_consor"
	ADD OBJECT LabelNombreCons AS Label ;
		WITH Caption = "Nombre del Consorcio", ;
			Left = 10, ;
			AutoSize = .T., ; 
			Top = 85
	ADD OBJECT NombreCons AS TextBox ;
		WITH Left = 170, ;
			Top = 85, ;
			Width = 210, ; 
			ControlSource = "oConsorcio.nombre"
	ADD OBJECT LabelDireccCons AS Label ;
		WITH Caption = "Dirección del Consorcio", ;
			Left = 10, ;
			AutoSize = .T., ; 
			Top = 115 
	ADD OBJECT DireccCons AS TextBox ;
		WITH Left = 170, ;
			Top = 115, ;
			Width = 280, ; 
			ControlSource = "oConsorcio.direccion"
	ADD OBJECT LabelSuperfCons AS Label ;
		WITH Caption = "Superficie Total   (opc.)", ;
			Left = 510, ;
			AutoSize = .T., ; 
			Top = 90 
	ADD OBJECT SuperfCons AS TextBox ;
		WITH Left = 640, ;
			Top = 85, ;
			Width = 70, ; 
			ControlSource = "oConsorcio.superficie"
	ADD OBJECT Labelm2SuperfCons AS Label ;
		WITH Caption = "m²", ;
			Left = 715, ;
			AutoSize = .T., ; 
			Top = 90
	ADD OBJECT LabelNroUnidades AS Label ;
		WITH Caption = "Número de Unidades", ;
			Left = 510, ;
			AutoSize = .T., ; 
			Top = 115
	ADD OBJECT NroUnidades AS Spinner ;
		WITH Left = 640, ;
			Top = 115, ;
			Width = 70, ; 
			KeyboardHighValue = 300, ; 
			KeyboardLowValue = 1, ; 
			SpinnerHighValue = 300, ; 
			SpinnerLowValue = 1, ; 
			Value = 1, ; 
			ControlSource = "oConsorcio.unidades"
	ADD OBJECT oLabelCiudades AS cLabelCiudades 
	ADD OBJECT oCmbBxCiudades AS cCmbBxCiudades
	ADD OBJECT oLabelBarrios AS cLabelBarrios
	ADD OBJECT oCmbBxBarrios AS cCmbBxBarrios

	ADD OBJECT chkverif AS CheckBox ;
		WITH Caption = "Posee cta. cte.", ;
			Left = 280, ;
			Top = 150

	ADD OBJECT LabelBancos AS Label ;
		WITH Caption = "Banco", ;
			Left = 230, ;
			AutoSize = .T., ; 
			Visible = .T., ; 
			Top = 184
	ADD OBJECT CmbBxBancos AS ComboBox ;
		WITH RowSourceType = 0, ;
			RowSource = "", ;
			Style = 2, ;
			Left = 280, ;
			Top = 180, ;
			Width = 120
	ADD OBJECT LabelSucursales AS Label ;
		WITH Caption = "Sucursal", ;
			Left = 245, ;
			AutoSize = .T., ; 
			Top = 225
	ADD OBJECT CmbBxSucursales AS ComboBox ;
		WITH RowSourceType = 0, ;
			RowSource = "", ;
			Style = 2, ;
			Left = 310, ;
			Top = 220, ;
			Width = 120
			
	ADD OBJECT LabelCta_Cte AS Label ;
		WITH Caption = "cta. cte", ;
			Left = 285, ;
			AutoSize = .T., ; 
			Top = 265
	ADD OBJECT TxBxCta_Cte AS TextBox ;
	WITH Left = 330, ;
			Top = 260, ;
			Width = 120



*		WITH RowSourceType = 0, ;
*			RowSource = "", ;
*			Style = 2, ;
			
*	ADD OBJECT chkverif AS CheckBox ;
*		WITH Caption = "Posee cta. cte.", ;
*			Left = 280, ;
*			Top = 150

	ADD OBJECT obox3d AS containerbox
			
	ADD OBJECT texto1 AS Label ;
	WITH Caption = "Administración", ;
		AutoSize = .T., ;
		FontItalic = .T., ;
		Top = 148, ;
		Left = 490
			
	ADD OBJECT LabelTipoAdministracion AS Label ;
		WITH Caption = "Tipo de Administracion", ;
			Left = 488, ;
			AutoSize = .T., ; 
			Visible = .T., ; 
			Top = 180
	ADD OBJECT CmbBxTipoAdminis AS ComboBox ;
		WITH RowSourceType = 2, ;
			RowSource = "Administracion.Descripcion", ;
			Style = 2, ;
			Left = 620, ;
			Top = 178, ;
			Width = 90
			
	ADD OBJECT LabelInteresXdia AS Label ;
		WITH Caption = "Interés mensual", ;
			Left = 570, ;
			AutoSize = .T., ; 
			Visible = .T., ; 
			Top = 220
	ADD OBJECT TxBxInteresXdia AS Textbox ;
	WITH Left = 660, ;
		Top = 218, ;
		Width = 50
			
*	ADD OBJECT LabelDeuda_Atraz AS Label ;
*		WITH Caption = "Actualizar deuda", ;
*			Left = 520, ;
*			AutoSize = .T., ; 
*			Visible = .T., ; 
*			Top = 260
	ADD OBJECT chkCobra_Atraz AS CheckBox ;
	WITH Left = 600, ;
		Top = 258, ;
		Width = 110, ;
		Alignment = 1, ;
		Caption = "Actualizar deuda"
			
	
			
	ADD OBJECT ButsCargar AS CommandGroup ;
		WITH ButtonCount = 3, ;
			BorderStyle = 0, ;
			Height = 50, ;
			Width = 450, ;
			Left = 140, ;
			Top = 330

	PROCEDURE TXBxInteresXdia.Init
		PUBLIC dato
		dato = 00.00
		This.ControlSource = "dato"
*		This.Format = "LR"
*		This.InputMask = "  99.99"
*		This.Value = "  00.00"
	ENDPROC

*	PROCEDURE TXBxInteresXdia.Validar
*		IF VAL(This.Value) < 0.00
*			MESSAGEBOX("El número ingresado debe ser positivo", ;
*						"Entrada inválida")
*			This.SetFocus
*			RETURN .F.
*		ENDIF

*	PROCEDURE CmbBxTipoAdminis.Validar

*		PUBLIC int
*		int = 0.00		
*		This.ControlSource = "Tipo_Administracion.intereses"


*		This.ControlSource = 0.00
*		This.Value = int
*	ENDPROC
	PROCEDURE chkverif.Init
		This.Value = .F.
*		Thisform.CmbBxBancos.Enabled = .F.
*		Thisform.CmbBxsucursales.Enabled = .F.
	ENDPROC
	PROCEDURE LabelBancos.Init
*		This.Value = .F.
*		Thisform.CmbBxBancos.Enabled = .F.
*		Thisform.CmbBxsucursales.Enabled = .F.
	ENDPROC
	PROCEDURE chkverif.Click
		IF (This.Value)
			Thisform.CmbBxBancos.Enabled = .T.
			Thisform.CmbBxsucursales.Enabled = .T.
			Thisform.TxBxCta_Cte.ReadOnly = .F.
		ELSE
			Thisform.CmbBxBancos.Enabled = .F.
			Thisform.CmbBxsucursales.Enabled = .F.
			Thisform.TxBxCta_Cte.ReadOnly = .T.
		ENDIF
	ENDPROC
			
	PROCEDURE CmbBxBancos.Renovar
	LPARAMETERS lcod_banco
		LOCAL contador
		contador = 1
		
		
*		USE Bancos
	IF !USED("Bancos")
		USE Bancos IN 0
		SELECT Bancos
	ELSE
		SELECT Bancos
	ENDIF
		
		
		SET ORDER TO nombre
		This.Clear
		IF EMPTY(lcod_banco)
			lcod_banco = 1
		ENDIF
			SCAN
				THIS.AddListItem(nombre)
*				IF cod_loc == 1
				IF cod_banco == lcod_banco
					This.Selected(contador) = .T.
*					CCODDLOC = cod_loc - 1
				ENDIF
				contador = contador + 1
			ENDSCAN
*		ELSE
*			SET ORDER TO 1
*			SEEK lcod_loc
*			THISFORM.CmbBxCiudades.AddListItem(nom_ciudad)
*			Thisform.CmbBxCiudades.Selected(1) = .T.
*		ENDIF


*		USE
		
		
	ENDPROC
	PROCEDURE CmbBxBancos.Init
		This.Enabled = .F.
		PUBLIC CCODDBANCO
		CCODDBANCO = 1
		This.Renovar()
		THIS.AddListItem("\-------------------------")
		THIS.AddListItem("Otra banco")
		Thisform.refresh()
	ENDPROC
	PROCEDURE CmbBxBancos.Click
	
	
*		USE Bancos
		SELECT Bancos
		
		
		SET ORDER TO nombre
		GO TOP
		
*		MESSAGEBOX(STR(Thisform.CmbBxBancos.ListItemID))
*		MESSAGEBOX(STR(Thisform.CmbBxBancos.ListIndex))

		IF (This.ListCount == 2)
			cod_banco23 = 0
		ELSE
			SKIP (This.ListIndex - 1)				
			cod_banco23 = cod_banco
		ENDIF

*		SKIP (Thisform.CmbBxBancos.ListItemID - 1)				
*		cod_banco23 = cod_banco
		Thisform.CmbBxSucursales.Renovar(cod_banco23)



*		MESSAGEBOX("Click en combo")
	ENDPROC
	PROCEDURE CmbBxBancos.LostFocus
	
	
*		USE Bancos
		SELECT Bancos
		
		
		SET ORDER TO nombre
		GO TOP
*		SKIP This.ListIndex - 1
*		CCODDBANCO = cod_banco
		

		IF (This.ListCount == 2)
			CCODDBANCO = cod_banco
		ELSE
			SKIP (This.ListIndex - 1)				
*			cod_loc23 = cod_loc
			CCODDBANCO = cod_banco
		ENDIF
*		Thisform.oCmbBxBarrios.Renovar(cod_loc23)



		
*		USE
				
		
*		This.Value
		IF (This.ListItemID == This.ListCount)
			LOCAL ccod_banco1
*			ccod_banco1 = Modificar()
*			ccod_banco1 = ModBanco()
			ccod_banco1 = ModBanco()
*			MESSAGEBOX(STR(ccod_banco1))
			This.Renovar(ccod_banco1)
			CCODDBANCO = ccod_banco1
			THIS.AddListItem("\-------------------------")
			THIS.AddListItem("Otro banco")
*			frmCrearCiu = CREATEOBJECT("Form")
*			frmCrearCiu.Show(1)
*			CREATE CLASSLIB comun
*			ADD CLASS frmModificar TO comun
*			This.Init
		ENDIF
	ENDPROC
	PROCEDURE CmbBxSucursales.Renovar
	LPARAMETERS lcod_banco, ccod5
	
	
*		USE Sucursales
		IF !USED("Sucursales")
			USE Sucursales IN 0
			SELECT Sucursales
		ELSE
			SELECT Sucursales
		ENDIF
		
		
		
		SET ORDER TO direccion
		
		
		
*		SET ORDER TO cod_loc
		This.Clear
		IF EMPTY(ccod5)
			ccod5 = 99999
		ENDIF
		IF EMPTY(lcod_banco)
			SCAN
				THIS.AddListItem(direccion)
			ENDSCAN
		ELSE
			LOCATE FOR lcod_banco = cod_banco
			local contad 
			contad = 1
			DO WHILE FOUND()
				THIS.AddListItem(direccion)
				IF nro_suc = ccod5
					This.Selected(contad) = .T.
				ENDIF
				contad = contad + 1
				CONTINUE
			ENDDO
		ENDIF
		
		
*		USE
		
		
		
	ENDPROC
*	PROCEDURE CmbBxBarrios.Init
*		This.Renovar(1)
*		THISFORM.CmbBxBarrios.AddListItem("\-------------------------")
*		THISFORM.CmbBxBarrios.AddListItem("Otro Barrio")
*	ENDPROC
	PROCEDURE CmbBxSucursales.GotFocus
		This.Renovar(CCODDBANCO)
*		This.Renovar(2)
		THIS.AddListItem("\-------------------------")
		THIS.AddListItem("Otra Sucursales")
		
		
*		USE
		
		
	ENDPROC
	PROCEDURE CmbBxSucursales.LostFocus
		IF This.ListItemID == This.ListCount .OR. ;
				This.ListItemID == (This.ListCount - 1) .OR. ;
				(EMPTY(This.Value))
			IF Thisform.CmbBxBancos.ListItemID == Thisform.CmbBxBancos.ListCount .OR. ;
					Thisform.CmbBxBancos.ListItemID == (Thisform.CmbBxBancos.ListCount - 1) .OR. ;
					(EMPTY(Thisform.CmbBxBancos.Value))
				MESSAGEBOX("Debe definir primero el banco",0,"Mensaje")	
				RETURN
			ENDIF
*			IF Thisform.CmbBxBancos.Value
			IF 6 == MESSAGEBOX("Desea cargar la sucursal para el banco " + ;
				Thisform.CmbBxBancos.Value,4+32,"Mensaje")
				
				
*				USE Bancos
				SELECT Bancos
				
				
				SET ORDER TO nombre
				GO TOP
				SKIP (Thisform.CmbBxBancos.ListItemID - 1)				
*				DO ModBarrios WITH cod_loc
				cod_banco233 = cod_banco
				

*				MESSAGEBOX(STR(cod_banco))

				
*				SET
				
				ccod23 = ModSucursales(cod_banco)
*				MESSAGEBOX(STR(ccod23))
				This.Renovar(cod_banco233,ccod23)
				
			ENDIF
		ENDIF
	PROCEDURE CmbBxSucursales.Init
		This.Enabled = .F.
	PROCEDURE TxBxCta_Cte.Init
		This.SelectOnEntry = .T.
		This.Value = "            /  "
		This.ReadOnly = .T.
		This.Format = "R"
		This.InputMask = "999999999/99"
	PROCEDURE ButsCargar.Init
		THIS.SetAll("Height", 30, "CommandButton") 
		THIS.SetAll("Top", 12, "CommandButton") 
		THIS.Buttons(1).Caption = "Cargar"
		THIS.Buttons(2).Caption = "Cancelar"
		THIS.Buttons(3).Caption = "Salir"
		THIS.Buttons(1).Left = 25
		THIS.Buttons(2).Left = 175
		THIS.Buttons(3).Left = 325
		THIS.Buttons(2).Cancel = .T.
	ENDPROC
	PROCEDURE NombreCons.Validar
		IF ALLTRIM(oConsorcio.nombre) == ""
			MESSAGEBOX("Se requiere del nombre del consorcio", ;
						"Entrada inválida")
			Thisform.NombreCons.SetFocus
			RETURN .F.
		ENDIF
	ENDPROC
	PROCEDURE DireccCons.Validar
		IF ALLTRIM(oConsorcio.direccion) == ""
			MESSAGEBOX("Se requiere de la dirección del consorcio", ;
						"Entrada inválida")
			Thisform.DireccCons.SetFocus
			RETURN .F.
		ENDIF
	ENDPROC
	PROCEDURE SuperfCons.Validar
		IF oConsorcio.superficie < 0
			MESSAGEBOX("La superficie debe ser positiva", ;
						"Entrada inválida")
			Thisform.SuperfCons.SetFocus
			RETURN .F.
		ENDIF
	ENDPROC
	PROCEDURE NroUnidades.Validar
		IF oConsorcio.unidades == 1
			MESSAGEBOX("Establezca el número de unidades de consorcio", ;
						"Entrada inválida")
			Thisform.NroUnidades.SetFocus
			RETURN .F.
		ENDIF
	ENDPROC
*	PROCEDURE CmbBxBancos.LostFocus
*			DO ModBanco
*	ENDPROC
	PROCEDURE CmbBxTipoAdminis.Validar
*		MESSAGEBOX(STR(Thisform.CmbBxTipoAdminis.ListIndex))
		IF (Thisform.CmbBxTipoAdminis.ListIndex == 0)
				MESSAGEBOX("Debe definir el tipo de administracion del consorcio", "Entrada inválida")
				RETURN .F.
		ENDIF
	ENDPROC



	PROCEDURE ButsCargar.Click()
		DO CASE
			CASE THIS.Value = 1
				IF (THISFORM.NombreCons.Validar() .AND. ;
					THISFORM.DireccCons.Validar() .AND. ;
					THISFORM.SuperfCons.Validar() .AND. ;
					THISFORM.NroUnidades.Validar() .AND. ;
					Thisform.CmbBxTipoAdminis.Validar())
					
					oConsorcio.unidades = thisform.NroUnidades.Value

					oConsorcio.cod_loc = CCODDLOC

					IF Thisform.oCmbBxBarrios.ListIndex == (Thisform.oCmbBxBarrios.ListCount  - 1) 
						LOC = 0
					ELSE
						SELECT Barrios
						SET FILTER TO cod_loc = CCODDLOC
						SET ORDER TO descrip
						GO TOP
*						MESSAGEBOX(STR(Thisform.oCmbBxBarrios.ListIndex - 1))
						SKIP Thisform.oCmbBxBarrios.ListIndex - 1
						LOC = cod_barrio
						SET FILTER TO
					ENDIF
					oConsorcio.cod_barrio = LOC

					IF Thisform.chkverif.Value == .T.
						oConsorcio.cod_banco = CCODDBANCO
	
						IF Thisform.CmbBxsucursales.ListIndex == (Thisform.CmbBxSucursales.ListCount - 1) ;
						.OR. Thisform.CmbBxsucursales.ListIndex == Thisform.CmbBxSucursales.ListCount 
							LOC = 0
						ELSE
							SELECT Sucursales
							SET FILTER TO cod_banco = CCODDBANCO
							SET ORDER TO direccion
							GO TOP
							SKIP Thisform.CmbBxSucursales.ListIndex - 1
							LOC = nro_suc
							SET FILTER TO
						ENDIF
						oConsorcio.nro_suc = LOC
					ELSE
						oConsorcio.cod_banco = 0
						oConsorcio.nro_suc = 0
					ENDIF
					
					oConsorcio.cta_cte = Thisform.TxBxCta_Cte.Value
					oConsorcio.CargarCons
					
*					SELECT Administracion
					
*					SCAN 

*					MESSAGEBOX(Thisform.CmbBxAdminis.Value)
*					MESSAGEBOX(TRANSFORM(Thisform.chkCobra_Atraz.Value + 2),0, "Value de checkbox")

					IF Thisform.chkCobra_Atraz.Value == 0
						letra = 'N'
					ELSe
						letra = 'S'
					ENDIF	 


*					letra = IIF(IF(Thisform.chkCobra_Atraz.Value == .T.), "S", "N")					


*					MESSAGEBOX(letra)
*					aa = VAL(Thisform.TxBxInteresXdia.Value) + 12.98
*					MESSAGEBOX(STR(aa))
*					MESSAGEBOX(Thisform.TxBxInteresXdia.Value)
*					INSERT INTO Tipo_Administracion (nro_consor, adm_tipo, vigencia, intereses, cobra_atraz) ;
*						VALUES (oConsorcio.nro_consor, Thisform.CmbBxTipoAdminis.ListIndex, DATE(), Thisform.TxBxInteresXdia.Value, IIF((Thisform.chkCobra_Atraz.Value), "S", "N"))
					INSERT INTO Tipo_Administracion (nro_consor, adm_tipo, vigencia, intereses, cobra_atraz) ;
						VALUES (oConsorcio.nro_consor, Thisform.CmbBxTipoAdminis.ListIndex, DATE(), Thisform.TxBxInteresXdia.Value, letra)
					MESSAGEBOX("Consorcio  " + RTRIM(nombre) + ;
						" cargado en disco", Thisform.Caption)
						
					IF 6 == MESSAGEBOX("Continuar con la carga de las unidades del consorcio", 4+32, "Mensaje")
						unid1 = .T.
						Release Thisform
					ELSE
						Release Thisform
					ENDIF
						
*					THISForm.Refresh()
*					THISFORm.NombreCons.SetFocus
				ENDIF
			CASE THIS.Value = 2		
				IF 6==MESSAGEBOX("Cancelar la carga del Consorcio  " ;
						 + oConsorcio.nombre, 4 + 32 + 256, ;
						Thisform.Caption)
					oConsorcio.ClearCons
					Thisform.oCmbBxCiudades.Renovar(1)
					THISFORM.oCmbBxCiudades.AddListItem("\-------------------------")
					THISFORM.oCmbBxCiudades.AddListItem("Otra Ciudad")
					CCODDLOC = 1
					Thisform.oCmbBxBarrios.Renovar(1)
					THISFORM.oCmbBxBarrios.AddListItem("\-------------------------")
					THISFORM.oCmbBxBarrios.AddListItem("Otro Barrio")
					IF Thisform.chkverif.Value = .T.
						Thisform.chkverif.Value = .F.
						Thisform.CmbBxBancos.Enabled = .F.
						Thisform.CmbBxsucursales.Enabled = .F.
						Thisform.TxBxCta_Cte.ReadOnly= .T.
					ENDIF
					
					FOR i = 0 TO thisform.CmbBxTipoAdminis.ListCount
						thisform.CmbBxTipoAdminis.Selected(i) = .F.
					ENDFOR
					Thisform.TxBxInteresXdia.Value = 0.00
					Thisform.chkCobra_Atraz.Value = .F.
					THISForm.Refresh()
					THISFORm.NombreCons.SetFocus
				ENDIF
				Thisform.NombreCons.SetFocus
			CASE THIS.Value = 3
*				MESSAGEBOX("   Saliendo...                ", ;
*						   Thisform.Caption)
				THISFORM.Release
		ENDCASE
	ENDPROC
*	PROCEDURE Init
*		Thisform.chkverif.TabIndex = Thisform.chkverif.TabIndex + 1
ENDDEFINE


************ PROCEDIMIENTOS   ********************************
