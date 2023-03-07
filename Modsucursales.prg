LPARAMETERS c1


DEBUGMODSUCURSALES = .F.

PUBLIC c
PUBLIC CCODDLOC
PUBLIC c2
IF EMPTY(c1)
	c1 = 1
*	c1 = 2
ENDIF

c = c1

cNueva = "Direccion de la sucursal"

IF USED("Bancos")
	SELECT Bancos
	SET ORDER TO
ENDIF
*SET ORDER TO

*USE Sucursales
IF !USED("Sucursales")
	USE Sucursales IN 0
ELSE
	SELECT Sucursales
ENDIF



SET ORDER TO idsucursal
PUBLIC ccod
SET FILTER TO cod_banco = c
GO BOTTOM
IF EOF()
	ccod = 1
ELSE
	ccod =  nro_suc + 1
ENDIF

SET FILTER TO
SET ORDER TO
*USE

*CLEAR ALL

PUBLIC cargo
cargo = .F.

ofrm = CREATEOBJECT("frm")

ofrm.Show


MESSAGEBOX("Se retorna " + STR(ccod))
RETURN ccod
*READ EVENTS


PROCEDURE getciu
	RETURN IIF(SEEK(Sucursales.cod_loc, "Ciudades", "cod_loc"), 1, 0)
ENDPROC



DEFINE CLASS grd AS Grid 
	Left = 70
	Top = 160
	ColumnCount = 5
	Height = 150
	Width = 450
	ReadOnly = .T.
	Enabled = .T.
*	RecordSource = "SELECT * FROM Sucursales WHERE cod_banco = icod_banco2"
	RecordSourceType = 1
*	ControlSource = "Sucursales"
	RecordSource = "Sucursales"
	DeleteMark = .F.
	Partition = 0
	SplitBar = .F.
*	RecordMark = .F.
	ScrollBars = 2
	LinkMaster = "Bancos"
*	LinkMaster = "Sucursales"
	ChildOrder = "cod_banco"
	RelationalExpr = "cod_banco"
	PROCEDURE Init
*		SET ORDER TO cod_banco
		This.Column1.Header1.Caption = "Cod. Banco"
		This.Column2.Header1.Caption = "Cod. Suc."
		This.Column3.Header1.Caption = "Descripcion"
		This.Column4.Header1.Caption = "Cod. Loc"
		This.Column5.Header1.Caption = "Cod. Barrio"
		This.Column1.ReadOnly = .T.
		This.Column2.ReadOnly = .T.
		This.Column3.ReadOnly = .T.
		This.Column4.ReadOnly = .T.
		This.Column5.ReadOnly = .T.
	ENDPROC
	PROCEDURE AfterRowColChange
	LPARAMETERS nÍndiceCol
*		GEBOX("ocurrio un afterrowcolchange")
		Thisform.oCmbBxCiudades.Renovar(Sucursales.cod_loc)
		THISFORM.oCmbBxCiudades.AddListItem("\-")
		THISFORM.oCmbBxCiudades.AddListItem("Otra Ciudad")
		IF Sucursales.cod_loc = 0
			THISFORM.oCmbBxCiudades.Selected(THISFORM.oCmbBxCiudades.ListCount - 1) = .T.
		ENDIF	

*		cbar = Sucursales.cod_barrio
*		IF cbar == 0
*			Thisform.oCmbBxBarrios.Renovar(1)
*		ENDIF
*		Thisform.oCmbBxBarrios.Renovar(Sucursales.cod_loc,cbar)
		Thisform.oCmbBxBarrios.Renovar(Sucursales.cod_loc,Sucursales.cod_barrio)


		THISFORM.oCmbBxBarrios.AddListItem("\-------------------------")
		THISFORM.oCmbBxBarrios.AddListItem("Otro Barrio")
*		Thisform.refresh


		Thisform.otext1.refresh
		


		IF ALLTRIM(Thisform.otext1.Value) = cNueva
			Thisform.otext1.SelectOnEntry = .T.
			Thisform.otext1.SetFocus
		ENDIF

		
		
		SELECT Bancos
		
	ENDPROC
ENDDEFINE

DEFINE CLASS tbx AS ComboBox
	RowSource = "Bancos.nombre"
	RowSourceType = 2
*	ControlSource = cc
	PROCEDURE LostFocus
		Select Bancos
*		SKIP
*		IF EOF()   
*			GO TOP
*		ENDIF
*		Thisform.Refresh
	ENDPROC
	PROCEDURE GotFocus
