****************************************************************
*		
*
*
****************************************************************



**************** SETEOS  ***********************************
SET DELETE ON

************* DEFINICIONES  *********************************


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

PUBLIC m_elim


**************** MAIN ***************************************
frmNuevoConsorcio = CREATEOBJECT("cfrmNuevoConsorcio")
frmNuevoConsorcio.Show(1)

*********** DEFINICIONES DE CLASES ***************************


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
ENDDEFINE
	

DEFINE CLASS boxconten AS SHAPE
	Top = 4
	Left = 4
	Height = 125
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
	ADD OBJECT box1 AS boxconten ;
	WITH BorderColor = RGB(255,255,255), ;
		Left = 5, ;
		Top = 5
	ADD OBJECT box2 AS boxconten ;
	WITH BorderColor = RGB(128,128,128)
ENDDEFINE


DEFINE CLASS grdModCons AS Grid
	Left = 2
	Top = 240
	Width = 770
	Height = 180
	Visible = .T.
	DeleteMark = .F.
	RecordMark = .F.
	Partition = 0
	SplitBar = .F.
	ScrollBars = 2
	TabStop = .T.
	RecordSource = "CurCons"	
	ColumnCount = 13

	PROCEDURE Init

		This.SetAll("FontSize", 8)	
		
		This.Column1.Width = 17
		This.Column1.ReadOnly = .T.
		This.Column2.Width = 116
		This.Column3.Width = 105
		This.Column4.Width = 48
		This.Column4.ReadOnly = .T.
		This.Column5.Width = 20
		This.Column6.Width = 60
		This.Column7.Width = 73
		This.Column8.Width = 54
		This.Column9.Width = 64
		This.Column10.Width = 68
		This.Column11.Width = 65
		This.Column12.Width = 38
		This.Column13.Width = 13

		Thisform.ogrdModCons.Column1.Header1.Caption = "Nro"
		Thisform.ogrdModCons.Column2.Header1.Caption = "Nombre"
		Thisform.ogrdModCons.Column3.Header1.Caption = "Direccion"
		Thisform.ogrdModCons.Column4.Header1.Caption = "Superf"
		Thisform.ogrdModCons.Column5.Header1.Caption = "Unids"
		Thisform.ogrdModCons.Column6.Header1.Caption = "Ciudad"
		Thisform.ogrdModCons.Column7.Header1.Caption = "Barrio"
		Thisform.ogrdModCons.Column8.Header1.Caption = "Banco"
		Thisform.ogrdModCons.Column9.Header1.Caption = "Sucursal"
		Thisform.ogrdModCons.Column10.Header1.Caption = "Cta. Cte."
		Thisform.ogrdModCons.Column11.Header1.Caption = "Tipo Adm."
		Thisform.ogrdModCons.Column12.Header1.Caption = "Intereses"
		Thisform.ogrdModCons.Column13.Header1.Caption = "Atraz."
		

		Thisform.ogrdModCons.SetAll("Movable", .F.)

