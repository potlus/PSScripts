$computers = Get-Content -Path "\\houdata04\IT Services\DATA CENTER\Autosys\Working On\Sreenivas\SCRIPTS\asys_servers.txt"
$useracct = "ushou-asyswdv"
$password = "r4T$%Ekv4"

foreach ($computer in $computers)
{
    Write-Host "Setting $useracct's password on $computer"
    $user = [adsi]"WinNT://$computer/$useracct,user"
    $user.SetPassword($password)
    $user.SetInfo()
    Write-Host "Password set on $computer"
}