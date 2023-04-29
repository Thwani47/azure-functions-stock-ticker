using System;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using StockTickerFunc.Models;

namespace StockTickerFunc
{
    public class StockPriceTrackerFunc
    {
        [FunctionName("StockPriceTrackerFunc")]
        public async Task Run([TimerTrigger("* * * * *")] TimerInfo myTimer, [CosmosDB(
        databaseName: "stock-ticker",
        containerName: "stockprices",
        Connection = "CosmosDbConnectionString")]IAsyncCollector<dynamic> documentsOut, ILogger log, ExecutionContext context)
        {
            var ts = DateTime.Now;
            var previousQuote = new Quote
            {
                CurrentPrice = Double.MinValue
            };

            var config = new ConfigurationBuilder()
            .SetBasePath(context.FunctionAppDirectory)
            .AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
            .AddEnvironmentVariables().Build();

            var apiKey = config["APIKey"];
            log.LogInformation(apiKey);
            using (var client = new HttpClient())
            {
                var response = await client.GetAsync($"https://finnhub.io/api/v1/quote?symbol=AAPL&token={apiKey}");
                var jsonResponse = await response.Content.ReadAsStringAsync();

                var quote = JsonConvert.DeserializeObject<Quote>(jsonResponse);

                if (quote.CurrentPrice != previousQuote.CurrentPrice)
                {
                    log.LogInformation($"{quote.CurrentPrice} {previousQuote.CurrentPrice}");
                    await documentsOut.AddAsync(new 
                    {
                         id = Guid.NewGuid().ToString(),
                         timestamp = ts.ToString(),
                         quote = JsonConvert.SerializeObject(quote)
                    });
                }

                previousQuote = quote;
            }
            log.LogInformation($"C# Timer trigger function executed at: {ts}");
        }
    }
}
