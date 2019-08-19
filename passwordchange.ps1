$Computers = Get-Content "\\houdata04\IT Services\DATA CENTER\Autosys\Working On\Sreenivas\SCRIPTS\asys_servers.txt"
foreach ($Computer in $Computers) {
   $Computer    =    $Computer.toupper()
   $Isonline    =    "OFFLINE"
   $Status        =    "SUCCESS"
    Write-Verbose "Working on $Computer"
if((Test-Connection -ComputerName $Computer -count 1 -ErrorAction 0)) {
   $Isonline = "ONLINE"
   Write-Verbose "`t$Computer is Online"
} else { Write-Verbose "`t$Computer is OFFLINE" }
 
try {
   $account = [ADSI]("WinNT://$Computer/Administrator,user")
   $account.psbase.invoke("setpassword",$pwd1_text)
   Write-Verbose "`tPassword Change completed successfully"
}
catch {
  $status = "FAILED"
  Write-Verbose "`tFailed to Change the administrator password. Error: $_"
}
 
$obj = New-Object -TypeName PSObject -Property @{
  ComputerName = $Computer
  IsOnline = $Isonline
  PasswordChangeStatus = $Status
}
 
$obj | Select ComputerName, IsOnline, PasswordChangeStatus
 
if($Status -eq "FAILED" -or $Isonline -eq "OFFLINE") {
   $stream.writeline("$Computer `t $isonline `t $status")
}
 
}