. .\Variables.ps1

az group create --name $resourceGroup --location $location

# Web App Resources
az appservice plan create --name $appServicePlan --resource-group $resourceGroup --sku free
az webapp create --name $appService --resource-group $resourceGroup --plan $appServicePlan
az webapp config appsettings set --name $appService --resource-group $resourceGroup --settings  WEBSITE_NODE_DEFAULT_VERSION="~16"
az webapp config set --name $appService --resource-group $resourceGroup --startup-file "pm2 serve /home/site/wwwroot/ --spa --no-daemon"

# Functions App Resources
az storage account create --name $storageAccountName --location $location --resource-group $resourceGroup --sku Standard_LRS --allow-blob-public-access false
az functionapp create --resource-group $resourceGroup  --consumption-plan-location $location  --runtime dotnet --functions-version 4 --name $functionAppName --storage-account $storageAccountName
$apiKey = Read-Host -Prompt "Enter your Finnhub API Key: "
az functionapp config appsettings set --name $functionAppName --resource-group $resourceGroup --settings APIKey=$apiKey