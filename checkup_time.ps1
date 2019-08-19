$ComputerNames = Get-Content "\\houdata04\it services\DATA CENTER\Autosys\NCC\CHECKUPTIME\RDV\servers.txt"

Function CheckServer ($CurrentComputer) {

    begin {
        $SelectHash = @{
         'Property' = @('Server Name','ResponseToPing','SharesAccessible','RDPAccessible','Uptime')
        }
    }
    process {
        
        $DefUptime = "0 Days 0 Hrs 0 Mins"
# Create new Hash
            $HashProps = @{
                'Server Name' = $CurrentComputer
                'ResponseToPing' = $false
                'SharesAccessible' = $false
                'RDPAccessible' = $false
                'Uptime' = $DefUptime
                          }
        
            # Perform Checks
            switch ($true)
            {
                {Test-Connection -ComputerName $CurrentComputer -Quiet -Count 1} {$HashProps.ResponseToPing = $true}
                {get-WmiObject -class Win32_Share -computer $CurrentComputer} {$HashProps.SharesAccessible = $true}
                {$(try {$socket = New-Object Net.Sockets.TcpClient($CurrentComputer, 3389);if ($socket.Connected) {$true};$socket.Close()} catch {})} {$HashProps.RDPAccessible = $true}
                Default {}
            }
           $Computerobj = "" | select ComputerName, Uptime, LastReboot 
           $wmi = Get-WmiObject -ComputerName $CurrentComputer -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem" -ErrorAction SilentlyContinue
           $now = Get-Date
                if (!($wmi -eq $null)) {
           $boottime = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
           $uptime = $now - $boottime
           $d =$uptime.days
           $dd =[int]$d
           $h =$uptime.hours
           $m =$uptime.Minutes
           #$s = $uptime.Seconds
           Write-Host "uptime: $dd"
           $Computerobj.ComputerName = $CurrentComputer
           $Computerobj.Uptime = "$d Days $h Hrs $m Mins"
                $Computerobj.LastReboot = $boottime
           $HashProps.Uptime = $Computerobj.Uptime
           $global:flag=0
           if($dd -gt 6){
            $global:flag=1
            Write-Host "flag=1"
           }
                }

            # Output object
            New-Object -TypeName 'PSCustomObject' -Property $HashProps | Select-Object @SelectHash

    }

    end {
    }
}


$smtpServer = "smtp.na.amvescap.com"
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "donotreply@invesco.com"
$msg.To.Add("sreenivas.potluri@invesco.com")
$msg.Cc.Add("sreenivas.potluri@invesco.com")
$msg.Subject = "UPTIME FOR DEVELOPMENT AUTOSYS SERVERS"
$msg.IsBodyHTML = $true

#Mail content - Formated HTML table
$style = ""
$style = "<html><head><style>BODY{font-family: Calibri; font-size: 11pt;}"
$style = $style + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$style = $style + "TH{border: 1px solid black; background: #87CEFA; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 5px; }"
$style = $style + "</style></head>"
$body = ""
$body += "<body>Review Below Servers Uptime and reboot them manually if needed. <br><br>"
$body += "<table><tr><th>Server Name</th><th>OS</th><th>Ping</th><th>Uptime</th></tr>"

foreach ($ComputerName in $ComputerNames) {
$varOutput = CheckServer($ComputerName.ToUpper())
$varOSFullName = Get-WmiObject -ComputerName $ComputerName -Class Win32_OperatingSystem | Select-Object caption -ErrorAction SilentlyContinue
$varOSName = ($varOSFullName.caption -split "\s")[3] +" "+ ($varOSFullName.caption -split "\s")[4] +" "+ ($varOSFullName.caption -split "\s")[5]

$body += "<tr><td><b>"+$varOutput.'Server Name' + "</b></td>" + "<td><b>"+ $varOSName + "</b></td>"

if ($varOutput.'ResponseToPing' -eq $true)
        {
                $body += "<td style=""background-color:#d3f8d3;color:green;""><b>Success</b></td>"
        }
        else
        {
                $body += "<td style=""background-color:#FAEBD7;color:red""><b>Fail</b></td>"
        }

if ($varOutput.'Uptime' -eq "0 Days 0 Hrs 0 Mins")
        {
                $body += "<td style=""background-color:#FAEBD7;color:red;""><b>" + $varOutput.'Uptime' + "</b></td>"
        }
        else
        {
                $body += "<td style=""background-color:#d3f8d3;color:green""><b>" + $varOutput.'Uptime' + "</b></td>"
        }

$body += "</tr>"
}

$body += "</table><br></body></html>"
$msg.Body = $style + $body
$smtp.Send($msg)
#Write-Host "$flag"
#$if ([int]$flag -eq 1){
#   Write-Host "sending mail"
#    $smtp.Send($msg)
#}    