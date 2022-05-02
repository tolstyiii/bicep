@description('Environment name')
param envName string

@description('Key Vault sku')
param kvSKU string = 'Standard'

@secure()
param linuxAdminUsername string

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAUcyupgH azureuser@linuxvm\'')
@secure()
param sshRSAPublicKey string

var sharedVariables = json(loadTextContent('./variables.json'))

var kvName = '${toLower(envName)}-${toLower(sharedVariables.keyVaultName)}'

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: kvName
  location: sharedVariables.location
  properties: {
    createMode: 'default'
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    provisioningState: 'Succeeded'
    sku: {
      family: 'A'
      name: kvSKU
    }
    accessPolicies: [
      {
        objectId: sharedVariables.adminID
        permissions: {
          certificates: [
            'all'
          ]
          keys: [
            'all'
          ]
          secrets: [
            'all'
          ]
          storage: [
            'all'
          ]
        }
        tenantId: sharedVariables.tenantID
      }
    ]
    tenantId: sharedVariables.tenantID
  }
}

resource symbolicname 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: sharedVariables.kvSecretName
  parent: keyVault
  properties: {
    value: sharedVariables.sshPublicKey
  }
}
