*******************************************************************
*
*			NOMBRE  :	 Consorcio01.prg
*			GRUPO   :	 11 - Hab.Profesional - FRC - UTN
*			VERSIÓN :	 0.2 	
*
*******************************************************************
* Este programa tiene como objetivo iniciar y finalizar la 
* Aplicación Consorcios delegando responsabilidades en los
* correspondientes subprogramas
*
*******************************************************************


*CLOSE ALL
CLEAR ALL

********* SETEOS *************************************************

*SET STEP ON
SET TALK OFF
SET NOTIFY OFF
SET DELETE ON
SET DATE DMY
SET CENTURY ON


******** DEFINICIONES ******************************************** 


*************** MAIN ******************************************
CLEAR ALL
CLOSE DATABASES
OPEN DATABASE Aromal

USE Gastos_Detalle IN 0


PUBLIC gnSecurityLevel

gnSecurityLevel = 0


frmPaso = CREATEOBJECT("Pass")
frmPaso.Show()
*READ EVENTS



IF gnSecurityLevel != 0

	frmPrincipalConsorcio = CREATEOBJECT("cfrmPrincipalConsorcio")

	frmPrincipalConsorcio.Show(1)

	SET STATUS BAR OFF
	READ EVENTS
	
ENDIF

CLOSE TABLES ALL
CLEAR ALL
CLOSE DATABASES
*
********* DEFINICIONES DE CLASES ********************************



DEFINE CLASS Pass AS FORM
	ShowWindow = 1
	WindowType = 1
	AutoCenter = .T.
	AlwaysOnTop = .T.
	ControlBox = .F.
	SizeBox = .F.
	BorderStyle = 2
	ScaleMode = 3
	MaxButton = .F.
	MinButton = .F.
*	HalfHeightCaption = .T.
	Movable = .F.
	Caption = "Introduzca nombre de usuario y password"
*	Closable = .F.
	Width = 260
	Height = 115
	ADD OBJECT olblusuario AS LABEL ;
		WITH Caption = "Usuario:", ;
		Left = 15, ;
		Top = 25
	ADD OBJECT olblpassword AS LABEL ;
		WITH Caption = "Password:", ;
		Left = 15, ;
		Top = 60
	ADD OBJECT olblresultado AS LABEL ;
		WITH Caption = "", ;
		AutoSize = .T., ;
		FontItalic = .T., ;
		FontBold = .T., ;
		ForeColor = RGB(0,55,255), ;
		Left = 45, ;
		Top = 92
	ADD OBJECT otbxusuario AS TEXTBOX ;
		WITH Left = 95, ;
		Top = 23, ;
		Width = 130
	ADD OBJECT otbxpassword AS TEXTBOX ;
		WITH Left = 95, ;
		Top = 57, ;
		Width = 130, ;
		PasswordChar = '*'
	
	PROCEDURE otbxpassword.GotFocus