*		Thisform.ogrdModCons.Column1.Text1.setfocus

		Thisform.Refresh
		
		
		Thisform.ogrdmodCons.SetAll("DynamicBackColor", ;
			"IIF(CurCons.nro_consor = Thisform.NroCons.Value, ;
			RGB(150,250,250), RGB(255,255,255))", "Column")  


		Thisform.NroCons.Enabled = .F.
		Thisform.NombreCons.Enabled = .F.
		Thisform.DireccCons.Enabled = .F.
		Thisform.NroUnidades.Enabled = .F.
		Thisform.TxBxCta_Cte.Enabled = .F.
		Thisform.TxBxInteresXdia.Enabled = .F.
		Thisform.oCmbBxCiudades.Enabled = .F.
		Thisform.oCmbBxBarrios.Enabled = .F.
		Thisform.CmbBxTipoAdminis.Enabled = .F.
		Thisform.chkCobra_Atraz.Enabled = .F.
		Thisform.CmbBxBancos.Enabled = .F.
		Thisform.CmbBxSucursales.Enabled = .F.
		

		
	ENDPROC
	PROCEDURE AfterRowColChange
	LPARAMETERS nindice
		
		Thisform.LockScreen = .T.
		SELECT Ciudades
		SET ORDER TO nom_ciudad
		SEEK CurCons.ciudad
		IF !FOUND()
			MESSAGEBOX("NO SE ENcONTRO LA ciudad")
		ENDIF
		
		SELECT Barrios
		SET ORDER TO Descrip
		SEEK CurCons.barrio		
		IF !FOUND()
			MESSAGEBOX("NO SE ENcONTRO el barrio")
		ENDIF
		
		Thisform.oCmbBxCiudades.Clear
		Thisform.oCmbBxCiudades.AddListItem(CurCons.ciudad)
		Thisform.oCmbBxCiudades.Value = CurCons.ciudad
		Thisform.oCmbBxBarrios.Renovar(Ciudades.cod_loc, Barrios.cod_barrio)
		

		IF USED("Bancos")
			SELECT Bancos
		ELSE
			USE Bancos
			SELECT Banos
		ENDIF
		SET ORDER TO nombre
		SEEK CurCons.banco
		
		IF USED("Sucursales")
			SELECT Sucursales
		ELSE
			USE Sucursales
			SELECT Sucursales
		ENDIF
		SET ORDER TO Direccion
		SEEK CurCons.sucursal		

		Thisform.CmbBxBancos.Clear
		Thisform.CmbBxBancos.AddListItem(CurCons.banco)
		Thisform.CmbBxBancos.Value = CurCons.banco

		Thisform.CmbBxSucursales.Renovar(Bancos.cod_banco, Sucursales.nro_suc)
		
			
		Thisform.refresh
		IF CurCons.atraz = 'S'
			Thisform.chkCobra_Atraz.Value = .T.
		ELSE
			Thisform.chkCobra_Atraz.Value = .F.
		ENDIF

		DO CASE 
			CASE ALLTRIM(CurCons.adminis) = "Monto Fijo"
				Thisform.CmbBxTipoAdminis.Selected(2) = .T.
			CASE ALLTRIM(CurCons.adminis) = "Presupuestado"
				Thisform.CmbBxTipoAdminis.Selected(3) = .T.
			CASE ALLTRIM(CurCons.adminis) = "Sobre lo gastado"
				Thisform.CmbBxTipoAdminis.Selected(1) = .T.
		ENDCASE
				

		IF EMPTY(ALLTRIM(CurCons.cta_cte))
			Thisform.chkverif.Value = .F.
		ELSE
			Thisform.chkverif.Value = .T.
		ENDIF
			
		Thisform.refresh
		Thisform.LockScreen = .F.
	ENDPROC
ENDDEFINE



