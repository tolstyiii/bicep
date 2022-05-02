targetScope = 'subscription'

@description('Prefix to use in the name as first part')
param envName string

@secure()
param linuxAdminUsername string

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAUcyupgH azureuser@linuxvm\'')
@secure()
param sshRSAPublicKey string

var sharedVariables = json(loadTextContent('./variables.json'))

var rgName = '${toLower(sharedVariables.resourceGroupName)}-${toLower(envName)}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: sharedVariables.location
}
