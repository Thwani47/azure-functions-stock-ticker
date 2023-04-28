$resourceGroup = "azure-functions-stock-ticker-rg";
$functionAppName = "afstfunctionapp"


if (!(Test-Path ".\deploy")) {
    New-Item -ItemType Directory -Path .\deploy
}

# build application
dotnet build .\src\StockTickerFunc\StockTickerFunc.csproj

# publish api 
dotnet publish .\src\StockTickerFunc\StockTickerFunc.csproj --no-restore -o .\deploy\$functionAppName

Compress-Archive -Path .\deploy\$functionAppName\* -DestinationPath .\deploy\$functionAppName.zip -Force

# ZIP deploy the function app
az functionapp deployment source config-zip --resource-group $resourceGroup  --name $functionAppName  --src .\deploy\$functionAppName.zip
az functionapp cors add --resource-group $resourceGroup --name $functionAppName --allowed-origins 'https://azure-app-to-app-auth-demo-client.azurewebsites.net'