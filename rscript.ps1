
$ServerList = Get-Content "\\houdata04\IT Services\DATA CENTER\Autosys\Working On\Sreenivas\SCRIPTS\devservers.txt" 

$Credential = Get-Credential -UserName 'corp\ushou-asyswdv' -Message 'Enter the credentials to restart the computers:'
   
If ($Credential) {
    $Collection = @()
    ForEach ($Server in $ServerList) {
        $Status = @{
            'ServerName' = $Server
            'Network' = 'Down'
            'Reboot' = "n/a"
        }
        If (Test-Connection $Server -Count 2 -ea 0 -Quiet) {
            $Status["Network"] = "Up"
            Restart-Computer -ComputerName $Server -ErrorVariable ev -Credential $Credential -Force
            If ($?) {
                $Status["Reboot"] = "OK"
            } Else {
                $Status["Reboot"] = $ev.Exception.Message
            }
        }
        $Collection += New-Object -TypeName PSObject -Property $Status
    }
	  $Collection | Select-Object ServerName, Network, Reboot
	  
}

