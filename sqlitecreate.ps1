#evitamos que corra con algún error
#set-psdebug -strict; $ErrorActionPreference = "stop"
<#
    Se agregan las rutas donde están las librerías de SQLite
    Deben existir dos archivos:
    System.Data.SQLite.dll
    SQLite.Interop.dll
#>
Add-Type -Path ".\src\System.Data.SQLite.dll"
#Se crea un nuevo objeto del tipo SQLite
$conexion = New-Object -TypeName System.Data.SQLite.SQLiteConnection
#Establece la ruta a la base de datos
$DBPath = "Data Source=.\database\Monitor1.db"
#Se establece la cadena que se usará para abrir la conexión
$conexion.ConnectionString = $DBPath
#Se abre la conexión a SQLite
$conexion.Open()
#Se crea un nuevo comando de SQLite asociado a la conexión
$sql = $conexion.CreateCommand()
#Declaracion del query 
$queryCreateTable= 
    'CREATE TABLE monitorPrueba(
    ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    url        TEXT    NULL,
    estado      TEXT    NULL
    );'

#CommandText es el Query que se ejecutará  a la base de datos
$sql.CommandText=$queryCreateTable
    try {
        $success = $sql.ExecuteNonQuery()
    }
    catch {
        Write-Warning 'No se creo la tabla';
    }

<#endregion


$queryInsert=
'INSERT INTO  monitorPrueba
(url, estado)
VALUES ("'+$p+'","'+$_+'"
);
'
Write-Output $queryInsert
#>
<#endregion#>
    

    Do{ 
        $available = $Null 
        $notavailable = $Null 
        Write-Host (Get-Date) 

        get-content hosts.txt | Where-Object {!($_ -match "#")} |   

ForEach-Object { 
    #$p = Test-Connection -ComputerName $_ -Count 1 -ea silentlycontinue 
    $p = Test-Connection -ComputerName $_ -Count 1  -ea silentlycontinue 

if($p) 
    { 
     # if the Host is available then just write it to the screen 
     $queryInsert=
    'INSERT INTO  monitorPrueba
    (url, estado)
    VALUES ("'+$_+'","en linea"
    );
    '
    $sql.CommandText=$queryInsert
    try {
        $success = $sql.ExecuteNonQuery()
        Write-Warning 'Si se inserto el si';
    }
    catch {
        Write-Warning 'No se inserto el si';
        Write-Warning $queryInsert;
    }



     write-host "Available host ---> "$_ -BackgroundColor Green -ForegroundColor White 
     [Array]$available += $_ 
    } 
else 
    { 
       $queryInsert= 'INSERT INTO  monitorPrueba
        (url, estado)
        VALUES ("'+$_+'","fuera de linea"
        );
        '
     $sql.CommandText=$queryInsert
    try {
        $success = $sql.ExecuteNonQuery()
        Write-Warning 'Si se inserto el no';
    }
    catch {
        Write-Warning 'No inserto el no';
    }



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




