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
        public async Task Run([TimerTrigger("* * * * *")] TimerInfo myTimer, ILogger log, ExecutionContext context)
        {
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
                }

                previousQuote = quote;
                log.LogInformation($"No change in price: {quote.CurrentPrice}");
            }
            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");
        }
    }
}
