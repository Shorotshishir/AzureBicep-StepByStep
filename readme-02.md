# Readme 02

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

## Create a IoT hub service inside the resource group

### Update `deploy.bicep`

- add a module name it `module_iothub` path should be `module/iothub.bicep`
  - scope : within the resource group, thus, previously created resource group.
  - name : `name-of -the-module`. note this is NOT the name of the iothub. this name is for this module only, which will encapsulate the iothub resource.
  - location : pass the value of the resourcegroup's location to this parameter.

### Adding `iothub.bicep`

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