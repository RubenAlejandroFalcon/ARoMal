	
SELECT Propietarios.cod_prorio AS Cod, ;
		(ALLTRIM(Propietarios.apellido) + ",  " ;
		+ ALLTRIM(Propietarios.nombre)) AS Nombre, ;
		Docu_Tipo2.descripcion AS Tipo_doc, ;
		Propietarios.nro_doc AS Nro_doc, ;
		Propietarios.direccion AS Direccion, ;
		Propietarios.telefono AS Telefono, ;
		Unidades.nro_unidad AS Unidad, ;
		Unidades.piso AS Piso, ;
		Unidades.departamento AS Depto, ;
		Consorcios.nro_consor AS Nro_consor, ;
		Consorcios.nombre AS Consorcio, ;
		IIF(Tipo_Administracion.cobra_atraz = 'S', ;
			.T., .F.)  AS atraz, ;
		Expensas.mes AS mes, ;
		Expensas.anio AS anio, ;
		Expensas.monto_paga AS suma ;
	FROM Propietarios, Unidades, Expensas, Consorcios, ;
		Docu_Tipo2, Tipo_administracion ;
	WHERE Propietarios.tipo_doc = Docu_Tipo2.tipo_doc ;
		.AND. Propietarios.cod_prorio = Unidades.cod_prorio ;
		.AND. Unidades.nro_consor = Consorcios.nro_consor ;
		.AND. Consorcios.nro_consor = Tipo_administracion.nro_consor ;
		.AND. Unidades.nro_unidad = Expensas.nro_unidad ;
		.AND. Expensas.nro_consor = Unidades.nro_consor ;
		.AND. Expensas.Abonado = .F.  ;
		.AND. Tipo_administracion.cobra_atraz = 'N' ;
	ORDER BY 10, 7, 8, 9, 14, 13 ;
	INTO TABLE ConsOk

SELECT Propietarios.cod_prorio AS Cod, ;
		(ALLTRIM(Propietarios.apellido) + ",  " ;
		+ ALLTRIM(Propietarios.nombre)) AS Nombre, ;
		Docu_Tipo2.descripcion AS Tipo_doc, ;
		Propietarios.nro_doc AS Nro_doc, ;
		Propietarios.direccion AS Direccion, ;
		Propietarios.telefono AS Telefono, ;
		Unidades.nro_unidad AS Unidad, ;
		Unidades.piso AS Piso, ;
		Unidades.departamento AS Depto, ;
		Consorcios.nro_consor AS Nro_consor, ;
		Consorcios.nombre AS Consorcio, ;
		IIF(Tipo_Administracion.cobra_atraz = 'S', ;
			.T., .F.)  AS atraz, ;
		Expensas.mes AS mes, ;
		Expensas.anio AS anio, ;
		Expensas.monto_paga AS suma ;
	FROM Propietarios, Unidades, Expensas, Consorcios, ;
		Docu_Tipo2, Tipo_administracion ;
	WHERE Propietarios.tipo_doc = Docu_Tipo2.tipo_doc ;
		.AND. Propietarios.cod_prorio = Unidades.cod_prorio ;
		.AND. Unidades.nro_consor = Consorcios.nro_consor ;
		.AND. Consorcios.nro_consor = Tipo_administracion.nro_consor ;
		.AND. Unidades.nro_unidad = Expensas.nro_unidad ;
		.AND. Expensas.nro_consor = Unidades.nro_consor ;
		.AND. Expensas.Abonado = .F.  ;
		.AND. Tipo_administracion.cobra_atraz = 'S' ;
	ORDER BY 10, 7, 8, 9, 14, 13 ;
	INTO TABLE tmpta
	
SELECT tmpta

GO TOP
DO WHILE !EOF()
	u = unidad
	p = .T.
	DO WHILE u = unidad
		IF p
			suma1 = suma
			p = .F.
		ELSE
			REPLACE suma WITH suma - suma1
			suma1 = suma1 + suma
		ENDIF
		SKIP
	ENDDO
ENDDO

SELECT * FROM tmpta INTO ARRAY m_tmpta
SELECT ConsOk
IF TYPE("m_tmpta") = "N" 
	APPEND FROM ARRAY m_tmpta
ENDIF
SELECT ConsOk.cod AS Cod, ;
			ConsOk.nombre AS Nombre, ;
			ConsOk.tipo_doc AS Tipo_doc, ;
			ConsOk.nro_doc AS Nro_doc, ;
			ConsOk.direccion AS Direccion, ;
			ConsOk.telefono AS Telefono, ;
			ConsOk.unidad AS Unidad, ;
			ConsOk.piso AS Piso, ;
			ConsOk.depto AS Depto, ;
			ConsOk.nro_consor AS Nro_consor, ;
			ConsOk.Consorcio AS Consorcio, ;
			COUNT (ConsOk.mes) AS expensas, ;
			SUM(ConsOk.suma) AS suma ;
		FROM ConsOk ;
		GROUP BY ConsOk.nro_consor, ;
			ConsOk.cod, ConsOk.unidad ;
		ORDER BY 2 ;
		INTO TABLE ConsMor

SELECT ConsMor
INDEX ON nro_consor TAG nro_consor
