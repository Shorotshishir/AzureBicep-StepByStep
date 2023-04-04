targetScope = 'subscription'

@description('Specifies the location for resources.')
param location string = 'japaneast'

resource azbicepresourcegroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'azbicep-dev-japaneast-rg1'
  location: location
}
