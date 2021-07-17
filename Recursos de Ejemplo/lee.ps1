Add-Type -Path ".\src\System.Data.SQLite.dll"
#Se crea un nuevo objeto del tipo SQLite
$conexion = New-Object -TypeName System.Data.SQLite.SQLiteConnection
#Establece la ruta a la base de datos
$DBPath = "Data Source=.\database\Cars.db"
#Se establece la cadena que se usará para abrir la conexión
$conexion.ConnectionString = $DBPath
#Se abre la conexión a SQLite
$conexion.Open()
#Se crea un nuevo comando de SQLite asociado a la conexión
$sql = $conexion.CreateCommand()
#Declaracion del query 
$queryCreateTable= 
    'CREATE TABLE cars(
    ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    make        TEXT    NULL,
    model      TEXT    NULL,
	seats 		TEXT	NULL
    );'
#CommandText es el Query que se ejecutará  a la base de datos
$sql.CommandText=$queryCreateTable
    try {
        $success = $sql.ExecuteNonQuery()
    }
    catch {
        Write-Warning 'No se creo la tabla';
    }

<#endregion#>

$XMLfile = '.\xml\cars.xml'

[XML]$coches = Get-Content $XMLfile


foreach($coche in $coches.Cars.car)
{

	$queryInsert=
    'INSERT INTO  cars
    (make, model, seats)
    VALUES ("'+$coche.Make+'","'+$coche.Model+'","'+$coche.Seats+'"
    );
    '
    $sql.CommandText=$queryInsert
    try {
        $success = $sql.ExecuteNonQuery()
        Write-Host "make  :" $coche.Make
		Write-Host "model :" $coche.Model
		Write-Host "seats :" $coche.Seats
		Write-Host ''
    }
    catch {
        Write-Warning 'No se pudo insertar ningún dato';
    }

	

}