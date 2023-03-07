clear program
ofrm = CREATEOBJECT("frm")
ofrm.Show
clear program


********************** Definiciones de Clases ************************
DEFINE CLASS hea AS Header
	Caption = "Caption aquí"
	Alignment = 2
	Ascendent = .F.
	Tag = '0'
	
	PROCEDURE Click
		IF This.Ascendent = .F.
			SET ORDER TO VAL(This.Tag) IN tablamor ASCENDING
			This.Ascendent = .T.
		ELSE
			SET ORDER TO VAL(This.Tag) IN tablamor DESCENDING
			This.Ascendent = .F.
		ENDIF
		GO TOP IN tablamor
		Thisform.refresh
	ENDPROC
ENDDEFINE


DEFINE CLASS grd AS Grid 
	Left = 30
	Top = 130
	ColumnCount = 5
	Height = 190
	Width = 630
	ReadOnly = .T.
	Enabled = .T.
	RecordSourceType = 0
	RecordSource = "tablamor"
	DeleteMark = .F.
	RecordMark = .F.
	Partition = 0
	SplitBar = .F.
	ScrollBars = 2
	TabStop = .F.
	
ENDDEFINE

DEFINE CLASS opgprop AS OptionGroup
	ButtonCount = 2
	Top = 7
	Left = 480
	Height = 75
	Width = 250
	Tabstop = .F.
	BorderStyle = 0
	AutoSize = .T.
	
	PROCEDURE Init
		This.Buttons(1).Name = "obtnprop"
		This.Buttons(2).Name = "obtnuni"
		This.obtnprop.Caption = "Por propietario"
		This.obtnuni.Caption = "Propietario por Consorcio"
		This.obtnprop.Width = 100
		This.obtnuni.Width = 170
		PUBLIC lcons_all
		lcons_all = .T.
	ENDPROC

	PROCEDURE Click
		DO CASE         
			CASE This.Value = 1
				IF lcons_all
					SELECT Propietarios.cod_prorio AS Cod, ;
								(ALLTRIM(Propietarios.apellido) + ",  " ;
								+ ALLTRIM(Propietarios.nombre)) AS Nombre, ;
							COUNT(DISTINCT Unidades.nro_consor) AS Unidades, ;
							COUNT(Expensas.mes) AS expensas, SUM(Expensas.monto_paga) AS suma ;
						FROM Propietarios, Unidades, Expensas ;
						WHERE Unidades.cod_prorio = Propietarios.cod_prorio ;
							.AND. Expensas.nro_unidad = Unidades.nro_unidad ;
							.AND. Expensas.nro_consor = Unidades.nro_consor ;
							.AND. Expensas.Abonado = .F. ;
						GROUP BY Propietarios.cod_prorio ;
						ORDER BY 2 ;
						INTO TABLE tablamor


					INDEX ON cod TAG cod
					INDEX ON nombre TAG nombre
					INDEX ON unidades TAG unidades
					INDEX ON expensas TAG expensas
					INDEX ON suma TAG suma
					REINDEX
					
					SET ORDER TO nombre In tablamor
					GO TOP IN tablamor

					Thisform.ogrd.RecordSource = "tablamor"

					Thisform.ogrd.Column1.AddObject("ohea1", "hea")
					Thisform.ogrd.Column1.ohea1.Tag = "1"
					Thisform.ogrd.Column2.AddObject("ohea2", "hea")
					Thisform.ogrd.Column2.ohea2.Tag = "2"
					Thisform.ogrd.Column3.AddObject("ohea3", "hea")
					Thisform.ogrd.Column3.ohea3.Tag = "3"
					Thisform.ogrd.Column4.AddObject("ohea4", "hea")
					Thisform.ogrd.Column4.ohea4.Tag = "4"
					Thisform.ogrd.Column5.AddObject("ohea5", "hea")
					Thisform.ogrd.Column5.ohea5.Tag = "5"

					Thisform.ogrd.Column1.ohea1.Caption = "Cod."
					Thisform.ogrd.Column2.ohea2.Caption = "Propietario"
					Thisform.ogrd.Column3.ohea3.Caption = "Consorcios"
					Thisform.ogrd.Column4.ohea4.Caption = "Exp. adeudadas"
					Thisform.ogrd.Column5.ohea5.Caption = "Monto total"
	
					Thisform.ogrd.Column1.ReadOnly = .T.
					Thisform.ogrd.Column2.ReadOnly = .T.
					Thisform.ogrd.Column3.ReadOnly = .T.
					Thisform.ogrd.Column4.ReadOnly = .T.
					Thisform.ogrd.Column5.ReadOnly = .T.

					Thisform.ogrd.Column1.Width = 40
					Thisform.ogrd.Column2.Width = 150
					Thisform.ogrd.Column3.Width = 90
					Thisform.ogrd.Column4.Width = 120
					Thisform.ogrd.Column5.Width = 90
					
					DIMENSION ar(1)
					ar(1) = 0.00
					DIMENSION ar2(1)
					ar2(1) = 0.00
					SELECT SUM(tablamor.expensas) FROM tablamor INTO ARRAY ar
					SELECT SUM(tablamor.suma) FROM tablamor INTO ARRAY ar2
					Thisform.olabl.Left = 250
					Thisform.olabl.Caption = "Totales         " + STR(ar) + ;
						"  expensas      " + STR(ar2, 10,2) + "   pesos"
					
				ELSE
					Thisform.ocmbconsorcio.InteractiveChange()
				ENDIF
			CASE This.Value = 2 
				IF lcons_all
					SELECT Propietarios.cod_prorio AS Cod, ;
								(ALLTRIM(Propietarios.apellido) + ",  " ;
								+ ALLTRIM(Propietarios.nombre)) AS Nombre, ;
							Consorcios.nombre AS Consorcios, ;
							COUNT (Expensas.mes) AS expensas, SUM(Expensas.monto_paga) AS suma ;
						FROM Propietarios, Unidades, Expensas, Consorcios ;
						WHERE Propietarios.cod_prorio = Unidades.cod_prorio ;
							.AND. Unidades.nro_consor = Consorcios.nro_consor ;
							.AND. Unidades.nro_unidad = Expensas.nro_unidad ;
							.AND. Expensas.nro_consor = Unidades.nro_consor ;
							.AND. Expensas.Abonado = .F. ;
						GROUP BY Consorcios.nro_consor ,Propietarios.cod_prorio ;
						ORDER BY 2 ;
						INTO TABLE tablamor
			

					INDEX ON cod TAG cod
					INDEX ON nombre TAG nombre
					INDEX ON consorcios TAG consorcios
					INDEX ON expensas TAG expensas
					INDEX ON suma TAG suma
					REINDEX
					
					SET ORDER TO nombre In tablamor
					GO TOP IN tablamor

					Thisform.ogrd.RecordSource = "tablamor"
					Thisform.ogrd.Column1.AddObject("ohea1", "hea")
					Thisform.ogrd.Column1.ohea1.Tag = "1"
					Thisform.ogrd.Column2.AddObject("ohea2", "hea")
					Thisform.ogrd.Column2.ohea2.Tag = "2"
					Thisform.ogrd.Column3.AddObject("ohea3", "hea")
					Thisform.ogrd.Column3.ohea3.Tag = "3"
					Thisform.ogrd.Column4.AddObject("ohea4", "hea")
					Thisform.ogrd.Column4.ohea4.Tag = "4"
					Thisform.ogrd.Column5.AddObject("ohea5", "hea")
					Thisform.ogrd.Column5.ohea5.Tag = "5"

					Thisform.ogrd.Column1.Width = 40
					Thisform.ogrd.Column2.Width = 150
					Thisform.ogrd.Column3.Width = 190
					Thisform.ogrd.Column4.Width = 120
					Thisform.ogrd.Column5.Width = 90

					Thisform.ogrd.Column1.ohea1.Caption = "Cod."
					Thisform.ogrd.Column2.ohea2.Caption = "Propietario"
					Thisform.ogrd.Column3.ohea3.Caption = "Consorcio"
					Thisform.ogrd.Column4.ohea4.Caption = "Exp. adeudadas"
					Thisform.ogrd.Column5.ohea5.Caption = "Monto total"
					
					DIMENSION ar(1)
					ar(1) = 0.00
					DIMENSION ar2(1)
					ar2(1) = 0.00
					SELECT SUM(tablamor.expensas) FROM tablamor INTO ARRAY ar
					SELECT SUM(tablamor.suma) FROM tablamor INTO ARRAY ar2
					Thisform.olabl.Left = 355
					Thisform.olabl.Caption = "Totales         " + STR(ar) + ;
						"  expensas      " + STR(ar2,10,2) + "   pesos"
					
					
				ELSE
					IF Tipo_Administracion.cobra_atraz == 'N'
						SELECT Propietarios.cod_prorio AS Cod, ;
									(ALLTRIM(Propietarios.apellido) + ",  " ;
									+ ALLTRIM(Propietarios.nombre)) AS Nombre, ;
								Unidades.nro_unidad AS Unidades, ;
								Unidades.piso AS Piso, ;
								Unidades.departamento AS Depto, ;
								COUNT(Expensas.mes) AS Cant_meses, ;
								SUM(Expensas.monto_paga) AS Max_paga;
							FROM Propietarios, Unidades, Expensas ;
							WHERE Unidades.cod_prorio = Propietarios.cod_prorio ;
								.AND. Unidades.nro_consor = Consorcios.nro_consor ;
								.AND. Expensas.nro_consor = Consorcios.nro_consor ;
								.AND. Expensas.nro_unidad = Unidades.nro_unidad ;
								.AND. Expensas.Abonado = .F.;
							GROUP BY Unidades.nro_unidad ;
							ORDER BY 2 ;
							INTO TABLE tablamor
							Thisform.olabl.Left = 240
							
					ELSE
						SELECT Propietarios.cod_prorio AS Cod, ;
									(ALLTRIM(Propietarios.apellido) + ",  " ;
									+ ALLTRIM(Propietarios.nombre)) AS Nombre, ;
								Unidades.nro_unidad AS Unidades, ;
								Unidades.piso AS Piso, ;
								Unidades.departamento AS Depto, ;
								COUNT(Expensas.mes) AS Cant_meses, ;
								MAX(Expensas.monto_paga) AS Max_paga;
							FROM Propietarios, Unidades, Expensas ;
							WHERE Unidades.cod_prorio = Propietarios.cod_prorio ;
								.AND. Unidades.nro_consor = Consorcios.nro_consor ;
								.AND. Expensas.nro_consor = Consorcios.nro_consor ;
								.AND. Expensas.nro_unidad = Unidades.nro_unidad ;
								.AND. Expensas.Abonado = .F.;
							GROUP BY Unidades.nro_unidad ;
							ORDER BY 2 ;
							INTO TABLE tablamor
				
						Thisform.olabl.Left = 370
					ENDIF
				
					INDEX ON cod TAG cod
					INDEX ON nombre TAG nombre
					INDEX ON unidades TAG unidades
					INDEX ON piso TAG piso
					INDEX ON depto TAG depto
					INDEX ON cant_meses TAG cant_meses
					INDEX ON max_paga TAG max_paga
					REINDEX
					
					SET ORDER TO nombre In tablamor
					GO TOP IN tablamor
										
					Thisform.ogrd.RecordSource = "tablamor"

					Thisform.ogrd.Column1.AddObject("ohea1", "hea")
					Thisform.ogrd.Column1.ohea1.Tag = "1"
					Thisform.ogrd.Column2.AddObject("ohea2", "hea")
					Thisform.ogrd.Column2.ohea2.Tag = "2"
					Thisform.ogrd.Column3.AddObject("ohea3", "hea")
					Thisform.ogrd.Column3.ohea3.Tag = "3"
					Thisform.ogrd.Column4.AddObject("ohea4", "hea")
					Thisform.ogrd.Column4.ohea4.Tag = "4"
					Thisform.ogrd.Column5.AddObject("ohea5", "hea")
					Thisform.ogrd.Column5.ohea5.Tag = "5"
					Thisform.ogrd.Column6.AddObject("ohea6", "hea")
					Thisform.ogrd.Column6.ohea6.Tag = "6"
					Thisform.ogrd.Column7.AddObject("ohea7", "hea")
					Thisform.ogrd.Column7.ohea7.Tag = "7"

					Thisform.ogrd.Column1.Width = 40
					Thisform.ogrd.Column2.Width = 150
					Thisform.ogrd.Column3.Width = 50
					Thisform.ogrd.Column4.Width = 50
					Thisform.ogrd.Column5.Width = 60
					Thisform.ogrd.Column6.Width = 120
					Thisform.ogrd.Column7.Width = 120

					Thisform.ogrd.Column1.ohea1.Caption = "Cod."
					Thisform.ogrd.Column2.ohea2.Caption = "Propietario"
					Thisform.ogrd.Column3.ohea3.Caption = "Unidad"
					Thisform.ogrd.Column4.ohea4.Caption = "Piso"
					Thisform.ogrd.Column5.ohea5.Caption = "Depto"
					Thisform.ogrd.Column6.ohea6.Caption = "Exp. adeudadas"
					Thisform.ogrd.Column7.ohea7.Caption = "Monto total"
					
				ENDIF
		ENDCASE
