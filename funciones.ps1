function Get-Algo{
    Param(
        [string]$PC1,
        [string]$PC2
         )
       #  $p1 = Test-Connection -ComputerName $PC1 -Count 1 -ea silentlycontinue 
        # $p2 = Test-Connection -ComputerName $PC2 -Count 1 -ea silentlycontinue 
        $p1 = Invoke-WebRequest $PC1 
        $p2 = Invoke-WebRequest $PC2 
        Write-Host $p1.StatusCode
        #Write-Host $p1.RawContent
        Write-Host $p2.StatusCode
        #Write-Host $p2.RawContent
        
        }
        Get-Algo  172.16.2.250:82 172.16.2.253
        #$a = Get-WmiObject win32_bios
        #Write-Host $a.serialnumber
        $a = Get-WmiObject win32_bios
        Write-Host $a

$body_json = '{"datasource": [{
            "parentId": "123456789000",
            "name": "(name)",
            "id": "(value)",
            "typeId": 0,
            "childEnabled": false,
            "childCount": 0,
            "childType": 0,
            "ipAddress": "(ipAddress)",
            "zoneId": 0,
            "url": "(url)",
            "enabled": false,
            "idmId": 123456789000,
            "parameters": [{
                "key": "(key)",
                "value": "(value)"
            }]
        }]}'


   