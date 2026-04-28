// These MUST exist at the top for the main.bicep to "see" them
param vnetName string
param location string
param vnetAddressPrefix string
param subnetName string
param subnetAddressPrefix string

param networkSecurityGroupId string = '' // New parameter

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [vnetAddressPrefix]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          // This line attaches the NSG if one is provided
          networkSecurityGroup: empty(networkSecurityGroupId) ? null : {
            id: networkSecurityGroupId
          }
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
