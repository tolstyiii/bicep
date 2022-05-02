@description('Environment name')
param envName string

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@secure()
param linuxAdminName string

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string

@minValue(0)
@maxValue(1023)
@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
param osDiskSizeGB int = 0

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAUcyupgH azureuser@linuxvm\'')
@secure()
param sshRSAPublicKey string

var sharedVariables = json(loadTextContent('./variables.json'))

var aksClusterName = '${toLower(envName)}-${toLower(sharedVariables.clusterName)}'

resource clusterName_resource 'Microsoft.ContainerService/managedClusters@2020-09-01' = {
  name: aksClusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: sharedVariables.agentCount
        vmSize: sharedVariables.agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminName
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}
