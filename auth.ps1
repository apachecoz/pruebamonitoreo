$url = "http://172.16.2.253/apiphp/auth.php"

$Body=@{
    usuario="usuario1@gmail.com"
    password= "123456"
}

Invoke-RestMethod -Method 'Post' -Uri $url -Body ($Body|ConvertTo-Json) 