ENDDEFINE


DEFINE CLASS frm AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192, 192, 192)
	Caption = " Consulta Morosos"
	Height = 430
	Width = 670
	Top = 5
	Left = 75
	ScaleMode = 3
	WindowType = 1
	ShowWindow = 1
	Visible = .T.
	Closable = .T.
	
	ADD OBJECT olabl AS Label ;
	WITH Caption = "Prueba", ;
		AutoSize = .T., ;
		FontItalic = .T., ;
		Top = 335, ;
		Left = 290

	ADD OBJECT lbl AS Label ;
	WITH Caption = "Consorcio", ;
		AutoSize = .T., ;
		FontBold = .T., ;
		Top = 15, ;
		Left = 200

	ADD OBJECT olblunidad AS Label ;
	WITH Caption = "Unidad :", ;
		AutoSize = .T., ;
		Top = 60, ;
		Left = 40, ;
		Visible = .F.
		
	ADD OBJECT ocmbconsorcio AS ComboBox ;
	WITH Left = 290, ;
		Style = 2, ;
		Top = 11, ;
		SelectOnEntry = .T., ;
		Width = 145, ; 
		RowSourceType = 6, ;
		RowSource = "Consorcios.nombre", ;
		Visible = .T.

	ADD OBJECT otxbprop AS TextBox ;
	WITH Left = 210, ;
		Top = 57, ;
		Width = 175, ;
		Height = 25, ;
		TabStop = .F., ;
		ReadOnly = .T., ;
		Visible = .F.

	ADD OBJECT ochkprop AS CheckBox ;
	WITH Caption = "Por En Venc.", ;
		Top = 57, ;
		Left = 590, ;
		Value = .T., ;
		Visible = .F., ;
		Tabstop = .F.

	ADD OBJECT oopgprop AS opgprop 

	ADD OBJECT ogrd AS grd ;
	WITH Visible = .T.
	
	ADD OBJECT ocmdImprimir AS CommandButton ;
	WITH Top = 380, ;
		Left = 50, ;
		Width = 87, ;
		Height = 27, ;
		Enabled = .T., ;
		Default = .T., ;
		Caption = "Imprimir"

	ADD OBJECT ocmdGraficar AS CommandButton ;
	WITH Top = 380, ;
		Left = 170, ;
		Width = 87, ;
		Height = 27, ;
		Enabled = .T., ;
		Caption = "Graficar"

	ADD OBJECT cmdSalir AS CommandButton ;
	WITH Top = 380, ;
		Left = 400, ;
		Width = 87, ;
		Height = 27, ;
		Cancel = .T., ;
		Caption = "Salir"

	ADD OBJECT cmdAyuda AS CommandButton ;
	WITH Top = 380, ;
		Left = 515, ;
		Width = 87, ;
		Height = 27, ;
		Caption = "Ayuda"

	ADD OBJECT cmdVista AS CommandButton ;
	WITH Top = 380, ;
		Left = 285, ;
		Width = 87, ;
		Height = 27, ;
		Caption = "Vista Previa"

	PROCEDURE cmdVista.Click
		IF lcons_all
			Morososrep(0,0)
		ELSE
