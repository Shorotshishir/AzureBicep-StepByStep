targetScope = 'subscription'

@description('Specifies the location for resources.')
param location string = 'japaneast'

resource azbicepresourcegroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'azbicep-dev-japaneast-rg1'
  location: location
}

module module_iothub 'module/iothub.bicep' = {
  scope: azbicepresourcegroup
  name: 'azbicep-dev-japaneast-iothub1'
  params: {
    location: azbicepresourcegroup.location
  }
}

module modeule_adt 'module/adt.bicep' = {
  scope: azbicepresourcegroup
  name: 'azbicep-dev-japaneast-adt'
  params: {
    location: azbicepresourcegroup.location
  }
}

module module_function 'module/functions.bicep' = {
  scope: azbicepresourcegroup
  name: 'azbicep-dev-japaneast-func'
  params: {
    location: azbicepresourcegroup.location
  }
}
