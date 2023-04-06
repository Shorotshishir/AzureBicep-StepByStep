# Readme 04 <!-- omit in toc -->

- [Creation of bicep file](#creation-of-bicep-file)
- [How to deploy](#how-to-deploy)
  - [Using vscode](#using-vscode)
  - [Using terminal](#using-terminal)
- [Create a resource group](#create-a-resource-group)
- [Create Azure Services inside the resource group](#create-azure-services-inside-the-resource-group)
  - [Update `deploy.bicep`](#update-deploybicep)
  - [Adding `iothub.bicep`](#adding-iothubbicep)
    - [Creating IoT Hub Resource](#creating-iot-hub-resource)
  - [Adding `adt.bicep`](#adding-adtbicep)
    - [Creating ADT Resource](#creating-adt-resource)
    - [Creating ADT role definition](#creating-adt-role-definition)
  - [Adding `functions.bicep`](#adding-functionsbicep)
    - [Creating App Insights Resource](#creating-app-insights-resource)
    - [Creating Storage Account Resource](#creating-storage-account-resource)
    - [Creating ServerFarm Resource](#creating-serverfarm-resource)
    - [Creating Azure Functions Resource](#creating-azure-functions-resource)

## Creation of bicep file

- named `deploy.bicep`
- Create a directory. name it module
- Inside the module, create a bicep file. name it `iothub.bicep`

## How to deploy

### Using vscode

- Make sure you are signed in with azure by `Azure Sign In` command. Available if `Azure Account` plugin is installed.
- Right click on deploy.bicep and click `Deploy Bicep File`
- Go through the wizard. without creating a parameter file
- resource will be deployed.

### Using terminal

- Make sure you are logged in with the Azure CLI.

  ```pwsh
  az deployment sub create -l japaneast -f deploy.bicep
  ```

## Create a resource group
  
- set `targetscope` to `'subscription'`
- add a `parameter` named `location`
  - set the value of the parameter to `japaneast` (current location)

## Create Azure Services inside the resource group

### Update `deploy.bicep`

- add a module name it `module_iothub` path should be `module/iothub.bicep`
  - scope : within the resource group, thus, previously created resource group.
  - name : `name-of -the-module`. note this is NOT the name of the iothub. this name is for this module only, which will encapsulate the iothub resource.
  - location : pass the value of the resourcegroup's location to this parameter.

- add a module name it `module_adt` path should be `module/adt.bicep`
  - scope : within the resource group, thus, previously created resource group.
  - name : `name-of-the-module`. note this is NOT the name. this name is for this module only, which will encapsulate the adt
  - location : pass the value of the resourcegroup's location to this parameter

- add a module name it `module_adt` path should be `module/functions.bicep`
  - scope : within the resource group, thus, previously created resource group.
  - name : `name-of-the-module`. note this is NOT the name. this name is for this module only, which will encapsulate the azure function service
  - location : pass the value of the resourcegroup's location to this parameter

### Adding `iothub.bicep`

- create `iothub.bicep` inside `module` directory
- set `targetscope` to `'resourceGroup'`
- add `parameters`
  - `location` : location of the region as string, should be same as the location of the resource group. default should be `resourceGroup().location`.
  - `name` : name of the hub as string [default can be anything, needs to be unique, use `uniqueString()` function to generate a unique string]
  - `skuname` : name parameter of the sku, as string [`sku` is a required property for creating iot hub]. Defines which pricing tier to use. Check official documentation for detail.
  - `skucapacity` : provisioning value for the iot hub as integer.

#### Creating IoT Hub Resource

- 3 required properties for Iot Hub
  - location : location
  - name : name is made unique at the time of creation by using `uniqueString()` function
  - sku
    - capacity : skucapacity
    - name : skuname

> This is a accumulated time in this step where deployment created
>
> - Resource Group
> - Iot Hub
>
> Deployment Duration : ``

### Adding `adt.bicep`

- create `adt.bicep` inside `module` directory
- set `targetscope` to `'resourceGroup'`
- add `parameters`
  - location : location of the region as string, should be same as the location of the resource group. default should be `resourceGroup().location`.
- add variable `ADTroleDefinitionId`
  - set `ADTroleDefinitionId` to `resourceId('Microsoft.Authorization/roleDefinitions', 'bcd981a7-7f74-457b-83e1-cceb9e632ffe')`
  - this will be used to set Ownership permission of Azure Digital Twins Data Plane.

#### Creating ADT Resource

- 2 required properties for ADT
  - location : location
  - name : name is made unique at the time of creation by using `uniqueString()` function
- `identity` object : holds information of the type of identity used for the resource
  - `type` : set to `SystemAssigned` to use system assigned identity for the resource

#### Creating ADT role definition

- Necessary to add role to allow ownership to Azure Digital Twins Data Plane.
- 2 required properties for role definition
  - name : use `guid()` function to generate a unique name for the role
  - properties : 2 required properties
    - roleDefinitionId : use `ADTroleDefinitionId` variable
    - principalId : use the principal id of the identity used for the ADT resource
      - `principalId`:`adt.identity.principalId` 

> This is a accumulated time in this step where deployment created
>
> - Resource Group
> - Iot Hub
> - ADT (with role definition and assignment)
>
> Deployment Duration : `1 minute 50 seconds`

### Adding `functions.bicep`

- create `functions.bicep` inside `module` directory
- set `targetscope` to `'resourceGroup'`
- add `parameters`
  - location : location of the region as string, should be same as the location of the resource group. default should be `resourceGroup().location`.
- add variable `'storageAccountName'`
  - `<unique-name>` using `uniqueString()` function, name can `only be lowercase and number, no special characters`
  - will be used in creating storage and setting functions creating connection string for Azure functions.
- add variable `'functionName'`
  - `<unique-name>` using `uniqueString()` function
  - will be used to create function resource and functions contentshare property

#### Creating App Insights Resource

- Necessary to add monitoring functionality to the functions
- 2 required fields
  - location : location
  - name : `<unique-name>` using `uniqueString()` function
- `kind` : set to `'web'`
- properties :
  - Application_type : `'web'`
  - Request_source : `'rest'`

#### Creating Storage Account Resource

- Necessary to store azure functions scripts
- 2 required fields
  - location : location
  - name : use variable `storageAccountName`
- sku :
  - name : `'Standard_LRS'`
- kind : set to `'Storage'`

#### Creating ServerFarm Resource

- Necessary to host the Azure Functions
- 2 required fields
  - location : location
  - name : name is made unique at the time of creation by using `uniqueString()` function
- sku :
  - name : `'Y1'`
  -tier : `'Dynamic'`


#### Creating Azure Functions Resource

- 2 required properties for Azure Functions
  - location : location
  - name : name is made unique at the time of creation by using `uniqueString()` function
- `identity` object : holds information of the type of identity used for the resource
  - `type` : set to `SystemAssigned` to use system assigned identity for the resource
- properties : Holds the various necessary variables and configuration of the azure function service
  - `siteConfig` : Holds settings for the Azure Functions
    - `serverFarmId` : id of the server farm
    - `appSettings` : Holds various parameter variables

      ```bicep
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
      ```

> This is a accumulated time in this step where deployment created
>
> - Resource Group
> - Iot Hub
> - ADT (with role definition and assignment)
> - Azure Functions (with Azure Storage Account, App Insights, ServerFarm)
>
> Deployment Duration : `1 minute 38 seconds`
