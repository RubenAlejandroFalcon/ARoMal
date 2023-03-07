LPARAMETERS ncons, cnomcons

#DEFINE ITEM "Registro"

#DEFINE SEGMENTADO 0
#DEFINE LISO 1
PUBLIC Logg
Logg = .T.

nncons = ncons
cnomconss = cnomcons

IF TYPE("nncons") = "L"
	nncons = 1
ENDIF
IF TYPE("cnomconss") = "L"
	cnomconss = "SAN CRISTOBAL"
ENDIF


#DEFINE CRLF	CHR(13)+CHR(10)
#DEFINE TAB 	CHR(9)

#DEFINE bartype	-4099
#DEFINE coltype	-4100
#DEFINE pietype	-4102

#DEFINE xlCategory 1
#DEFINE xlValue 2

*ON ERROR Wait Window "Error OLe"

PUBLIC Actualizar
Actualizar = .T.

ofrmPruebaOLE = CREATEOBJECT("frmPruebaOLE")
ofrmPruebaOLE.Show()

DEFINE CLASS frmPruebaOLE AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(192,192,192)
	Caption = "Gráfico Estadístico"
*	Height = 420
*	Width = 600
	Height = 110
	Width = 356
	Top = 5
	Left = 5
	ScaleMode = 3
	ShowWindow = 1
	WindowType = 1
	Visible = .T.
	HalfHeightCaption = .T.
	AlwaysOnTop = .T.
	KeyPreview = .T.
*	ScrollBars = 3

	ADD OBJECT olblGeneric AS Label ;
	WITH Left = 30, ;
		Top = 12, ;
		AutoSize = .T., ;
		FontSize = 8, ;
		Caption = "Generando el gráfico...."
		 

	ADD OBJECT oopggraf AS OptionGroup ;
	WITH ButtonCount = 2, ;
		Top = 7, ;
		Left = 490, ;
		Height = 75, ;
		Width = 250, ;
		Tabstop = .F., ;
		BorderStyle = 0, ;
		AutoSize = .T.
	
	ADD OBJECT oobcMorosos AS OLEBoundControl ;
	WITH Left = 5, ;
		Top = 10, ;
		Height = 400, ;
		Width = 480, ;
		Sizable = .F., ;
		AutoActivate = 0, ;
		Visible = .F.
	
	ADD OBJECT oobcMorosos2 AS OLEBoundControl ;
	WITH Left = 5, ;
		Top = 10, ;
		Height = 400, ;
		Width = 480, ;
		Sizable = .F., ;
		AutoActivate = 0, ;
		Visible = .F.
	
	ADD OBJECT oobcMorosos3 AS OLEBoundControl ;
	WITH Left = 5, ;
		Top = 10, ;
		Height = 400, ;
		Width = 480, ;
		Sizable = .F., ;
		AutoActivate = 0, ;
		Visible = .F.

	ADD OBJECT olblTarea AS Label ;
	WITH Left = 30, ;
		Top = 30, ;
		AutoSize = .T., ;
		FontSize = 8, ;
		Caption = ""
		 
	ADD OBJECT oleProgressBar AS OLEControl ;
	WITH OLEClass = "MSComctlLib.ProgCtrl", ;
		Left = 29, ;
		Top = 62, ;
		Height = 25, ;
		Width = 290
	
	
	ADD OBJECT otxbPropObj AS TextBox ;
	WITH Top = 100, ;
		Left = 485, ;
		Width = 245, ;
		Height = 25, ;
		Enabled = .F., ;
		Visible = .F.
	
	PROCEDURE otxbPropObj.LostFocus
		IF !EMPTY(ALLTRIM(This.Value))
			c = This.Value
			Thisform.oobcMorosos.Object.&c
			Thisform.refresh
		ENDIF
	ENDPROC
			
	PROCEDURE oopggraf.Init
		This.Buttons(1).Name = "obtnexpensa"
		This.Buttons(2).Name = "obtnmonto"
		This.obtnexpensa.Caption = "Por Expensas"
		This.obtnmonto.Caption = "Por Monto"
		This.obtnexpensa.Width = 100
		This.obtnmonto.Width = 170
	ENDPROC
	

	PROCEDURE oopggraf.Click
		IF Logg
		
			Thisform.oleProgressBar.Object.Value = 8290
			DO WHILE Thisform.oleProgressBar.Object.Value < 10000
				Thisform.oleProgressBar.Object.Value = Thisform.oleProgressBar.Object.Value + 2
			ENDDO
			Thisform.oleProgressBar.Object.Value = 10000
			n = SECONDS()
			n = n + 0.5
			DO WHILE n > SECONDS()
			ENDDO
		
			Thisform.LockScreen = .T.
			Thisform.oleProgressBar.Visible = .F.
			Thisform.olblGeneric.Visible = .F.
			Thisform.olblTarea.Visible = .F.
		
			Thisform.Height = 420
			Thisform.Width = 600
			Logg = .F.
		ENDIF

		DO CASE         
			CASE This.Value = 1
				Thisform.oobcMorosos2.Visible = .F.
				Thisform.oobcMorosos.Visible = .T.
			CASE This.Value = 2
				Thisform.oobcMorosos.Visible = .F.
				Thisform.oobcMorosos2.Visible = .T.
		ENDCASE
		Thisform.refresh
		Thisform.LockScreen = .F.
	ENDPROC
	
	PROCEDURE Activate
