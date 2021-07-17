
$url = "http://172.16.2.253/apiphp/pacientes.php"

$Body = @{
    
    nombre = "Powershell" 
    dni = "A000000007" 
    correo ="paciente7@gmail.com"
    codigoPostal ="20007"
    genero = "M"
    telefono = "123456789"
    fechaNacimiento = "1980-01-01"
    token = "d6f7081fc66e6b798ba5c975141db137" 
}

Invoke-RestMethod -Method 'Post' -Uri $url -Body ($Body|ConvertTo-Json) 