targetScope = 'resourceGroup'

@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('name of the resource')
param name string = 'iothub1'

@description('sku of the resource')
param skuname string = 'F1'

@description('sku of the resource')
param skucapacity int = 1

resource iothub 'Microsoft.Devices/IotHubs@2021-07-02' = {
  location: location
  name: '${name}-${uniqueString(resourceGroup().id)}'
  sku: {
    capacity: skucapacity
    name:skuname
  }
}
