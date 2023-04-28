# azure-functions-stock-ticker
A demo of using React and Azure Functions to track display "real-time" stock data

## Architecure
![architecture](/assets/architecture.png)

## Deploying to Azure

```bash
$> az login
$> ./scripts/CreateResources.ps1
$> ./scripts/BuildAndDeployWebApp.ps1
$> ./scripts/BuildAndDeployFunctionApp.ps1
```

## Cleanup
Run the following command to cleanup resources
```bash
$> ./scripts/Cleanup.ps1
```