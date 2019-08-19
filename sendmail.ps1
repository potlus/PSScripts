#$computers=Gc "\\houdata04\IT Services\DATA CENTER\Autosys\Working On\Sreenivas\SCRIPTS\PRD-Reboots\servers.txt"
$cname = Read-Host "Enter Computer Name"
$uname = Read-Host "Enter Username"



#ForEach-Object {$_.Name}
#ForEach ($computer in $computers){
#Try {
#restart-computer $computer -force
restart-computer $cname -force -credential "corp\$uname"
Write-Host "restarting: " $computer
#}
#Catch {
#[system.exception]
#Write "Failed to restart the computer!. `n$error[0]"
#}
#Write-Host "Complete!"}


$emailTo = "sreenivas.potluri@invesco.com"
$subject = "Reboot Test"
$body = "Server has been rebooted"
$smtpServer = "10.181.30.14"
#$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 25) 
#$SMTPClient.EnableSsl = $true 
#$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("user", "password"); 
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)