DEFINE CLASS cfrmNuevoConsorcio AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192, 192, 192)
	Caption = "Modificar datos de consorcio"
	Height = 490
	Width = 780
	Top = 10
	Left = 5
	ScaleMode = 3
	ShowWindow = 1
	Visible = .T.

	ADD OBJECT LabelNroCons AS Label ;
		WITH Caption = "Cod", ;
			Left = 10, ;
			AutoSize = .T., ; 
			Top = 25 
	ADD OBJECT NroCons AS TextBox ;
		WITH Left = 40, ;
			Top = 22, ;
			ReadOnly = .T., ;
			Enable = .F., ;
			TabStop = .F., ;
			Width = 30
			
	ADD OBJECT LabelNombreCons AS Label ;
		WITH Caption = "Nombre", ;
			Left = 90, ;
			AutoSize = .T., ; 
			Top = 25
	ADD OBJECT NombreCons AS TextBox ;
		WITH Left = 140, ;
			Top = 22, ;
			Width = 150 
			
	ADD OBJECT LabelDireccCons AS Label ;
		WITH Caption = "Dirección", ;
			Left = 310, ;
			AutoSize = .T., ; 
			Top = 25 
	ADD OBJECT DireccCons AS TextBox ;
		WITH Left = 370, ;
			Top = 22, ;
			Width = 190 

	ADD OBJECT LabelSuperfCons AS Label ;
		WITH Caption = "Sup.", ;
			Left = 573, ;
			AutoSize = .T., ; 
			FontSize = 8, ;
			Top = 25 
	ADD OBJECT SuperfCons AS TextBox ;
		WITH Left = 600, ;
			Top = 22, ;
			Width = 40, ;
			FontSize = 8 

	ADD OBJECT LabelNroUnidades AS Label ;
		WITH Caption = "Unidades", ;
			Left = 650, ;
			AutoSize = .T., ; 
			FontSize = 8, ;
			Top = 25
	ADD OBJECT NroUnidades AS Spinner ;
		WITH Left = 699, ;
			Top = 22, ;
			Width = 48, ; 
			KeyboardHighValue = 300, ; 
			KeyboardLowValue = 1, ; 
			SpinnerHighValue = 300, ; 
			SpinnerLowValue = 1, ; 
			Value = 1, ; 
			FontSize = 8
			
	ADD OBJECT oLabelCiudades AS cLabelCiudades ;
	WITH Top = 85
	ADD OBJECT oCmbBxCiudades AS cCmbBxCiudades ;
	WITH Top = 85
	ADD OBJECT oLabelBarrios AS cLabelBarrios ;
	WITH Top = 135
	ADD OBJECT oCmbBxBarrios AS cCmbBxBarrios ;
	WITH Top = 135

	ADD OBJECT chkverif AS CheckBox ;
		WITH Caption = "Posee cta. cte.", ;
			Left = 280, ;
			Top = 70, ;
			Enabled = .F.

	ADD OBJECT LabelBancos AS Label ;
		WITH Caption = "Banco", ;
			Left = 230, ;
			AutoSize = .T., ; 
			Visible = .T., ; 
			Top = 109
	ADD OBJECT CmbBxBancos AS ComboBox ;
		WITH RowSourceType = 0, ;
			RowSource = "", ;
			Style = 2, ;
			Left = 280, ;
			Top = 105, ;
			Width = 120
	ADD OBJECT LabelSucursales AS Label ;
		WITH Caption = "Sucursal", ;
			Left = 245, ;
			AutoSize = .T., ; 
			Top = 145
	ADD OBJECT CmbBxSucursales AS ComboBox ;
		WITH RowSourceType = 0, ;
			RowSource = "", ;
			Style = 2, ;
			Left = 310, ;
			Top = 140, ;
			Width = 120
			
	ADD OBJECT LabelCta_Cte AS Label ;
		WITH Caption = "cta. cte", ;
			Left = 285, ;
			AutoSize = .T., ; 
			Top = 182
	ADD OBJECT TxBxCta_Cte AS TextBox ;
	WITH Left = 330, ;
			Top = 180, ;
			Width = 120


	ADD OBJECT obox3d AS containerbox ;
	WITH Top = 70
			
	ADD OBJECT texto1 AS Label ;
	WITH Caption = "Administración", ;
		AutoSize = .T., ;
		FontItalic = .T., ;
		Top = 68, ;
		Left = 490
			
	ADD OBJECT LabelTipoAdministracion AS Label ;
		WITH Caption = "Tipo de Administracion", ;
			Left = 488, ;
			AutoSize = .T., ; 
			Visible = .T., ; 
			Top = 95
	ADD OBJECT CmbBxTipoAdminis AS ComboBox ;
		WITH RowSourceType = 2, ;
			RowSource = "Administracion.Descripcion", ;
			Style = 2, ;
			Left = 620, ;
			Top = 92, ;
			Width = 90
			
	ADD OBJECT LabelInteresXdia AS Label ;
		WITH Caption = "Interés mensual", ;
			Left = 570, ;
			AutoSize = .T., ; 
			Visible = .T., ; 
			Top = 130
	ADD OBJECT TxBxInteresXdia AS Textbox ;
	WITH Left = 660, ;
		Top = 128, ;
		Width = 50

	ADD OBJECT chkCobra_Atraz AS CheckBox ;
	WITH Left = 600, ;
		Top = 162, ;
		Width = 110, ;
		Alignment = 1, ;
		Caption = "Actualizar deuda"
			
	ADD OBJECT ogrdModCons	AS grdModCons
			
	ADD OBJECT ButsCargar AS CommandGroup ;
		WITH ButtonCount = 3, ;
			BorderStyle = 0, ;
			Height = 50, ;
			Width = 450, ;
			Left = 140, ;
			Top = 430


	PROCEDURE chkverif.Init
		This.Value = .F.
	ENDPROC

	PROCEDURE CmbBxSucursales.Renovar
	LPARAMETERS lcod_banco, ccod5
	
		IF !USED("Sucursales")
			USE Sucursales IN 0
			SELECT Sucursales
		ELSE
			SELECT Sucursales
		ENDIF
		
		SET ORDER TO direccion
		
		This.Clear
		This.Value = ""
		IF EMPTY(ccod5)
			ccod5 = 0
		ENDIF
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
	ENDPROC

	

	PROCEDURE TxBxCta_Cte.Init
		This.SelectOnEntry = .T.
		This.Value = "            /  "
		This.Format = "R"
		This.InputMask = "999999999/99"

	PROCEDURE ButsCargar.Init
		THIS.SetAll("Height", 30, "CommandButton") 
		THIS.SetAll("Top", 12, "CommandButton") 
		THIS.Buttons(1).Caption = "Eliminar!"
		THIS.Buttons(2).Caption = "Cancelar"
		THIS.Buttons(3).Caption = "Salir"
		THIS.Buttons(1).Left = 25
		THIS.Buttons(2).Left = 175
		THIS.Buttons(3).Left = 325
		THIS.Buttons(2).Cancel = .T.
	ENDPROC

	PROCEDURE ButsCargar.Click()
		DO CASE
			CASE THIS.Value = 1
			
				IF 6 == MESSAGEBOX("ELIMINAR EL CONSORCIO SELECCIONADO?? ";
										,4 + 16 + 256,"Mensaje")
					
					
			
					SELECT CurCons
					SELECT Unidades
					
					LOCATE FOR nro_consor = CurCons.nro_consor
					
					IF FOUND()
						MESSAGEBOX("Aun existen unidades asociadas al consorcio seleccionado", 0 ,"Mensaje")
					ELSE
						SELECT CurCons
						DELETE 
						
						Thisform.refresh
						MESSAGEBOX("Consorcio eliminado con éxito")
					ENDIF
				ENDIF
			
			CASE THIS.Value = 2		
				IF 6==MESSAGEBOX("Cancelar los cambios efectuados?", ;
						4 + 32 + 256, Thisform.Caption)
					
					SELECT CurCons
					RECALL ALL
					Thisform.refresh
					
				ENDIF
						
						
			CASE THIS.Value = 3
		
