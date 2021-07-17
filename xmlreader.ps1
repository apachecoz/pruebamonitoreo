$XMLfile = '.\xml\ejemplo.xml'
[XML]$empDetails = Get-Content $XMLfile
 
foreach($empDetail in $empDetails.EmpDetails.Person){
 
Write-Host "Employee Id :" $empDetail.Id
Write-Host "Employee mail Id :" $empDetail.mailId
Write-Host "Employee Name :" $empDetail.empName
Write-Host ''
 
}