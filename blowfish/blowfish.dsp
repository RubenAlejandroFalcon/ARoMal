# Microsoft Developer Studio Project File - Name="blowfish" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) External Target" 0x0106

CFG=blowfish - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "blowfish.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "blowfish.mak" CFG="blowfish - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "blowfish - Win32 Release" (based on "Win32 (x86) External Target")
!MESSAGE "blowfish - Win32 Debug" (based on "Win32 (x86) External Target")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""

!IF  "$(CFG)" == "blowfish - Win32 Release"

# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Cmd_Line "NMAKE /f blowfish.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "blowfish.exe"
# PROP BASE Bsc_Name "blowfish.bsc"
# PROP BASE Target_Dir ""
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Cmd_Line "NMAKE /c /s /f blowfish.mak"
# PROP Rebuild_Opt "/a"
# PROP Target_File "blowfish.dll"
# PROP Bsc_Name ""
# PROP Target_Dir ""

!ELSEIF  "$(CFG)" == "blowfish - Win32 Debug"

# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Cmd_Line "NMAKE /f blowfish.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "blowfish.exe"
# PROP BASE Bsc_Name "blowfish.bsc"
# PROP BASE Target_Dir ""
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Cmd_Line "NMAKE /c /s /f blowfish.mak DEBUG=1"
# PROP Rebuild_Opt "/a"
# PROP Target_File "blowfish.dll"
# PROP Bsc_Name ""
# PROP Target_Dir ""

!ENDIF 

# Begin Target

# Name "blowfish - Win32 Release"
# Name "blowfish - Win32 Debug"

!IF  "$(CFG)" == "blowfish - Win32 Release"

!ELSEIF  "$(CFG)" == "blowfish - Win32 Debug"

!ENDIF 

# Begin Source File

SOURCE=.\blowfish.mak
# End Source File
# End Target
# End Project