*		set step on		
				SELECT CurCons
				GO TOP
				SELECT Consorcios
				SET ORDER TO nro_consor
				SET DELETE OFF
				DO WHILE !EOF("CurCons")
					IF DELETED("CurCons")
						SEEK CurCons.nro_consor
						DELETE
					ENDIF
					SKIP IN CurCons
				ENDDO
				SET DELETE ON
			
				THISFORM.Release
		ENDCASE
	ENDPROC

	
	PROCEDURE Init
	
		Thisform.NroCons.ControlSource = "CurCons.nro_consor"
		Thisform.NombreCons.ControlSource = "CurCons.nombre"
		Thisform.DireccCons.ControlSource = "CurCons.direccion"
		Thisform.SuperfCons.ControlSource = "CurCons.superficie"
		Thisform.NroUnidades.ControlSource = "CurCons.unidades"
		Thisform.TxBxCta_Cte.ControlSource = "CurCons.cta_cte"
		Thisform.TxBxInteresXdia.ControlSource = "CurCons.intereses"
		
		SELECT CurCons
		GO TOP
		IF CurCons.atraz = 'S'
			Thisform.chkCobra_Atraz.Value = .T.
		ELSE
			Thisform.chkCobra_Atraz.Value = .F.
		ENDIF
		
		DO CASE 
			CASE ALLTRIM(CurCons.adminis) = "Monto Fijo"
				Thisform.CmbBxTipoAdminis.Selected(2) = .T.
			CASE ALLTRIM(CurCons.adminis) = "Presupuestado"
				Thisform.CmbBxTipoAdminis.Selected(3) = .T.
			CASE ALLTRIM(CurCons.adminis) = "Sobre lo gastado"
				Thisform.CmbBxTipoAdminis.Selected(1) = .T.
		ENDCASE
				
		Thisform.NroCons.Enabled = .F.
		Thisform.NombreCons.Enabled = .F.
		Thisform.DireccCons.Enabled = .F.
		Thisform.SuperfCons.Enabled = .F.
		Thisform.NroUnidades.Enabled = .F.
		Thisform.TxBxCta_Cte.Enabled = .F.
		Thisform.TxBxInteresXdia.Enabled = .F.
		Thisform.oCmbBxCiudades.Enabled = .F.
		Thisform.oCmbBxBarrios.Enabled = .F.
		Thisform.CmbBxTipoAdminis.Enabled = .F.
		Thisform.chkCobra_Atraz.Enabled = .F.
		Thisform.CmbBxBancos.Enabled = .F.
		Thisform.CmbBxSucursales.Enabled = .F.

