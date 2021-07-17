function ConvertFrom-Xml {
	param([parameter(Mandatory, ValueFromPipeline)] [System.Xml.XmlNode] $node)
	process {
	  if ($node.DocumentElement) { $node = $node.DocumentElement }
	  $oht = [ordered] @{}
	  $name = $node.Name
	  if ($node.FirstChild -is [system.xml.xmltext]) {
		$oht.$name = $node.FirstChild.InnerText
	  } else {
		$oht.$name = New-Object System.Collections.ArrayList 
		foreach ($child in $node.ChildNodes) {
		  $null = $oht.$name.Add((ConvertFrom-Xml $child))
		}
	  }
	  $oht
	}
  }


$XMLfile = '.\cars.xml'

[XML]$coches = Get-Content $XMLfile
$cochesJSON = $coches | ConvertFrom-Xml | ConvertTo-Json -Depth 4 -Compress
#$cochesJSON = @{coches = $cochesJSON}
$Form = @{
    firstName  = 'John'
    lastName   = 'Doe'
    email      = 'john.doe@contoso.com'
    birthday   = '1980-10-15'
    hobbies    = 'Hiking','Fishing','Jogging'
}
$response =Invoke-WebRequest -Uri http://localhost/pruebas/index.php -Method POST -Form $Form
#$response.InputFields | Where-Object $cochesJSON
#Invoke-RestMethod -Method Post -Uri http://localhost/pruebas/index.php -Body 
<#
foreach($coche in $coches.Cars.car)
{

	Write-Host "make  :" $coche.Make
	Write-Host "model :" $coche.Model
	Write-Host "seats :" $coche.Seats
	Write-Host ''

}#>