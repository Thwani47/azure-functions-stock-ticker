using Microsoft.AspNetCore.SignalR;

public class StockTrackerHub : Hub
{
    public void SendMessage(string message)
    {
        Clients.All.SendAsync("message", message);
    }
}