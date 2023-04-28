$resourceGroup = "azure-functions-stock-ticker-rg";
$appName = "azure-functions-stock-ticker-webapp";

if (!(Test-Path ".\deploy")){
    New-Item -ItemType Directory -Path .\deploy
}

$currentLocation = Get-Location
Set-Location .\src\stock-ticker-web

# install packages
npm i

# build project
npm run build

# Create build artifacts archive
Compress-Archive -Path .\dist\* -DestinationPath ..\..\deploy\$appName.zip -Force

# CD to root directory
Set-Location $currentLocation

# Deploy
az webapp deploy --resource-group $resourceGroup --name $appName --src-path .\deploy\$appName.zip --type zip --async true