*		This.Height = 110
*		This.Width = 356
		This.oleProgressBar.Object.Value = 0
		This.olblTarea.Caption = "Iniciando..."
		IF Actualizar
		This.oleProgressBar.Object.Value = 1
			IF nncons = 0			
				SELECT Curtemp
				This.oleProgressBar.Object.Value = 1
				lcData = " " + TAB + "" + CRLF
				This.oleProgressBar.Object.Value = 1
				This.olblTarea.Caption = "Actualizando los datos para las expensas..."
				SCAN
				 lcData = lcData + Consorcio
				 lcData = lcData + TAB
				 lcData = lcData + ALLTRIM(STR(Expensas)) + CRLF
				ENDSCAN
				
				This.oleProgressBar.Object.Value = 4
				SELECT TablaOLEMor
				This.oleProgressBar.Object.Value = 5
				GO TOP
				This.oleProgressBar.Object.Value = 5
				APPEND GENERAL gen1 class "msgraph.chart" DATA m.lcData
				This.oleProgressBar.Object.Value = 1777
				This.olblTarea.Caption = "Actualización de datos para expensas FINALIZADO..."
				SELECT Curtemp
				This.oleProgressBar.Object.Value = 1778
				lcData = " " + TAB + "" + CRLF
				This.oleProgressBar.Object.Value = 1778
				This.olblTarea.Caption = "Actualizando los datos para montos..."
				SCAN
				 lcData = lcData + Consorcio
				 lcData = lcData + TAB
				 lcData = lcData + ALLTRIM(STR(Suma)) + CRLF
				ENDSCAN
				This.oleProgressBar.Object.Value = 1781
				SELECT TablaOLEMor
				This.oleProgressBar.Object.Value = 1781
				APPEND GENERAL gen2 class "msgraph.chart" DATA m.lcData
				This.oleProgressBar.Object.Value = 2576
				This.olblTarea.Caption = "Actualizanción de datos para montos FINALIZADO..."
			ELSE
				SELECT CurTmp2ok
				This.oleProgressBar.Object.Value = 1
				lcData = " " + TAB + "" + CRLF
				This.oleProgressBar.Object.Value = 1
				This.olblTarea.Caption = "Actualizando los datos para las expensas..."
				SCAN
				 lcData = lcData + cmes
				 lcData = lcData + TAB
				 lcData = lcData + ALLTRIM(STR(Expensa)) + CRLF
				ENDSCAN
				This.oleProgressBar.Object.Value = 2
				SELECT TablaOLEMor
				This.oleProgressBar.Object.Value = 3
				GO TOP
				This.oleProgressBar.Object.Value = 4
				APPEND GENERAL gen1 class "msgraph.chart" DATA m.lcData
				This.oleProgressBar.Object.Value = 1777
				This.olblTarea.Caption = "Actualización de datos para expensas FINALIZADO..."
				SELECT CurTmp2ok
				This.oleProgressBar.Object.Value = 1778
				lcData = " " + TAB + "" + CRLF
				This.oleProgressBar.Object.Value = 1778
				This.olblTarea.Caption = "Actualizando los datos para montos..."
				SCAN
				 lcData = lcData + cmes
				 lcData = lcData + TAB
				 lcData = lcData + ALLTRIM(STR(Monto)) + CRLF
				ENDSCAN
				This.oleProgressBar.Object.Value = 1781
				SELECT TablaOLEMor
				This.oleProgressBar.Object.Value = 1781
				APPEND GENERAL gen2 class "msgraph.chart" DATA m.lcData
				This.oleProgressBar.Object.Value = 2576
				This.olblTarea.Caption = "Actualizanción de datos para montos FINALIZADO..."
			ENDIF
		ENDIF

		This.oobcMorosos.ControlSource = "TablaOLEMor.Gen1"
		This.oleProgressBar.Object.Value = 2693
		This.olblTarea.Caption = "Dando formato..."
		This.oobcMorosos.Object.ChartArea.Font.Name = "Times New Roman"
		This.oleProgressBar.Object.Value = 4395
		This.oobcMorosos.Object.ChartArea.Font.Size = 10
		This.oleProgressBar.Object.Value = 4491
		This.oobcMorosos.Object.ChartArea.Font.Bold = .F.
		This.oleProgressBar.Object.Value = 4596
		This.oobcMorosos.Object.HasLegend = .T.
		This.oleProgressBar.Object.Value = 4611
		This.oobcMorosos.Object.Legend.Font.Size = 8
		This.oleProgressBar.Object.Value = 4714
		This.oobcMorosos.Object.HasTitle = .T.
		This.oleProgressBar.Object.Value = 4792
		This.oobcMorosos.Object.ChartTitle.Font.Name = "Courier New"
		This.oleProgressBar.Object.Value = 4929
		This.oobcMorosos.Object.ChartTitle.Font.Size = 10
		This.oleProgressBar.Object.Value = 5025
		This.oobcMorosos.Object.ChartTitle.Font.Bold = .F.
		This.oleProgressBar.Object.Value = 5119
		This.oobcMorosos.Object.Axes(xlCategory).HasTitle = .T.
		This.oleProgressBar.Object.Value = 5248
		This.oobcMorosos.Object.Axes(xlValue).HasTitle = .T.
		This.oleProgressBar.Object.Value = 5353
		This.oobcMorosos.Object.AutoFormat(coltype,4)
		This.oleProgressBar.Object.Value = 5450
		Thisform.oobcMorosos2.ControlSource = "TablaOLEMor.Gen2"
		This.oleProgressBar.Object.Value = 5559
		This.oobcMorosos2.Object.ChartArea.Font.Name = "Times New Roman"
		This.oleProgressBar.Object.Value = 6719
		This.oobcMorosos2.Object.ChartArea.Font.Size = 10
		This.oleProgressBar.Object.Value = 6805
		This.oobcMorosos2.Object.ChartArea.Font.Bold = .F.
		This.oleProgressBar.Object.Value = 6890
		This.oobcMorosos2.Object.HasLegend = .T.
		This.oleProgressBar.Object.Value = 6897
		This.oobcMorosos2.Object.Legend.Font.Size = 8
		This.oleProgressBar.Object.Value = 6984
		This.oobcMorosos2.Object.HasTitle = .T.
		This.oleProgressBar.Object.Value = 7016
		This.oobcMorosos2.Object.ChartTitle.Font.Name = "Courier New"
		This.oleProgressBar.Object.Value = 7161
		This.oobcMorosos2.Object.ChartTitle.Font.Size = 10
		This.oleProgressBar.Object.Value = 7254
		This.oobcMorosos2.Object.ChartTitle.Font.Bold = .F.
		This.oleProgressBar.Object.Value = 7344
		This.oobcMorosos2.Object.Axes(xlCategory).HasTitle = .T.
		This.oleProgressBar.Object.Value = 7436
		This.oobcMorosos2.Object.Axes(xlValue).HasTitle = .T.
		This.oleProgressBar.Object.Value = 7436
		This.oobcMorosos2.Object.AutoFormat(coltype,4)
		This.oleProgressBar.Object.Value = 7536
		IF nncons = 0
			This.oobcMorosos.Object.ChartTitle.Text = "Comparativa sobre la cantidad de Expensas Adeudadas por Consorcio"
			This.oleProgressBar.Object.Value = 7573
			This.oobcMorosos.Object.Axes(xlCategory).AxisTitle.Caption = "Consorcios"
			This.oleProgressBar.Object.Value = 7727
			This.oobcMorosos.Object.Axes(xlValue).AxisTitle.Caption = "Cant.  Expensas"
			This.oleProgressBar.Object.Value = 7844
			Thisform.oobcMorosos2.Object.ChartTitle.Text = "Comparativa sobre el Monto de las Expensas por Consorcio"
			This.oleProgressBar.Object.Value = 7958
			This.oobcMorosos2.Object.Axes(xlCategory).AxisTitle.Caption = "Consorcios"
			This.oleProgressBar.Object.Value = 8062
			Thisform.oobcMorosos2.Object.Axes(xlValue).AxisTitle.Caption = "Monto  Expensas"
			This.oleProgressBar.Object.Value = 8178
			This.olblTarea.Caption = "Formato finalizado."
		ELSE
			This.oobcMorosos.Object.ChartTitle.Text = "Comparativa mensual sobre la cantidad de Expensas Adeudadas para el Consorcio     " + cnomconss
			This.oleProgressBar.Object.Value = 7573
			This.oobcMorosos.Object.Axes(xlCategory).AxisTitle.Caption = "Últimos 12 meses"
			This.oleProgressBar.Object.Value = 7727
			This.oobcMorosos.Object.Axes(xlValue).AxisTitle.Caption = "Cant.  Expensas"
			This.oleProgressBar.Object.Value = 7844
			Thisform.oobcMorosos2.Object.ChartTitle.Text = "Comparativa mensual sobre el Monto de las Expensas Adeudadas para el Consorcio     " + cnomconss
			This.oleProgressBar.Object.Value = 7958
			This.oobcMorosos2.Object.Axes(xlCategory).AxisTitle.Caption = "Últimos 12 meses"
			This.oleProgressBar.Object.Value = 8062
			Thisform.oobcMorosos2.Object.Axes(xlValue).AxisTitle.Caption = "Monto  Expensas"
			This.oleProgressBar.Object.Value = 8178
			This.olblTarea.Caption = "Formato finalizado..."
		ENDIF
		This.oleProgressBar.Object.Value = 8288
		Thisform.oopggraf.Click
	ENDPROC
	
	PROCEDURE Init
		This.oleProgressBar.Object.Scrolling = SEGMENTADO
		This.oleProgressBar.Object.Min = 0
		This.oleProgressBar.Object.Max = 10000
		This.oleProgressBar.Object.Value = 0
	ENDPROC

	PROCEDURE KeyPress
	LPARAMETERS nCod, nMay
		IF nCod = 27
			Thisform.release
		ENDIF
	ENDPROC


	
	PROCEDURE Load
		IF USED("Consorcios")
			SELECT Consorcios
		ELSE
			USE Consorcios
			SELECT Consorcios
		ENDIF
		
		IF USED("ConsMor")
			SELECT ConsMor
		ELSE
			USE ConsMor
			SELECT ConsMor
		ENDIF

		IF USED("TablaOLEMor")
			SELECT TablaOLEMor
		ELSE
			USE TablaOLEMor
			SELECT TablaOLEMor
		ENDIF
		
		IF USED("CurTmp2ok")
			USE IN CurTmp2ok
		ENDIF
		
		SET SAFETY OFF
		IF Actualizar
			IF nncons = 0

				SELECT Consmor.Consorcio AS Consorcio, ;
						SUM(ConsMor.Expensas) AS Expensas, ;
						SUM(ConsMor.Suma) AS Suma;
					FROM ConsMor ;
					GROUP BY ConsMor.nro_consor ;
					INTO CURSOR Curtemp

