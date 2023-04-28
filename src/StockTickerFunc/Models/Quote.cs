using Newtonsoft.Json;

namespace StockTickerFunc.Models
{
    public class Quote
    {
        [JsonProperty("c")]
        public double CurrentPrice {get; set;}

        [JsonProperty("h")]
        public double DayHighPrice {get; set;}

        [JsonProperty("l")]
        public double DayLowPrice {get; set;}

         [JsonProperty("o")]
        public double DayOpenPrice {get; set;}

         [JsonProperty("pc")]
        public double PreviousClosePrice {get; set;}
    }
}