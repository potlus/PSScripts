$processToCheck = "OUTLOOK"
$process = Get-Process $processToCheck
If (!($process)) {
    Start-Process "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"
    Send-MailMessage -From sreenivas.potluri@invesco.com -To sreenivas.potluri@invesco.com -Body "Outlook is closed - So starting the outlook Process" -Subject "Starting Outlook" -SmtpServer smtp.na.amvescap.com
}