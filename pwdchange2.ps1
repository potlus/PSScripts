Param(
     [Parameter(Position=0)]
     [string]
     $computer = $env:computername,
     [string]
     $path = "\\houdata04\IT Services\DATA CENTER\Autosys\Working On\Sreenivas\SCRIPTS\asys_servers.txt",
     [string]
     $path2 = "\\houdata04\IT Services\DATA CENTER\Autosys\Working On\Sreenivas\SCRIPTS\users.txt",
     [string]
     [Parameter(Mandatory=$true)]
     $password
) #end param

if($path)
{
    $computers = Get-Content -path "$path"
    $users = Get-Content -path "$path2"
    Foreach($Computer in $computers)
    {
# $user = Get-Content -path "$path2"
        Foreach($User in $users)
        {
            "Setting $user password on $computer"
            $de = [adsi]"WinNT://$computer/$user,user"
            $de.ADsPath
# $de.SetPassword($password)
# $de.SetInfo()
        } #end foreach
    } 
} #end if
Else
{
    "Setting $user password on $computer"
    $de = [adsi]"WinNT://$computer/$user,user"
    $de.ADsPath
# $de.SetPassword($Password)
# $de.SetInfo()
}