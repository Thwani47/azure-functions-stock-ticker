import * as signalr from "@microsoft/signalr";

export const getConnection = (url : string, token : string) : Connector => {
  const connection = Connector.getInstance(url, token);
  return connection;
}

export class Connector {
  private connection: signalr.HubConnection;
  public events: (onMessageReceived: (message: unknown) => void) => void;
  static instance: Connector;

  constructor(url: string, accessToken: string) {
    this.connection = new signalr.HubConnectionBuilder()
      .withUrl(url, {
        accessTokenFactory: () => accessToken,
        skipNegotiation: true,
        transport: signalr.HttpTransportType.WebSockets
      })
      .withAutomaticReconnect()
      .build();

    this.connection
      .start()
      .then(() => console.log("Connected to the signalr service"))
      .catch((err) => console.log(err));

    this.events = (onMessageReceived) => {
      this.connection.on("broadcast", (message) => {
        onMessageReceived(message);
      });
    };
  }

  public static getInstance(url : string, accessToken : string): Connector {
    if (!Connector.instance) {
      Connector.instance = new Connector(url, accessToken);
    }
    return Connector.instance;
  }
}
