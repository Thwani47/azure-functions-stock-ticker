$projectName = "azure-functions-stock-ticker"
$resourceGroup = "$projectName-rg";
$location = "eastus";
$appServicePlan = "$projectName-sp"
$appService = "$projectName-webapp"

az group create --name $resourceGroup --location $location

az appservice plan create --name $appServicePlan --resource-group $resourceGroup --sku free

az webapp create --name $appService --resource-group $resourceGroup --plan $appServicePlan
az webapp config appsettings set --name $appService --resource-group $resourceGroup --settings  WEBSITE_NODE_DEFAULT_VERSION="~16"
az webapp config set --name $appService --resource-group $resourceGroup --startup-file "pm2 serve /home/site/wwwroot/ --spa --no-daemon"
