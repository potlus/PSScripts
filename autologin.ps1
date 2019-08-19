#The purpose of this PowerShell script is to set the AutoLogon and WinLogon registry strings using PowerShell, to setup a Windows Server #or Workstation for Automatic Logon.
#The $UserName and $Password variables need to be configuration for your environment. Please make sure the $UserName variables follows #DOMAINNAME\SAMACCOUNTNAME format.
#This needs to be ran using an Elevated PowerShell ISE or PowerShell window (with Admin access on the computer you are running this on).
$usrname = 'CORP\ushou-asyswdv'
$password = 'gUerug1g'
$RegistryLocation = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

Set-ItemProperty $RegistryLocation -Name 'AutoAdminLogon' -Value '1'
Set-ItemProperty $RegistryLocation -Name 'DefaultUsername' -Value "$usrname"
Set-ItemProperty $RegistryLocation -Name 'DefaultPassword' -Value "$password"