*		SELECT Sucursales


		SELECT Bancos


	ENDPROC
	PROCEDURE Init
	

		IF !USED("Bancos")
			USE Bancos IN 0
		ELSE
			SELECT Bancos
		ENDIF
	
*		SELECT Bancos
		
		

*****************88		
*		SET ORDER TO nombre
*		SET ORDER TO
********************		
		
*		GO TOP
		
*		This.Sorted = .T.
*		This.Refresh
*		LOCAL contador
		contador = 1


*		SET ORDER TO 1
		
*		SEEK c
		
*		nn = nombre
		
*		SET ORDER TO
*		GO RECORD c

*		This.Selected(RECNO()) = .T.		

		SCAN NOOPTIMIZE
		
*			MESSAGEBOX("Nombre " + nombre + " cod_banco " + STR(cod_banco) + " c " + STR(c))

			THIS.AddListItem(nombre)
			IF cod_banco = c
				This.Selected(contador) = .T.
*				MESSAGEBOX("OK " + "Nombre " + nombre + + STR(contador) + TRANSFORM(This.Selected(contador)))
			ENDIF
			contador = contador + 1
		ENDSCAN


	ENDPROC
	PROCEDURE Click
*		Thisform.Refresh
		
		
		
*		MESSAGEBOX("cod_banco " + STR(Sucursales.cod_banco) + "nro_suc " + STR(Sucursales.nro_suc))
		
*		This.Refresh()
*		Thisform.Refresh()
		
		SELECT Bancos		
	ENDPROC
ENDDEFINE

DEFINE CLASS text1 AS TextBox 
	Top = 50
	Left = 280
	Width = 170
	ControlSource = "Sucursales.direccion"
*	PROCEDURE Init
*		MESSAGEBOX(STR(Sucursales.cod_banco))
*		SEEK 5 ORDER TAG cod_loc IN "Sucursales"
*		MESSAGEBOX(STR(Sucursales.cod_banco))
*		This.Value = Sucursales.direccion
*		Thisform.Refresh
ENDDEFINE

DEFINE CLASS cCmbBxCiudades AS ComboBox 
	RowSourceType = 0
*	RowSource = ""
	ReadOnly = .T.
	Style = 2
	Left = 70
	Top = 180
	Width = 120
	PROCEDURE Renovar
	LPARAMETERS lcod_loc
		LOCAL contador
		contador = 1
		SELECT Ciudades
		SET ORDER TO nom_ciudad
		This.Clear
		IF EMPTY(lcod_loc)
*			lcod_loc = 1
			lcod_loc = 0
		ENDIF
		IF lcod_loc == 0
			SCAN
				This.AddListItem(nom_ciudad)
			ENDSCAN
		ELSE
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
		ENDIF
		*		USE
*		USE &cAlias

		
		
*		SELECT Bancos
		
		
	ENDPROC
	PROCEDURE Init
		PUBLIC CCODDLOC
		CCODDLOC = 1


*		This.Renovar()  && CambiOOO

*		This.Renovar(Sucursales.cod_loc)



