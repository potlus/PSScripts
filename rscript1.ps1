$ServerFile = Get-Content "\\houdata04\IT Services\DATA CENTER\Autosys\Working On\Sreenivas\SCRIPTS\devservers.txt"

foreach ($computer in $ServerFile)
{

Restart-Computer -ComputerName $computer -force

}