*		SET CURSOR OFF
		SET CURSOR ON
	ENDPROC
	
	PROCEDURE otbxpassword.LostFocus
		SET CURSOR ON
	ENDPROC

	PROCEDURE otbxusuario.Valid
		IF LASTKEY() = 5 .OR. LASTKEY() = 24 .OR. LASTKEY() = 4 .OR. LASTKEY() = 19
			RETURN .F.
		ELSE
			RETURN .T.
		ENDIF
	ENDPROC


	PROCEDURE otbxpassword.KeyPress
	PARAMETERS nKeyCode, nShiftAltCtrl     
  		NODEFAULT
  		DO CASE
  			CASE BETWEEN(nKeyCode, 33, 126)
				This.Value = ALLTRIM(This.Value) + CHR(nKeyCode)

			CASE nKeyCode = 13 .AND. LEN(This.Value) < 128
				* Password,
				* puede contener mayúsculas, minúsculas, dígitos y signos especiales, 
				* más específicamente las posiciones que van de la 33 a la 126 del
				* ASCII Character Set

				* Password encriptado
				LOCAL cpassenc
				cpassenc = SPACE(128)
				IF LEN(ALLTRIM(This.Value)) > 0
					encriptar(This.Value, @cpassenc, 0)
				ENDIF
				
				SELECT Usuarios
				SET ORDER TO 1
				SEEK LOWER(ALLTRIM(Thisform.otbxusuario.Value))
				IF FOUND()
					IF Usuarios.passenc == LEFT(cpassenc,13)
						Thisform.olblresultado.Caption = "Usuario validado"
						WAIT "" TIMEOUT 1
						gnSecurityLevel = nivel
						Thisform.release()
					ELSE
						Thisform.olblresultado.Caption = "Fallo en la validación"
						WAIT "" TIMEOUT 1
						gnSecurityLevel = 0
						Thisform.release()
					ENDIF
				ELSE
					Thisform.olblresultado.Caption = "Fallo en la validación"
					WAIT "" TIMEOUT 1
					gnSecurityLevel = 0
					Thisform.release()
				ENDIF
			CASE nKeyCode = 127
				This.Value = LEFT(This.Value,(LEN(This.Value)-1))
			CASE nKeyCode = 9
				Thisform.otbxusuario.setFocus
		ENDCASE
	ENDPROC

	PROCEDURE Init
		DECLARE INTEGER blowfish_encrypt_pass IN blowfish.dll AS encriptar ;
			STRING , STRING @, INTEGER i
	ENDPROC

	PROCEDURE Load
		IF !USED("Usuarios")
			USE Usuarios
		ENDIF
	ENDPROC
	PROCEDURE Destroy
		CLEAR DLLS
  		CLEAR EVENTS
	ENDPROC
ENDDEFINE


DEFINE CLASS cfrmPrincipalConsorcio AS Form
	BackColor = RGB(192, 192, 192)
	Caption = "Administrador de Consorcios 1.00"
	Desktop = .T.
	Height = 540
	Width = 790
	Icon = "Aromal.ico"
	Top = 0
	Left = 0
	ScaleMode = 3
	ShowWindow = 2
	KeyPreview = .T.
	FontName = "Times New Roman"
	FontSize = 16
*	Picture = "Logo2.bmp"
	ADD OBJECT Logo AS Image ;
	WITH Picture = "Logo3.bmp", ;
		Left = 250, ;
		Top = 100
	PROCEDURE Init
		Application.Visible = .F.
		DO MenuCons02 WITH THIS
	ENDPROC
	PROCEDURE Destroy
		CLEAR EVENTS
		RELEASE MENU mPrincipalConsorcio EXTENDED
	ENDPROC
ENDDEFINE



********* PROCEDIMIENTOS ****************************************