*		THISFORM.CmbBxCiudades.AddListItem("\-------------------------")
*		THISFORM.CmbBxCiudades.AddListItem("Otra ciudad")
*		This.AddListItem("\-------------------------")

		This.AddListItem("\")

		This.AddListItem("Otra ciudad")
		Thisform.refresh()
	ENDPROC
	PROCEDURE LostFocus
		SELECT Ciudades
		SET ORDER TO nom_ciudad
		GO TOP
		SKIP This.ListIndex - 1
		CCODDLOC = cod_loc
*		USE
*		This.Value
		IF (This.ListItemID == This.ListCount)
			LOCAL ccod_loc1
			ccod_loc1 = Modificar()
			MESSAGEBOX(STR(ccod_loc1))


*			This.Renovar(ccod_loc1)
			This.Renovar(Sucursales.cod_loc)


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

		
*			SELECT Bancos

		ENDIF
*		USE &cAlias
	ENDPROC
	PROCEDURE Click
		SELECT Ciudades
		SET ORDER TO nom_ciudad
		GO TOP
		SKIP (Thisform.oCmbBxCiudades.ListItemID - 1)				
		cod_loc23 = cod_loc
		Thisform.oCmbBxBarrios.Renovar(cod_loc23)
		Thisform.oCmbBxBarrios.AddListItem("\-")
		Thisform.oCmbBxBarrios.AddListItem("Otro Barrio")
*		MESSAGEBOX("Click en combo")



***********8
		SELECT Bancos
*************

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
		SELECT Barrios
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
			This.Selected(1) = .T.
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

*		This.Renovar(1)  &&& CambiOOOO

*		cvacio = This.Renovar(Sucursales.cod_loc)


*		THIS.AddListItem("\-")
*		THIS.AddListItem("Otro Barrio")



*		SELECT Sucursales



	ENDPROC
	PROCEDURE GotFocus


		*		cvacio = This.Renovar(CCODDLOC) &&& CambiOOOO
		*		cvacio = This.Renovar(Sucursales.cod_loc)

*		cvacio = This.Renovar()
*		cvacio = This.Renovar(Sucursales.cod_loc,Sucursales.cod_barrio)
*		cvacio = This.Renovar(CCODDLOC)


		*		This.Renovar(2)
		*		THISFORM.CmbBxBarrios.AddListItem("\-------------------------")
		*		THISFORM.CmbBxBarrios.AddListItem("Otro Barrio")
		*		This.AddListItem("\-------------------------")

*		This.AddListItem("\-")
*
*		This.AddListItem("Otro Barrio")
*		IF cvacio
*			This.Selected(This.ListCount) = .T.
*		ENDIF
		*		USE
	ENDPROC
	PROCEDURE LostFocus
		IF This.ListItemID == This.ListCount .OR. ;
				This.ListItemID == (This.ListCount - 1) .OR. ;
				(EMPTY(This.Value))
			IF 6 == MESSAGEBOX("Desea cargar el barrio para la ciudad " + ;
				Thisform.ocmbBxCiudades.Value,4+32,"Mensaje")
				SELECT Ciudades
				SET ORDER TO nom_ciudad
				GO TOP
				SKIP (Thisform.oCmbBxCiudades.ListItemID - 1)				
*				DO ModBarrios WITH cod_loc
				cod_loc23 = cod_loc
				ccod3 = ModBarrios(cod_loc)
			
				MESSAGEBOX(STR(ccod3))
				This.Renovar(cod_loc23,ccod3)
				This.AddListItem("\-")
				This.AddListItem("Otro Barrio")


				Thisform.oCmbBxCiudades.Renovar(cod_loc23)
				


*******ULTIMO
				SELECT Bancos
**************
				
			ENDIF
		ENDIF
	ENDPROC
ENDDEFINE
	



DEFINE CLASS frm AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192, 192, 192)
	Caption = "Probar grillas con distintas tablas"
	Height = 400
	Width = 600
	Top = 15
	Left = 80
	ScaleMode = 3
	WindowType = 1
	ShowWindow = 1
	Visible = .T.
	Closable = .F.
	ADD OBJECT lbl AS Label ;
	WITH Caption = "Banco", ;
		AutoSize = .T., ;
		Top = 54, ;
		Left = 60
	ADD OBJECT otbx AS tbx ;
	WITH Top = 50, ;
		Left = 100
	ADD OBJECT lbl2 AS Label ;
	WITH Caption = "Sucursal", ;
		AutoSize = .T., ;
		Top = 54, ;
		Left = 220
	ADD OBJECT otext1 AS text1
	ADD OBJECT lbl3 AS Label ;
	WITH Caption = "Ciudad", ;
		AutoSize = .T., ;
		Top = 100, ;
		Left = 100
	ADD OBJECT oCmbBxCiudades AS cCmbBxCiudades ;
	WITH Top = 100, ;
		Left = 140
	ADD OBJECT lbl4 AS Label ;
	WITH Caption = "Barrio", ;
		AutoSize = .T., ;
		Top = 100, ;
		Left = 280
	ADD OBJECT oCmbBxBarrios AS cCmbBxBarrios ;
	WITH Top = 100, ;
		Left = 350
*	ADD OBJECT text1 AS TextBox ;
*	WITH Top = 50, ;
*		Left = 280, ;
*		ControlSource = "Sucursales.direccion"
	ADD OBJECT ogrd AS grd
	ADD OBJECT cmdNuevo AS CommandButton ;
	WITH Top = 335, ;
		Left = 150, ;
		Width = 60, ;
		Height = 30, ;
		Caption = "Nuevo"
	ADD OBJECT cmdCargar AS CommandButton ;
	WITH Top = 335, ;
		Left = 210, ;
		Width = 60, ;
		Height = 30, ;
		Enabled = .F., ;
		Default = .T., ;
		Caption = "Cargar"
	ADD OBJECT cmdModificar AS CommandButton ;
	WITH Top = 335, ;
		Left = 270, ;
		Width = 60, ;
		Height = 30, ;
		Caption = "Modificar"
	ADD OBJECT cmdSalir AS CommandButton ;
	WITH Top = 335, ;
		Left = 330, ;
		Width = 60, ;
		Height = 30, ;
		Caption = "Salir"
	PROCEDURE cmdNuevo.Click
		SELECT sucursales
		INSERT INTO Sucursales (nro_suc, cod_banco) VALUES ;
				(ccod, c)
		Thisform.Refresh()
		This.Enabled = .F.
		Thisform.cmdCargar.Enabled = .T.
		

