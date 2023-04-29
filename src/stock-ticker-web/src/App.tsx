import { useEffect } from "react";
import "./App.css";
import Connector from "./signalRConnection";
function App() {
  const { events } = Connector();

  useEffect(() => {
    events((message) => console.log(message));
  })

  return <h1 className="text-2xl font-bold">Hello World</h1>;
}

export default App;