PROCEDURE MenuCons02 
	LPARAMETERS oFormRef
	DEFINE MENU mPrincipalConsorcio ;
		IN (oFormRef.Name) ;
		BAR ;
		FONT 'Courier', 38 ;
		STYLE 'N' ;
		MESSAGE " ¿ Cuándo sale este mensaje ?? Hee? "

	
	DEFINE PAD padConsorcio OF mPrincipalConsorcio ;
		PROMPT '\<Consorcios' ;
		KEY ALT+C, '' ;
		MESSAGE "Gestión de los Consorcios " ;
		COLOR SCHEME 3

	ON PAD padConsorcio OF mPrincipalConsorcio ;
		ACTIVATE POPUP popConsorcio 

	DEFINE POPUP popConsorcio MARGIN RELATIVE COLOR SCHEME 4

	DEFINE BAR 1 OF popConsorcio PROMPT '\<Nuevo' ;
		KEY CTRL+N, '^N' ;
		MESSAGE " Permite registra un nuevo Consorcio "

	ON SELECTION BAR 1 OF popConsorcio ;
		DO NuevoCons

	DEFINE BAR 2 OF popConsorcio PROMPT '\<Modificar' ;
		KEY CTRL+M, '^M' ;
		MESSAGE " Permite modificar los atributos del Consorcio actual"
	
	ON SELECTION BAR 2 OF popConsorcio ;
		DO ModCons

	DEFINE BAR 3 OF popConsorcio PROMPT 'E\<liminar' ;
		KEY CTRL+L, '^L' ;
		MESSAGE "Elimina el Consorcio actual de la Base de Datos "
	
	ON SELECTION BAR 3 OF popConsorcio ;
		DO BajaCons

	DEFINE BAR 4 OF popConsorcio PROMPT '\-' ;
	
	DEFINE BAR 5 OF popConsorcio PROMPT '\<Salir        ' ;
		KEY ALT+F4, 'Alt+F4' ;
		MESSAGE "Sale de la aplicación "

	ON SELECTION BAR 5 OF popConsorcio CLEAR EVENTS


	DEFINE PAD padUnidades OF mPrincipalConsorcio ;
		PROMPT '\<Unidades' ;
		KEY ALT+U, '' ;
		MESSAGE "Gestión de las Unidades " ;
		COLOR SCHEME 3

	ON PAD padUnidades OF mPrincipalConsorcio ;
		ACTIVATE POPUP popUnidades

	DEFINE POPUP popUnidades MARGIN RELATIVE COLOR SCHEME 4

	DEFINE BAR 1 OF popUnidades PROMPT '\<Cargar               ' ;
		KEY ALT+C, '' ;
		MESSAGE " Permite cargar las unidades del Consorcio actual "

	ON SELECTION BAR 1 OF popUnidades ;
		DO cargaruni

	DEFINE BAR 2 OF popUnidades PROMPT '\<Modificar               ' ;
		KEY ALT+M, '' ;
		MESSAGE " Permite modificar las unidades del Consorcio actual "

	ON SELECTION BAR 2 OF popUnidades ;
		DO ModUni

	DEFINE BAR 3 OF popUnidades PROMPT '\<Eliminar               ' ;
		KEY ALT+E, '' ;
		MESSAGE " Permite eliminar unidades del Consorcio actual "

	ON SELECTION BAR 3 OF popUnidades ;
		DO BajaUni





	DEFINE PAD padExpensas OF mPrincipalConsorcio ;
		PROMPT '\<Expensas' ;
		KEY ALT+E, '' ;
		MESSAGE "Gestión de las Expensas " ;
		COLOR SCHEME 3

	ON PAD padExpensas OF mPrincipalConsorcio ;
		ACTIVATE POPUP popExpensas

	DEFINE POPUP popExpensas MARGIN RELATIVE COLOR SCHEME 4

	DEFINE BAR 1 OF popExpensas PROMPT '\<Registrar prorrateos    ' ;
		KEY ALT+R, '' ;
		MESSAGE " Permite cargar las incidencias de las unidades "

	ON SELECTION BAR 1 OF popExpensas ;
		DO FORM "car_expensa2"


	DEFINE PAD padGastos OF mPrincipalConsorcio ;
		PROMPT '\<Gastos' ;
		KEY ALT+E, '' ;
		MESSAGE "Gestión de las Expensas " ;
		COLOR SCHEME 3


	ON SELECTION PAD padGastos OF mPrincipalConsorcio ;
		DO FORM SAN_GASTOS



	DEFINE PAD padLiquidación OF mPrincipalConsorcio ;
		PROMPT '\<Liquidar' ;
		KEY ALT+L, '' ;
		MESSAGE "Liquidación de las expensas" ;
		COLOR SCHEME 3

	ON SELECTION PAD padLiquidación OF mPrincipalConsorcio ;
		Do Form "liquidarse_3"


	DEFINE PAD padPagos OF mPrincipalConsorcio ;
		PROMPT '\<Pagos' ;
		KEY ALT+P, '' ;
		MESSAGE "Gestión de Pagos " ;
		COLOR SCHEME 3


	ON PAD padPagos OF mPrincipalConsorcio ;
		ACTIVATE POPUP popPagos

	DEFINE POPUP popPagos MARGIN RELATIVE COLOR SCHEME 4

	DEFINE BAR 1 OF popPagos PROMPT '\<Pago Rápido            ' ;
		KEY ALT+R, '' ;
		MESSAGE " Pago rápido "

	ON SELECTION BAR 1 OF popPagos ;
		DO PagoFast

	DEFINE BAR 2 OF popPagos PROMPT '\<Pago Completo          ' ;
		KEY ALT+M, '' ;
		MESSAGE " Pago Completo "

	ON SELECTION BAR 2 OF popPagos ;
		DO Pago



	DEFINE PAD padConsultas OF mPrincipalConsorcio ;
		PROMPT '\<Consultas' ;
		KEY ALT+C, '' ;
		MESSAGE "Consultas " ;
		COLOR SCHEME 3
	ON SELECTION PAD padConsultas OF mPrincipalConsorcio ;
		

	ON PAD padConsultas OF mPrincipalConsorcio ;
		ACTIVATE POPUP popConsultas 

	DEFINE POPUP popConsultas MARGIN RELATIVE COLOR SCHEME 4

	DEFINE BAR 1 OF popConsultas PROMPT '\<Morosos mensuales' ;
		KEY CTRL+N, '^N' ;
		MESSAGE " Busca los morosos mensuales "

	ON SELECTION BAR 1 OF popConsultas ;
			DO MOROSOS

	DEFINE BAR 2 OF popConsorcio PROMPT '\<Modificar' ;
		KEY CTRL+M, '^M' ;
		MESSAGE " Permite modificar los atributos del Consorcio actual"



	DEFINE PAD padListados OF mPrincipalConsorcio ;
		PROMPT '\<Listados' ;
		KEY ALT+L, '' ;
		MESSAGE "Listados pertinentes " ;
		COLOR SCHEME 3

	DEFINE PAD padAyuda OF mPrincipalConsorcio ;
		PROMPT '\<Ayuda' ;
		KEY ALT+A, '' ;
		MESSAGE "Ayuda del sistema  " ;
		COLOR SCHEME 3

	ON PAD padAyuda OF mPrincipalConsorcio ;
		ACTIVATE POPUP popAyuda

	DEFINE POPUP popAyuda MARGIN RELATIVE COLOR SCHEME 4

	DEFINE BAR 1 OF popAyuda PROMPT '\<Temas de Ayuda' ;
		KEY F1, '        F1' ;
		MESSAGE " Busca temas de ayuda a partir de las palabras ;
				claves especificadas "

	ON SELECTION BAR 1 OF popAyuda ;
		MESSAGEBOX("Aca comienza la ayuda del Sistema  ", (2+48+256), ;
		"Ayuda del Sistema Administración de Consorcios 1.00")

	DEFINE BAR 2 OF popAyuda PROMPT '\<Acerca de Administración de Consorcios 1.00 ...' ;
		MESSAGE " Créditos, Copyright, Miscelánea "


	ON SELECTION BAR 2 OF popAyuda ;
		MESSAGEBOX("Acerca de Adm. de Consorcios 1.00 ", ;
		(2+48+256), "Copyright GRUPO 11 (C) 1999")


	ACTIVATE MENU mPrincipalConsorcio NOWAIT
	
	
	
	**   Falta agregar ABM de usuarios para los niveles
	**   Superusuario y Total
	
	IF gnSecurityLevel > 2
	
		SET SKIP OF BAR 2 OF popConsorcio .T.
		SET SKIP OF BAR 3 OF popConsorcio .T.
	
		SET SKIP OF BAR 2 OF popUnidades .T.
		SET SKIP OF BAR 3 OF popUnidades .T.
		
		SET SKIP OF PAD padExpensas OF mPrincipalConsorcio .T.
		SET SKIP OF PAD padLiquidación OF mPrincipalConsorcio .T.
		SET SKIP OF PAD padPagos OF mPrincipalConsorcio .T.

		IF gnSecurityLevel = 4
			SET SKIP OF PAD padConsorcio OF mPrincipalConsorcio .T.
			SET SKIP OF PAD padUnidades OF mPrincipalConsorcio .T.
			SET SKIP OF PAD padGastos OF mPrincipalConsorcio .T.
		ENDIF
	ENDIF
		
	
	
	
	
ENDPROC
