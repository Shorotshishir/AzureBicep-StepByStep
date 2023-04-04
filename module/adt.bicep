targetScope = 'resourceGroup'

@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('Role definition for ADT data place access')
var ADTroleDefinitionId = resourceId('Microsoft.Authorization/roleDefinitions', 'bcd981a7-7f74-457b-83e1-cceb9e632ffe')

// create Instance of Azure Digital Twins
// with System Assigned identity
resource adt 'Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31' = {
  location: location
  name: 'adt-${uniqueString(resourceGroup().id)}'
  identity: {
    type:'SystemAssigned'
  }
}

// Assign Azure Digital Twins Data Owner Role
resource adtroledef 'Microsoft.Authorization/roleAssignments@2022-04-01' ={
  name: guid('adtroledef',resourceGroup().id)
  properties: {
    roleDefinitionId: ADTroleDefinitionId
    principalId: adt.identity.principalId
  }
}
