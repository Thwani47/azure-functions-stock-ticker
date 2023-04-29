. .\Variables.ps1

# Get Storage account connection string
Write-Host "Azure Storage Account Connection String: "
az storage account show-connection-string --name $storageAccountName --resource-group $resourceGroup --query connectionString -o tsv

Write-Host "`n`nAzure Cosmos Database Connection string"
az cosmosdb keys list --name $azureCosmosAccountName --resource-group $resourceGroup --type connection-strings --query 'connectionStrings[0].connectionString' -o tsv

Write-Host "`n`nSignalR Service Connection String"
az signalr key list --name $signalRSvc  --resource-group $resourceGroup --query primaryConnectionString -o tsv