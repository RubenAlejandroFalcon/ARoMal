#########################################################################

# Constructores
cc     = cl
rc     = rc
link   = link

mkdir 	= md
debugdir = Debug
releasedir = Release

# Flags comunes
ccommon = -c -W3 -nologo -D "WIN32" -D "_WINDOWS"

# Flags para el compilador de recursos
rcflags = /r

!IFDEF DEBUG
#cdebug = /GX /Od /MTd /D "_DEBUG" /Fp$(dir)\$(PROYECTO).pch -FR$(dir)\$(PROYECTO).sbr
cdebug = /MLd /Gm /Zi /Od /D "_DEBUG" /YX /Fp$(dir)\$(PROYECTO).pch -FR$(dir)\$(PROYECTO).sbr
!ELSE
#cdebug = -O2 -G5 -ML -GD -D "NDEBUG" 
cdebug = -Otg -G5 -GD -ML -D "NDEBUG"
!ENDIF

cflags = $(ccommon) $(cdebug)

lcommon  = /nodefaultlib /nologo  /machine:IX86 /subsystem:windows,4.00 /DEF:blowfish.def /DLL
#/warn:3 /OPT:NOREF

!IFDEF DEBUG
dir = $(debugdir)
ldebug = /INCREMENTAL:YES /DEBUG /PDB:$(dir)\$(PROYECTO).pdb 
!ELSE
dir = $(releasedir)
ldebug = /incremental:no /release 
!ENDIF

lflags = $(lcommon) $(ldebug)


##########################################################################
# MAIN MAKEFILE ;-)

PROYECTO = Blowfish
VERSION = 1.00


all:	makedir $(PROYECTO).dll END

!IFDEF DEBUG
makedir: 
        IF NOT ISDIR $(debugdir) $(mkdir) $(debugdir)
!ELSE
makedir: 
        IF NOT ISDIR $(releasedir) $(mkdir) $(releasedir)
!ENDIF


PROY_OBJS = $(dir)\$(PROYECTO).obj $(dir)\DllMain.obj

!IFDEF DEBUG
libs = kernel32.lib libcd.lib
!ELSE
libs = kernel32.lib libc.lib
!ENDIF

#$(PROYECTO).obj:
$(dir)\$(PROYECTO).obj:
  $(cc) $(cflags) /Fo$(dir)\$(PROYECTO).obj $(PROYECTO).c

#DllMain.obj:
$(dir)\DllMain.obj:
  $(cc) $(cflags) /Fo$(dir)\DllMain.obj DllMain.c

#$(PROYECTO).res: $(PROYECTO).rc
#    $(rc) $(rcflags) /fo $(dir)\$(PROYECTO).res $(PROYECTO).rc

$(PROYECTO).dll: $(PROY_OBJS) 
    $(link) $(lflags) /VERSION:$(VERSION) \
    $(PROY_OBJS) $(libs) \
    -out:$(dir)\$(PROYECTO).dll

#$(PROYECTO).res
#$(dir)\$(PROYECTO).res 

!IFDEF DEBUG
END:
    BSCMAKE /nologo /n /Iu /o $(dir)\$(PROYECTO).bsc $(dir)\$(PROYECTO).sbr 
!ELSE
END:
    del /q /e $(dir)\*.obj $(dir)\*.exp $(dir)\*.lib
!ENDIF

#del /q /e $(dir)\*.res $(dir)\*.obj

clean:
    del /q /e /s /x /y $(debugdir) $(releasedir)
