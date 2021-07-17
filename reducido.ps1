   

    Do{ 
        $available = $Null 
        $notavailable = $Null 
        Write-Host (Get-Date) 

        get-content hosts.txt | Where-Object {!($_ -match "#")} |   

ForEach-Object { 
    $p = Test-Connection -ComputerName $_ -Count 1 -ea silentlycontinue 

if($p) 
    { 
     # if the Host is available then just write it to the screen 
     $queryInsert =    'INSERT INTO  monitorPrueba
     (url, estado)
     VALUES ("172.16.2.253",2
     );
     '
     $sql.CommandText = $queryInsert
     try {
        $success = $sql.ExecuteNonQuery()
        Write-Warning 'Si funciono';
    }
    catch {
        Write-Warning 'No funciono';
    }

     write-host "Available host ---> "$_ -BackgroundColor Green -ForegroundColor White 
     [Array]$available += $_ 
    } 
else 
    { 

       
     # If the host is unavailable, give a warning to screen 
     write-host "Unavailable host ------------> "$_ -BackgroundColor Magenta -ForegroundColor White 
     $p = Test-Connection -ComputerName $_ -Count 1 -ea silentlycontinue 
     if(!($p)) 
       { 
        # If the host is still unavailable for 4 full pings, write error and send email 
        write-host "Unavailable host ------------> "$_ -BackgroundColor Red -ForegroundColor White 
	
        [Array]$notavailable += $_ 
    } 
} 
} 

# Report to screen the details 
Write-Host "Available count:"$available.count 
Write-Host "Not available count:"$notavailable.count 
Write-Host "Not available hosts:" 
$OutageHosts 
Write-Host "" 
Write-Host "Sleeping $SleepTimeOut seconds" 
sleep $SleepTimeOut 
if ($OutageHosts.Count -gt $MaxOutageCount) 
{ 
    # If there are more than a certain number of host down in an hour abort the script. 
    $Exit = $True 
   <#S $body = $OutageHosts | Out-String 
    end-MailMessage -Body "$body" -to $notificationto -from $notificationfrom ` 
     -Subject "More than $MaxOutageCount Hosts down, monitoring aborted" -SmtpServer $smtpServer #>
} 
} 
while ($Exit -ne $True)



  <#
$sql.CommandText = 'begin transaction'
$success = $sql.ExecuteNonQuery()


#>  

<#endregion
$adapter = New-Object -TypeName System.Data.SQLite.SQLiteDataAdapter $sql
$data = New-Object System.Data.DataSet
[void]$adapter.Fill($data)
#>

