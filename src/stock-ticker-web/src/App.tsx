import { useEffect, useState } from "react";
import "./App.css";
import { Connector, getConnection } from "./signalRConnection";
import axios from "axios";

interface Quote {
  id: string;
  _rid: string;
  _self: string;
  _ts: number;
  _etag: string;
  timestamp: string;
  quote: string;
  _lsn: number;
}

function App() {
  const [connection, setConnection] = useState<Connector | null>(null);
  const [quoteData, setQuoteData] = useState<Quote | null>(null);

  useEffect(() => {
    axios
      .get("http://localhost:7071/api/GetConnectionInfo") // TODO change this to url from env variables
      .then((data) => {
        const url = data.data.url;
        const accessToken = data.data.accessToken;

        const instance = getConnection(url, accessToken);
        setConnection(instance);
      })
      .catch((err) => console.log(err));
  }, [connection]);

  useEffect(() => {
    connection?.events((message) => {
      console.log(message);
      const deserializedMessage = message as Quote;
      setQuoteData(deserializedMessage);
    });
  }, [connection]);

  return (
    <div className="App">
      {quoteData ? (
        <div className="card w-auto bg-base-100 shadow-xl mx-auto mt-20">
          <div className="card-body">
            <h2 className="card-title mx-auto font-bold">AAPL Stock Price</h2>
            <div className="stats stats-vertical lg:stats-horizontal shadow">
              <div className="stat">
                <div className="stat-title">Current Price</div>
                <div className="stat-value">
                  {JSON.parse(quoteData.quote).c}
                </div>
              </div>

              <div className="stat">
                <div className="stat-title">Today's High Price</div>
                <div className="stat-value">
                  {JSON.parse(quoteData.quote).h}
                </div>
              </div>

              <div className="stat">
                <div className="stat-title">Today's Low Price</div>
                <div className="stat-value">
                  {JSON.parse(quoteData.quote).l}
                </div>
              </div>
              <div className="stat">
                <div className="stat-title">Today's Open Price</div>
                <div className="stat-value">
                  {JSON.parse(quoteData.quote).o}
                </div>
              </div>
            </div>
          </div>
        </div>
      ) : (
        <h1 className="text-3xl mx-auto">No Data found!</h1>
      )}
    </div>
  );
}

export default App;
