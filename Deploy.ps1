param (
    $env='test',
    $location ='germanywestcentral',
    $TemplatesNamesList = @('keyvault','aks')
)

#Deploy Resource group
$rgName = "rg-$env"

New-AzSubscriptionDeployment -location $location -TemplateFile .\rg.bicep -TemplateParameterFile ".\$env.parameters.json" #-WhatIf

#Deploy resources
foreach ($t in $TemplatesNamesList) {
    $deploymentName = $env+$t
    try {
        New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentName -TemplateFile .\$t.bicep -TemplateParameterFile ".\$env.parameters.json" #-WhatIf
    } catch {
        Write-Output $error[0]
        Exit;
    }
}
