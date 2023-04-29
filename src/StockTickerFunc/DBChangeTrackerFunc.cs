using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Azure.Documents;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.SignalRService;
using Microsoft.Extensions.Logging;

namespace StockTickerFunc
{
    public static class DBChangeTrackerFunc
    {
        [FunctionName("DBChangeTrackerFunc")]
        public static async Task Run([CosmosDBTrigger(
            databaseName :  "stock-ticker",
            collectionName: "stockprices",
            ConnectionStringSetting = "CosmosDbConnectionString",
            CreateLeaseCollectionIfNotExists = true)]IReadOnlyList<Document> input,
            [SignalR(HubName = "hub")] IAsyncCollector<SignalRMessage> signalRMessages,
            ILogger log)
        {
            if (input != null && input.Count > 0)
            {
                log.LogInformation("Sending document with ID " + input[0].Id);
                await signalRMessages.AddAsync(
                    new SignalRMessage
                    {
                        Target = "broadcast",
                        Arguments = new[] { (input[0]) }
                    });
            }

        }
    }
}