*			MESSAGEBOX(STR(Consorcios.nro_consor))
			Morososrep(0, Consorcios.nro_consor, Consorcios.nombre)
		ENDIF
	ENDPROC

	PROCEDURE ocmdGraficar.Click
		IF lcons_all
			Morososole(0)
		ELSE
			Morososole(Consorcios.nro_consor, Consorcios.nombre)
		ENDIF
	ENDPROC

	PROCEDURE ocmdImprimir.Click
		IF lcons_all
			Morososrep(1,0)
		ELSE
			Morososrep(1, Consorcios.nro_consor, Consorcios.nombre)
		ENDIF

	PROCEDURE Load

		SET SAFETY OFF

		IF !USED("Expensas")
			USE Expensas IN 0 EXCLUSIVE
		ELSE
			SELECT Expensas
		ENDIF

		IF !USED("Consorcios")
			USE Consorcios IN 0 EXCLUSIVE
		ELSE
			SELECT Consorcios
		ENDIF
	
		IF !USED("Propietarios")
			USE Propietarios IN 0 EXCLUSIVE
		ELSE
			SELECT Propietarios
		ENDIF

		IF !USED("Unidades")
			USE Unidades IN 0 EXCLUSIVE
		ELSE
			SELECT Unidades
		ENDIF

		IF !USED("Tipo_Administracion")
			USE Tipo_Administracion IN 0 EXCLUSIVE
		ELSE
			SELECT Tipo_Administracion
		ENDIF
		
		
		* Tablas necesarias para las vistas previa, impresión y graficar
		Consultamor()

	PROCEDURE Init
		Thisform.oopgprop.Click
	ENDPROC
	
