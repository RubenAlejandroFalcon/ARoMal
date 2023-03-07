@echo OFF
echo Construyendo la versión Release...
echo.
echo.        
echo                 Blowfish.dll...
echo.      
nmake /C /S /Fblowfish.mak
REM nmake /C /S /Fblowfish.mak DEBUG=1
echo.        
echo                 PruebaDll.exe...
nmake /C /S /FPruebaDll.mak
REM nmake /C /S /FPruebaDll.mak DEBUG=1
echo Finalizado
