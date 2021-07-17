#$url = "http://localhost:3000/api/movies"
#$url = "http://localhost/apiphp/pacientes.php"
$url = "http://172.16.2.253/apiphp/pacientes.php"
#$url = "http://172.16.2.253/apiphp/auth.php"
<#
$Body = @{
    title = "Jurassic Park"
    director = "James Cameron"
    year = "1995"
    rating = "9.5"
}#>

<#
$Body=@{
    usuario="usuario1@gmail.com"
    password= "123456"
}#>

$Body = @{
    
    nombre = "Powershell" 
    dni = "A000000007" 
    correo ="paciente7@gmail.com"
    codigoPostal ="20007"
    genero = "M"
    telefono = "123456789"
    fechaNacimiento = "1980-01-01"
    token = "4ee5d470665a5cefa4ca090b2b6104b7" 
}

#Invoke-RestMethod -Method 'Post' -Uri $url -Body $Body 
Invoke-RestMethod -Method 'Post' -Uri $url -Body ($Body|ConvertTo-Json) 