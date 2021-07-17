$XMLfile = '.\applicationHost.config'

[XML]$sitios = Get-Content $XMLfile


# foreach($sitio in $sitios.configuration.system.applicationHost.sites.site)
# foreach($sitio in $sitios.configuration.system.applicationHost.applicationPools.add)
 
# si jaló:
# foreach($sitio in $sitios.configuration.configProtectedData.providers.add) 
#foreach($sitio in $sitios.configuration.system.applicationHost.applicationPools.add)
foreach($sitio in $sitios.configuration.'system.applicationHost'.sites.site)
{

	Write-Host "site name  :" $sitio.name
	<# Write-Host ''#>
	while ($sitio.bindind.binding) {
		Write-Host "protocol  :" $sitio.protocol
		Write-Host "url :" $sitio.bindingInformation
		
	}
}

