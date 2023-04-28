. .\Variables.ps1

# Get Storage account connection string
Write-Host "Azure Storage Account Connection String: "
az storage account show-connection-string --name $storageAccountName --resource-group $resourceGroup --query connectionString -o tsv