*	PROCEDURE DblClick
*		Thisform.oopgprop.Value = 3 - Thisform.oopgprop.Value  
*	ENDPROC
	
	PROCEDURE Destroy
		CLOSE TABLES ALL
		SET SAFETY ON
	ENDPROC

	PROCEDURE cmdSalir.Click
		Release Thisform
	ENDPROC
	
	PROCEDURE Click
		
	ENDPROC

	PROCEDURE ocmbconsorcio.InteractiveChange
		
		IF lcons_all
			Thisform.oopgprop.obtnuni.Caption = "Unidades por Propietario"
			lcons_all = .F.
		ENDIF

		Thisform.oopgprop.Value = 1
		
		SELECT Tipo_Administracion
		SET ORDER TO Primario
		SET FILTER TO nro_consor = Consorcios.nro_consor
		CALCULATE MAX(vigencia) TO maxx
		LOCATE FOR vigencia = maxx
	
		IF .NOT. FOUND()
			MESSAGEBOX("	Error ", 0, "Mensaje del sistema")
			Thisform.SetAll("Enabled", .F.)
			Thisform.cmdSalir.Enabled = .T.			
			RETURN
		ENDIF

		IF Tipo_Administracion.cobra_atraz == 'N'
			@5,20 SAY 'NO Actualiza la deuda    '
			SELECT Propietarios.cod_prorio AS Cod, ;
						(ALLTRIM(Propietarios.apellido) + ",  " ;
						+ ALLTRIM(Propietarios.nombre)) AS Nombre, ;
					COUNT(DISTINCT Unidades.nro_unidad) AS Unidades, ;
					COUNT(Expensas.mes) AS Expensas, SUM(Expensas.monto_paga) AS suma ;
				FROM Propietarios, Unidades, Expensas ;
				WHERE Unidades.cod_prorio = Propietarios.cod_prorio ;
					.AND. Unidades.nro_consor = Consorcios.nro_consor ;
					.AND. Expensas.nro_consor = Consorcios.nro_consor ;
					.AND. Expensas.nro_unidad = Unidades.nro_unidad ;
					.AND. Expensas.Abonado = .F. ;
				GROUP BY Propietarios.cod_prorio ;
				ORDER BY 2 ;
				INTO TABLE tablamor

				
		ELSE
			@5,20 SAY 'Actualiza la deuda           '

			SELECT Propietarios.cod_prorio AS Cod, ;
						(ALLTRIM(Propietarios.apellido) + ",  " ;
						+ ALLTRIM(Propietarios.nombre)) AS Nombre, ;
					COUNT (DISTINCT Unidades.nro_unidad) AS Unidades, ;
					COUNT(Expensas.mes) AS Cant_meses, ;
					MAX(Expensas.monto_paga) AS Max_paga;
				FROM Propietarios, Unidades, Expensas ;
				WHERE Unidades.cod_prorio = Propietarios.cod_prorio ;
					.AND. Unidades.nro_consor = Consorcios.nro_consor ;
					.AND. Expensas.nro_consor = Consorcios.nro_consor ;
					.AND. Expensas.nro_unidad = Unidades.nro_unidad ;
					.AND. Expensas.Abonado = .F.;
				GROUP BY Unidades.nro_unidad ;
				INTO TABLE tablatemp
			SELECT Cod AS Cod, Nombre AS Nombre, COUNT(Unidades) AS Unidades, SUM(Cant_meses) AS expensas, SUM(Max_paga) AS suma;
				FROM tablatemp ;
				GROUP BY Cod ;
				ORDER BY 2 ;
				INTO TABLE tablamor
				
				
		ENDIF

		SELECT tablamor
		INDEX ON cod TAG cod
		INDEX ON nombre TAG nombre
		INDEX ON unidades TAG unidades
		INDEX ON expensas TAG expensas
		INDEX ON suma TAG suma
		REINDEX
			
		SET ORDER TO nombre IN tablamor
		GO TOP IN tablamor
										
		Thisform.ogrd.RecordSource = "tablamor"

		Thisform.ogrd.Column1.AddObject("ohea1", "hea")
		Thisform.ogrd.Column1.ohea1.Tag = "1"
		Thisform.ogrd.Column2.AddObject("ohea2", "hea")
		Thisform.ogrd.Column2.ohea2.Tag = "2"
		Thisform.ogrd.Column3.AddObject("ohea3", "hea")
		Thisform.ogrd.Column3.ohea3.Tag = "3"
		Thisform.ogrd.Column4.AddObject("ohea4", "hea")
		Thisform.ogrd.Column4.ohea4.Tag = "4"
		Thisform.ogrd.Column5.AddObject("ohea5", "hea")
		Thisform.ogrd.Column5.ohea5.Tag = "5"

		Thisform.ogrd.Column1.Width = 40
		Thisform.ogrd.Column2.Width = 150
		Thisform.ogrd.Column3.Width = 100
		Thisform.ogrd.Column4.Width = 110
		Thisform.ogrd.Column5.Width = 90

		Thisform.ogrd.Column1.ohea1.Caption = "Cod."
		Thisform.ogrd.Column2.ohea2.Caption = "Propietario"
		Thisform.ogrd.Column3.ohea3.Caption = "Cant. unidades"
		Thisform.ogrd.Column4.ohea4.Caption = "Exp. adeudadas"
		Thisform.ogrd.Column5.ohea5.Caption = "Monto total"
		
		DIMENSION ar(1)
		ar(1) = 0.00		
		DIMENSION ar2(1)		
		ar2(1) = 0.00		
		SELECT SUM(tablamor.expensas) FROM tablamor INTO ARRAY ar
		SELECT SUM(tablamor.suma) FROM tablamor INTO ARRAY ar2
		Thisform.olabl.Caption = "Totales         " + STR(ar) + ;
				"  expensas      " + STR(ar2,10,2) + "   pesos"
					
							
		
ENDDEFINE