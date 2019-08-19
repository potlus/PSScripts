$servers = get-content servers.txt
foreach ($servers in $servers) {

Invoke-WmiMethod -class Win32_process -name Create -ArgumentList (Start-Process c:\windows\system32\ipconfig.exe -argumentlist '/flushdns') -ComputerName $servers

}