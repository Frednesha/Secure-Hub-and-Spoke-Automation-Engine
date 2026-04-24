param location string

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
  }
}
