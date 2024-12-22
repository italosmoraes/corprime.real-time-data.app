import {
  ConnectedSocket,
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { log } from 'console';
import { Server, Socket } from 'socket.io';
import WebSocket from 'ws';

@WebSocketGateway({
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
})
export class BinanceDataStreamGateway {
  @WebSocketServer() server: Server;
  @WebSocketServer() socket: Socket;

  handleConnection(client: Socket) {
    console.log('Client connected to binance data stream: ' + client.id);
    this.logNoOfClients();
  }

  handleDisconnect(client: Socket) {
    console.log('Client disconnected from binance data stream: ' + client.id);
    this.logNoOfClients();
  }

  logNoOfClients() {
    console.log('No of connected clients:', this.server.sockets.sockets.size);
  }

  @SubscribeMessage('datastream')
  handleContinuosMessage(
    @MessageBody() payload: any,
    @ConnectedSocket() client: Socket,
  ): void {
    console.log('Client connected: ', client.id);
    console.log('Client message: ', payload);

    // Connect to Binance WebSocket server
    const binanceSocket = new WebSocket('wss://stream.binance.com:9443/ws');

    binanceSocket.on('open', () => {
      console.log('Connected to Binance WebSocket');

      // Subscribe to BTC/USDT trades
      const subscribeMessage = JSON.stringify({
        method: 'SUBSCRIBE',
        params: ['btcusdt@trade'], // Stream name
        id: 1, // Custom request ID
      });

      // Send subscription message
      binanceSocket.send(subscribeMessage);
      console.log('Subscription message sent:', subscribeMessage);
    });

    binanceSocket.on('message', (data) => {
      const message = JSON.parse(data.toString());

      // Binance data format example. TODO make it an interface
      //   {
      //     "e": "trade",
      //     "E": 123456789,    // Event time
      //     "s": "BTCUSDT",    // Symbol
      //     "t": 12345,        // Trade ID
      //     "p": "0.001",      // Price
      //     "q": "100",        // Quantity
      //     "b": 88,           // Buyer order ID
      //     "a": 50,           // Seller order ID
      //     "T": 123456785,    // Trade time
      //     "m": true,         // Market maker
      //     "M": true          // Ignore
      //   }

      const transformed = {
        tradeId: message.t,
        price: message.p,
        quantity: message.q,
        timestamp: message.E,
      };

      client.emit('message', transformed);

      if (!client.connected) {
        client.disconnect();
        binanceSocket.close();
      }
    });

    binanceSocket.on('close', () => {
      console.log('Disconnected from Binance WebSocket');
    });

    binanceSocket.on('error', (error) => {
      console.error('WebSocket Error:', error);
    });
  }
}
