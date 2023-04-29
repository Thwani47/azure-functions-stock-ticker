import * as signalr from "@microsoft/signalr";

const URL = import.meta.env.VITE_HUB_ADDRESS ?? "https://localhost:5001/hub";

class Connector {
  private connection: signalr.HubConnection;
  public events: (onMessageReceived: (message : unknown) => void) => void;
  static instance: Connector;

  constructor() {
    this.connection = new signalr.HubConnectionBuilder()
      .withUrl(URL, {
        skipNegotiation : true,

      })
      .withAutomaticReconnect()
      .build();
    this.connection.start().catch((err) => console.log(err));
    this.events = (onMessageReceived) => {
        this.connection.on('message', (message ) => {
            onMessageReceived(message);
        })
    }
  }

  public static getInstance() : Connector {
    if (!Connector.instance){
        Connector.instance = new Connector();
    }
    return Connector.instance;
  }
}

export default Connector.getInstance