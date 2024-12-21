"use client";
import React, { useState, useEffect } from "react";
import { Socket, io as socketio } from "socket.io-client";

const REAL_TIME_SERVER = "http://localhost:3000";

export const RealTimeData = () => {
  const [messages, setMessages] = useState<string[]>([]);
  const socket = React.useRef<Socket | null>(null);

  const [isConnected, setIsConnected] = useState(false);
  const [hasDisconnected, setHasDisconnected] = useState(false);

  useEffect(() => {
    socket.current = socketio(REAL_TIME_SERVER);

    socket.current.on("connect", () => {
      console.log("Connected to the server", socket.current?.id);
      setIsConnected(true);
    });

    socket.current.on("connect_error", (error) => {
      console.log(error);
      setIsConnected(false);
    });

    socket.current.on("disconnect", () => {
      console.log("Disconnected from the server");
      setIsConnected(false);
      setHasDisconnected(true);
    });

    socket.current.on("message", (message: string) => {
      setMessages((prevMessages) => [...prevMessages, message]);
    });

    // socket.current.emit("message", "Hello from client");

    socket.current.emit("continuos_message", "Hello from client");

    return () => {
      if (socket.current) {
        socket.current.disconnect();
      }
    };
  }, []);

  return (
    <div>
      <h1>Real-time Data</h1>
      <br></br>
      {(isConnected && <p>Connected</p>) || <p>Not Connected</p>}
      <ul>
        {messages.map((message, index) => (
          <li key={index}>{message}</li>
        ))}
      </ul>
      {hasDisconnected && <p>Disconnected</p>}
    </div>
  );
};
