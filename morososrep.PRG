LPARAMETERS imprime, consor, nomcon
*imprime = 1
*consor = 0
** Si imprime 1, si no 0 que visualiza; 
** Para todos los consorcios consor a 0, cualquier otro ;
*		especificando el consorcio
* nomcons es el nombre del consorcio

IF TYPE("imprime") = 'L'
	imprime = 0
ENDIF
IF TYPE("consor") = 'L'
	consor = 4
ENDIF

nomcons = nomcon
IF TYPE("nomcons") = 'L'
	nomcons = "GALERIA ARGENTINA"
ENDIF

DEFINE WINDOW ventana FROM 0,0 TO 790,490 ;
	IN SCREEN NAME ventana ;
	TITLE "Vista Previa del Informe";
	HALFHEIGHT CLOSE FLOAT GROW ZOOM ;
	ICON FILE Aromal.ico


ofrmReportPreview = CREATEOBJECT("frmReportPreview", imprime, consor)
IF TYPE("ofrmReportPreview") = 'O'
	ofrmReportPreview.Show()
ENDIF

DEFINE CLASS frmReportPreview AS Form
	Icon = "Aromal.ico"
	BackColor = RGB(255, 255, 255)
	Caption = "Vista Previa del Informe"
	Height = 490
	Width = 790
	Top = 0
	Left = 0
	ScaleMode = 3
	ShowWindow = 1
	WindowType = 1
	Visible = .T.
	ScrollBars = 3
	Visible = .F.
	Imprime = 0
	Consor = 0

	PROCEDURE Init
	LPARAMETERS imp, con
	
		This.Imprime = imp
		This.Consor = con
		SET SAFETY OFF
		
		SELECT ConsOk.cod AS Cod, ;
				ConsOk.nombre AS Nombre, ;
				ConsOk.tipo_doc AS Tipo_doc, ;
				ConsOk.nro_doc AS Nro_doc, ;
				ConsOk.direccion AS Direccion, ;
				ConsOk.telefono AS Telefono, ;
				ConsOk.unidad AS Unidad, ;
				ConsOk.piso AS Piso, ;
				ConsOk.depto AS Depto, ;
				ConsOk.Anio AS Anio, ;
				ConsOk.mes AS Mes, ;
				ConsOk.suma AS Monto ;
			FROM ConsOk ;
			WHERE ConsOk.nro_consor = This.Consor ;
			ORDER BY 2, 7, 10, 11 ;
			INTO TABLE Moro

		SELECT Moro
		INDEX ON Cod TAG Cod
		REINDEX
		
*		SET SAFETY ON
		
		IF This.Imprime = 1
			IF 1==MESSAGEBOX("Haz click en Aceptar cuando estés listo...", ;
					1 + 32 + 256, "Mensaje")
			
				IF This.Consor = 0
					REPORT FORM morosostot NOCONSOLE NOWAIT ;
						TO PRINTER PROMPT
				ELSE
					REPORT FORM morososcons NOCONSOLE NOWAIT ;
						TO PRINTER PROMPT
				ENDIF
				
			ENDIF
			RETURN .F.	
		ENDIF
	ENDPROC
	
	PROCEDURE Activate
		*Para previsualizar

		c = ""
		IF !(_VFP.version = "6.0")
*			c = "NOCONSOLE PREVIEW WINDOW ventana"
			c = "NOCONSOLE PREVIEW"
		ELSE
			This.AddObject("olabel","Label") 
			This.olabel.Left = 670
			This.olabel.Top = 1100
			This.olabel.Caption = "Hasta Aca quiero que llegue el scroll :-)"
			This.olabel.Visible = .T.
		ENDIF

		IF This.Consor = 0
			SELECT Consmor
			IF reccount() = 0 
				MESSAGEBOX("No existen propietarios en calidad de morosos", 0, "Mensaje")
				Thisform.release
				RETURN .F.
			ENDIF
		
			REPORT FORM morosostot &c
		ELSE
			SELECT Moro
			IF reccount() = 0 
				MESSAGEBOX("No existen propietarios en calidad de morosos", 0, "Mensaje")
				Thisform.release
				RETURN .F.
			ENDIF
			REPORT FORM morososcons &c
		ENDIF
		IF !(_VFP.version = "6.0")
			Thisform.release
		ENDIF
	ENDPROC
	
	PROCEDURE Load
		IF USED("Consmor")
			SELECT Consmor
		ELSE
			USE Consmor IN 0
			SELECT Consmor
		ENDIF
		SET ORDER TO 1
	
*		IF USED("Moro")
*			SELECT Moro
*		ELSE
*			USE Moro IN 0
*			SELECT Moro
*		ENDIF
*		SET ORDER TO 1
	ENDPROC
	
	PROCEDURE Destroy
		Thisform.Release
	ENDPROC
ENDDEFINE
