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

# create azure cosmos db account
az cosmosdb create --name $azureCosmosAccountName --resource-group $resourceGroup --backup-redundancy Local

# create azure cosmos database
az cosmosdb database create --db-name $azureCosmosDatabase --name $azureCosmosAccountName --resource-group $resourceGroup

# create azure cosmos database container
az cosmosdb collection create --collection-name $container --db-name $azureCosmosDatabase --name $azureCosmosAccountName --resource-group $resourceGroup --partition-key-path partitionKey

$cosmosDbConnectionString = az cosmosdb keys list --name $azureCosmosAccountName --resource-group $resourceGroup --type connection-strings --query 'connectionStrings[0].connectionString' -o tsv
az cosmosdb  database create --account-name $azureCosmosAccountName --resource-group $resourceGroup --name $azureCosmosDatabase
az functionapp config appsettings set --name $functionAppName --resource-group $resourceGroup --settings CosmosDbConnectionString=$cosmosDbConnectionString