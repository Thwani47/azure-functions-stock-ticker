# azure-functions-stock-ticker
A demo of using React and Azure Functions to track display "real-time" stock data

## Architecure
![architecture](/assets/architecture.png)

## Create a Finhubb API Key
Head over to [Finnhub](https://finnhub.io/) and register for a free API key.

## Deploying to Azure

```bash
$> az login
$> cd scripts
$> ./CreateResources.ps1  # you'll be prompted for an API key and enter the one you created above
$> ./BuildAndDeployWebApp.ps1
$> ./BuildAndDeployFunctionApp.ps1
```

## Cleanup
Run the following command to cleanup resources
```bash
$> ./Cleanup.ps1
```