$out = @()
$servers = get-content prodservers.txt
foreach ($server in $servers)
{
    $out += Get-WinEvent -ComputerName $server -FilterHashTable @{LogName='System'; ID=6008,1074} | Select-Object MachineName,TimeCreated,Id,Message 
}

$out | Export-Csv .\events.csv -NoTypeInformation