*		Thisform.ogrdModCons.Column1.Text1.setfocus
	
	ENDPROC
	
	PROCEDURE Load
	
		IF !USED("Unidades")
			USE Unidades
		ENDIF
		
		
		CREATE CURSOR Bancos2 ( cod_banco N(4), nombre c(30))

		select Bancos.cod_banco, Bancos.nombre ;
			FROM Bancos ;
			INTO ARRAY m_bancos

		SELECT Bancos2
		APPEND FROM	ARRAY m_bancos

		INSERT INTO Bancos2 (cod_banco, nombre) VALUES (0, "            ")	

		SELECT max(Sucursales.cod_banco) FROM Sucursales INTO ARRAY m_mban

		CREATE CURSOR Sucursales2 ( cod_banco N(3), nro_suc N(2), ;
				direccion c(30))

		select Sucursales.cod_banco, Sucursales.nro_suc, ;
				Sucursales.direccion ;
			FROM Sucursales ;
			INTO ARRAY m_sucursales

		SELECT Sucursales2
		APPEND FROM	ARRAY m_sucursales

		FOR i = 0 TO m_mban(1)
			INSERT INTO Sucursales2 (cod_banco, nro_suc, direccion) ;
				VALUES (i, 0, "              ")	
		ENDFOR


		SELECT MAX(Tipo_administracion.vigencia) ;
			FROM Tipo_administracion ;
			GROUP BY Tipo_administracion.nro_consor	;
			INTO ARRAY vigmax

		CREATE CURSOR CurCons (nro_consor N(3), nombre C(30), ;
			direccion C(30), superficie N(7,2), unidades N(3), ;
			ciudad C(30), barrio C(30), banco C(30), ;
			sucursal C(30), cta_cte C(30), adminis C(20), ;
			intereses N(5,2), atraz C(1))

		
		SELECT Consorcios.nro_consor, Consorcios.nombre, ;
				Consorcios.direccion, Consorcios.superficie, ;
				Consorcios.unidades, Ciudades.nom_ciudad, ;
				Barrios.descripcion, Bancos2.nombre, ;
				Sucursales2.direccion, Consorcios.cta_cte, ;
				Administracion.descripcion, ;
				Tipo_administracion.intereses, ;
				Tipo_administracion.cobra_atraz ;
			FROM Consorcios, Ciudades, Barrios, Bancos2, Sucursales2, ;
				Administracion, Tipo_administracion;
			WHERE Consorcios.cod_loc = Ciudades.cod_loc .AND. ;
				Consorcios.cod_barrio = Barrios.cod_barrio .AND. ;
				Consorcios.cod_banco = Bancos2.cod_banco .AND.	;
				Bancos2.cod_banco = Sucursales2.cod_banco .AND. ;
				Consorcios.nro_suc = Sucursales2.nro_suc .AND. ;
				Tipo_administracion.adm_tipo = Administracion.adm_tipo .AND. ;
				Consorcios.nro_consor = Tipo_Administracion.nro_consor .AND. ;	
				Tipo_administracion.vigencia = vigmax(Consorcios.nro_consor,1) ;
			ORDER BY 1 ;
			INTO ARRAY m_CurCons
		SELECT CurCons
		APPEND FROM ARRAY m_CurCons

	ENDPROC
ENDDEFINE


************ PROCEDIMIENTOS   ********************************
