"use client";
import React, { useState, useEffect, useRef } from "react";
import { Socket, io as socketio } from "socket.io-client";
import { Chart } from "./Chart";
import { REAL_TIME_SERVER } from "./constants";

export const RealTimeBinanceData = () => {
  let socket = useRef<Socket | null>(null);

  const [messages, setMessages] = useState<string[]>([]);
  const [isConnected, setIsConnected] = useState(false);
  const [hasDisconnected, setHasDisconnected] = useState(false);
  const [showConnectionError, setShowConnectionError] = useState(false);
  const [connectionError, setConnectionError] = useState<string | null>(null);

  // guarantees only necessary data lives in the FE client
  const dataSetLimit = 50;

  useEffect(() => {
    socket.current = socketio(REAL_TIME_SERVER);

    socket.current.on("connect", () => {
      setConnectionError(null);
      setShowConnectionError(false);
    });

    socket.current.on("connect_error", (error) => {
      console.log(error);
      setConnectionError(error.message);
      setShowConnectionError(true);
      setIsConnected(false);
    });

    socket.current.on("disconnect", () => {
      console.log("Disconnected from the server");
      setIsConnected(false);
      setHasDisconnected(true);
    });

    socket.current.on("message", (message: string) => {
      setMessages((prevMessages) => [
        ...prevMessages.slice(-dataSetLimit),
        message,
      ]);
    });

    return () => {
      if (socket) {
        socket.current?.disconnect();
      }
    };
  }, []);

  const handleConnect = () => {
    if (!isConnected) {
      socket.current?.connect();
      socket.current?.emit("datastream", "Client wants binance data");
      setIsConnected(true);
    } else {
      socket.current?.disconnect();
      setIsConnected(false);
      setHasDisconnected(true);
    }
  };

  return (
    <div>
      <div className="flex items-center justify-center">
        <h1 className="text-sm md:text-lg lg:text-xl py-8">Real-time Data</h1>
      </div>

      <div className="controls-container">
        <button onClick={handleConnect}>
          {isConnected ? "Disconnect" : "Connect"}
        </button>

        {showConnectionError && <p>Connection error. Please, try again.</p>}
        {connectionError && <p>[{connectionError}]</p>}
      </div>

      <div className="charts-container">
        <Chart messages={messages} />
        {/* <Chart messages={messages} />
        <Chart messages={messages} /> */}
      </div>

      <br></br>

      <div className="messages-log shadow-xl ring-1 ring-gray-900/5 sm:rounded-lg text-base leading-7 text-gray-600">
        <div className="flex flex-col items-center justify-center">
          <h3>Connection status: </h3>
          <h4> {(isConnected && <p>Connected</p>) || <p>Not Connected</p>}</h4>
        </div>

        <h3>Message stream log:</h3>
        <div className="text-sm">
          <ul>
            {messages.slice(messages.length - 5).map((message, index) => (
              <li key={index}>{JSON.stringify(message, null, 2)}</li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};
