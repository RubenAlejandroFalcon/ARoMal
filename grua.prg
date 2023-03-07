*set step on
* Cierra todas las bases de datos abiertas.
CLOSE DATABASES

* Borra el escritorio para prepararlo para mostrar la matriz.
CLEAR

* Abre la base de datos testdata.
OPEN DATABASE Aromal EXCLUSIVE

LOCAL ntab

ntab = ADBOBJECTS(gaTables, "TABLE")

* Muestra la matriz gaTables creada por la función ADBOBJECTS( ).
*DISPLAY MEMORY LIKE gaTables

FOR i = 1 TO ntab
	USE &gaTables(i) EXCLUSIVE
	REINDEX
	USE
ENDFOR

VALIDATE DATABASE