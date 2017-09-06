strPName = "VBoxTray.exe"
strComputer = "."
Set objShell = CreateObject("Wscript.Shell")
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!//" & strComputer & "/root/cimv2")

Set colProcessList = objWMIService.ExecQuery _
("Select * from Win32_Process Where Name = '" & strPName & "'")

For Each objProcess in colProcessList
objProcess.Terminate()
Next

WScript.Sleep 4000
objshell.Run "VBoxTray.exe"
objshell.Run "VBoxTray.exe"