*		SELECT sucursales
*		GO BOTTOM
		
		
*		Thisform.ogrd.ActivateCell(ccod,4)

**************************************
		Thisform.oCmbBxCiudades.Renovar(Sucursales.cod_loc)
		THISFORM.oCmbBxCiudades.AddListItem("\-")
		THISFORM.oCmbBxCiudades.AddListItem("Otra Ciudad")
		IF Sucursales.cod_loc = 0
			THISFORM.oCmbBxCiudades.Selected(THISFORM.oCmbBxCiudades.ListCount - 1) = .T.
		ENDIF	
		Thisform.oCmbBxBarrios.Renovar(Sucursales.cod_loc,Sucursales.cod_barrio)
		THISFORM.oCmbBxBarrios.AddListItem("\-------------------------")
		THISFORM.oCmbBxBarrios.AddListItem("Otro Barrio")

		Thisform.Refresh()
**************************************

		
		Thisform.otext1.Value = cNueva
		Thisform.otext1.SelectOnEntry = .T.
		Thisform.otext1.SetFocus
		
**************************************ULTIMO 2
		SELECT Bancos
		Thisform.Refresh()

**************************************
		
		
		
	ENDPROC
	PROCEDURE cmdCargar.Click
		Thisform.Refresh()
		This.Enabled = .F.
		cargo = .T.
	ENDPROC
	PROCEDURE cmdModificar.Click
		IF (Thisform.oCmbBxCiudades.ListItemID == Thisform.oCmbBxCiudades.ListCount .OR. ;
				Thisform.oCmbBxCiudades.ListItemID == (Thisform.oCmbBxCiudades.ListCount - 1) .OR. ;
				(EMPTY(Thisform.oCmbBxCiudades.Value)))
			MESSAGEBOX("Seleccione la nueva ciudad")
			RETURN
		ENDIF
		IF	(Thisform.oCmbBxBarrios.ListItemID == Thisform.oCmbBxBarrios.ListCount .OR. ;
				Thisform.oCmbBxBarrios.ListItemID == (Thisform.oCmbBxBarrios.ListCount - 1) .OR. ;
				(EMPTY(Thisform.oCmbBxBarrios.Value)))
			MESSAGEBOX("Seleccione el nuevo barrio")
			RETURN
		ENDIF

		SELECT Barrios
		SET ORDER TO descrip
		SET FILTER TO cod_loc = CCODDLOC
		GO TOP
		SKIP Thisform.oCmbBxBarrios.ListIndex - 1
		CCODBBARRIO = cod_barrio
*		MESSAGEBOX(STR(CCODDLOC)+ " " + STR(CCODBBARRIO))
		SET FILTER TO
		REPLACE Sucursales.cod_loc WITH CCODDLOC 
		REPLACE Sucursales.cod_barrio WITH CCODBBARRIO
	ENDPROC
	PROCEDURE cmdSalir.Click
		IF ALLTRIM(Thisform.otext1.Value) = cNueva
			IF 6 == MESSAGEBOX("¿Desea Cancelar la carga de la sucursal?" ;
					,4+32,"Mensaje")
				MESSAGEBOX("SI? Ok man vos lo quisiste")
				SELECT Sucursales
						
				SET ORDER TO IDSucursal



*				SEEK BINTOC(c,2)+BINTOC(ccod,2)
				SEEK STR(c) + STR(ccod2)




*				IF ALLTRIM(direccion) == ""
					delete 
*				WAIT WINDOW   " Que pasooooooo?"
					pack
					ccod = 0
				Release Thisform
*				ENDIF
*				USE
				
				
				SELECT Bancos
				
			ENDIF
		ELSE
			IF Thisform.cmdNuevo.Enabled = .T.
				ccod = 0
			ENDIF
			Release Thisform
		ENDIF
	ENDPROC
	PROCEDURE Load



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
		
		IF !USED("Bancos")
			USE Bancos IN 0 EXCLUSIVE
		ELSE
			SELECT Bancos
		ENDIF
		
		IF !USED("Sucursales")
			USE Sucursales IN 0 EXCLUSIVE
		ELSE
			SELECT Sucursales
		ENDIF
		
