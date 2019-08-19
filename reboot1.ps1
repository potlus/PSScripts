# Powershell script to check Last Reboot Time on a list of machines included in a text file and export the report as a CSV file 
# Editor - Sreenivas P
 
 
$machines = Get-Content computers.txt 
$report = @() 
$object = @() 
foreach($machine in $machines) 
{ 
$machine 
$object = gwmi win32_operatingsystem -ComputerName $machine | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} 
$report += $object 
} 
$report | Export-csv .\Reboot.csv -NoTypeInformation