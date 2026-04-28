param location string = 'westus'

// 1. Create the HUB Network
module hubVnet './modules/vnet.bicep' = {
  name: 'hubDeployment'
  params: {
    vnetName: 'vnet-hub-prod-001'
    location: location
    vnetAddressPrefix: '10.0.0.0/16'
    subnetName: 'snet-hub-shared'
    subnetAddressPrefix: '10.0.1.0/24'
  }
}

// 2. Create the BANKING Spoke
module bankingSpoke './modules/vnet.bicep' = {
  name: 'bankingDeployment'
  params: {
    vnetName: 'vnet-spoke-banking-001'
    location: location
    vnetAddressPrefix: '10.1.0.0/16'
    subnetName: 'snet-banking-apps'
    subnetAddressPrefix: '10.1.1.0/24'
    networkSecurityGroupId: spokeNsg.outputs.nsgId // Passing the NSG ID here
  }
}

// 3. Create the PAYROLL Spoke
module payrollSpoke './modules/vnet.bicep' = {
  name: 'payrollDeployment'
  params: {
    vnetName: 'vnet-spoke-payroll-001'
    location: location
    vnetAddressPrefix: '10.2.0.0/16'
    subnetName: 'snet-payroll-data'
    subnetAddressPrefix: '10.2.1.0/24'
    networkSecurityGroupId: spokeNsg.outputs.nsgId // Passing the NSG ID here
  }
}

// 4. Peer HUB to BANKING
module hubToBanking './modules/peering.bicep' = {
  name: 'hubToBankingPeering'
  params: {
    localVnetName: hubVnet.outputs.vnetName // Output from your Hub module
    remoteVnetName: bankingSpoke.outputs.vnetName
    remoteVnetId: bankingSpoke.outputs.vnetId
  }
  //dependsOn: [ hubVnet, bankingSpoke ]
}

// 5. Peer BANKING back to HUB
module bankingToHub './modules/peering.bicep' = {
  name: 'bankingToHubPeering'
  params: {
    localVnetName: bankingSpoke.outputs.vnetName
    remoteVnetName: hubVnet.outputs.vnetName
    remoteVnetId: hubVnet.outputs.vnetId
  }
  //dependsOn: [ hubVnet, bankingSpoke ]
}

// 6. Peer HUB to PAYROLL
module hubToPayroll './modules/peering.bicep' = {
  name: 'hubToPayrollPeering'
  params: {
    localVnetName: hubVnet.outputs.vnetName // Output from your Hub module
    remoteVnetName: payrollSpoke.outputs.vnetName
    remoteVnetId: payrollSpoke.outputs.vnetId
  }
  //dependsOn: [ hubVnet, payrollSpoke ]
}

// 5. Peer PAYROLL back to HUB
module payrollToHub './modules/peering.bicep' = {
  name: 'payrollToHubPeering'
  params: {
    localVnetName: payrollSpoke.outputs.vnetName
    remoteVnetName: hubVnet.outputs.vnetName
    remoteVnetId: hubVnet.outputs.vnetId
  }
  //dependsOn: [ hubVnet, payrollSpoke ]
}

// 6. Create the NSG for the Spokes
module spokeNsg './modules/nsg.bicep' = {
  name: 'spokeNsgDeployment'
  params: {
    nsgName: 'nsg-spokes-prod-001'
    location: location
  }
}

