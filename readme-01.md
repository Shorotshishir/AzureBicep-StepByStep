# Readme 01

## creation of bicep file.

- named `deploy.bicep`

## Create a resource group.
  
- set `targetscope` to `'subscription'`
- add a `parameter` named `location`
  - set the value of the parameter to `japaneast` (current location)

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