*set step on					
				SELECT Curtemp
				IF reccount() = 0 &&.AND. ALLTRIM(Curtemp.Consorcio) = ""
					USE IN Curtemp
					CREATE CURSOR Curtemp ( Consorcio C(30), ;
						Expensas N(16), Suma N(16,2))
					SELECT Consorcios
					nccon = nro_consor &&Guardamos la posicion
					SET ORDER TO nro_consor
					SCAN
						INSERT INTO Curtemp (Consorcio, Expensas, Suma) ;
							VALUES (Consorcios.nombre,0,0.00)
					ENDSCAN
					SEEK nro_consor
				ENDIF
											
			ELSE
				
				SELECT ConsOk.Anio AS Anio, ;
						ConsOk.Mes AS nMes, ;
						(CMONTH(CTOD("01/" + STR(ConsOk.mes) + ;
						"/" + STR(ConsOk.Anio)))) AS cMes, ;
						COUNT(ConsOk.Mes) AS Expensa, ;
						SUM(ConsOk.suma) AS Monto ;
					FROM ConsOk ;
					WHERE ConsOk.nro_consor = nncons ;
					GROUP BY ConsOk.Anio, ConsOk.Mes ;
					ORDER BY 1, 2 ;
					INTO CURSOR Curtemp2
					
				SELECT CurTemp2

				COPY STRUCTURE TO CurTmp2ok
				SELECT CurTemp2
				GO BOTTOM
				IF EOF()
					ai = YEAR(DATE()) - 1
					mi = MONTH(DATE()) + 1
				ELSE
					ai = anio - 1
					mi = nmes + 1
				ENDIF

				COUNT TO cantreg
				GO TOP
				IF cantreg > 12
					GO BOTTOM
					SKIP -11
				ENDIF

				FOR i = 1 TO 12
					IF mi = 13
						mi = 1
						ai = ai + 1
					ENDIF
	
					IF ((anio*100)+nmes) > ((ai*100)+mi) .OR. cantreg = 0
*					IF ((anio*100)+nmes) > ((ai*100)+mi)
						INSERT INTO CurTmp2ok (anio, nmes, cmes, expensa, monto);
							VALUES (ai,mi,(CMONTH(CTOD("01/"+STR(mi)+"/"+STR(anio)))),0,0)
					ELSE
						SCATTER MEMVAR
						INSERT INTO CurTmp2ok FROM MEMVAR
						SKIP
					ENDIF
					
					mi = mi + 1
				ENDFOR
				SELECT CurTmp2ok
			ENDIF
		ENDIF
		
	ENDPROC
	
	PROCEDURE Destroy
		Thisform.Release
	ENDPROC
ENDDEFINE