*		USE Ciudades IN 0 EXCLUSIVE
*		USE Barrios IN 0 EXCLUSIVE
*		USE Bancos IN 0 EXCLUSIVE
*		USE Sucursales IN 0 EXCLUSIVE





*		SELECT Sucursales
*		SET ORDER TO cod_loc
*		SELECT Ciudades
*		SET RELATION TO cod_loc INTO Sucursales
*		This.AddObject("otbx","tbx",c1)
*		This.otbx.Top = 50
*		This.otbx.Left = 100



*		SELECT Sucursales
		


*		GO TOP

		

		
		PUBLIC l
		l = .F.
	ENDPROC
	PROCEDURE otbx.GotFocus
*		This.otext1.SetFocus
*		This.otbx.Click
*		This.ogrd.ActivateCell(1,3)
*		This.otext1.Value = Sucursales.direccion
*		Thisform.ogrd.ActivateCell(1,3)
		IF !l
*			WAIT WINDOW "A ver, A ver..." + ALIAS() + STR(RECNO("Sucursales")) 

			
			
			GO TOP IN Sucursales
*			WAIT WINDOW "A ver, A ver..." + ALIAS() + STR(RECNO("Sucursales")) 
			
			

			SELECT Bancos
*			SET ORDER TO 1
*

			SET ORDER TO cod_banco


	*		SEEK 2 && Variable Global
			SEEK c && Variable Global
			Thisform.otext1.Value = Sucursales.direccion

			Thisform.oCmbBxCiudades.Renovar(Sucursales.cod_loc)
			THISFORM.oCmbBxCiudades.AddListItem("\-------------------------")
			THISFORM.oCmbBxCiudades.AddListItem("Otra Ciudad")
	*		Thisform.oCmbBxBarrios.Renovar(Sucursales.cod_loc)
			Thisform.oCmbBxBarrios.Renovar(Sucursales.cod_loc,Sucursales.cod_barrio)
			THISFORM.oCmbBxBarrios.AddListItem("\-------------------------")
			THISFORM.oCmbBxBarrios.AddListItem("Otro Barrio")
			SELECT Bancos
	*		Thisform.otext1.SetFocus
	*		SELECT Sucursales
	*		This.otbx.Click
	*		This.Refresh()
	*		This.Click
			l = .T.
			c2 = This.ListIndex
*			MESSAGEBOX(STR(c))



**************************************ULTIMO 3
		SELECT Bancos
		Thisform.Refresh()

**************************************
		

		ELSE
**************************************ULTIMO 4
		SELECT Bancos
		Thisform.Refresh()

**************************************
		
		ENDIF
	ENDPROC
	PROCEDURE otbx.Click
		DODEFAULT()
		IF This.Selected(c2)
			IF Thisform.cmdNuevo.Enabled = .F.
				Thisform.cmdNuevo.Enabled = .T.
			ENDIF
		ELSE
			IF Thisform.cmdNuevo.Enabled = .T.
				Thisform.cmdNuevo.Enabled = .F.
			ENDIF
		ENDIF				 
		IF cargo .OR. Thisform.cmdCargar.Enabled = .T.
			Thisform.cmdNuevo.Enabled = .F.
		ENDIF
		
		


		Thisform.oCmbBxCiudades.Renovar(Sucursales.cod_loc)
		THISFORM.oCmbBxCiudades.AddListItem("\-")
		THISFORM.oCmbBxCiudades.AddListItem("Otra Ciudad")
		IF Sucursales.cod_loc = 0
			THISFORM.oCmbBxCiudades.Selected(THISFORM.oCmbBxCiudades.ListCount - 1) = .T.
		ENDIF	
		Thisform.oCmbBxBarrios.Renovar(Sucursales.cod_loc,Sucursales.cod_barrio)
		THISFORM.oCmbBxBarrios.AddListItem("\-------------------------")
		THISFORM.oCmbBxBarrios.AddListItem("Otro Barrio")


*		Thisform.refresh
		
**************************************ULTIMO 5
		SELECT Bancos
		Thisform.Refresh()

**************************************
		
						 
	ENDPROC
	PROCEDURE Destroy
*		CLEAR EVENTS
*		Thisform.cmdSalir.Click


		IF DEBUGMODSUCURSALES
			CLOSE TABLES ALL
		ENDIF


	ENDPROC
	PROCEDURE Click
*		This.Refresh
	ENDPROC
ENDDEFINE