import {
  ConnectedSocket,
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
})
export class RealtimedataGateway {
  @WebSocketServer() server: Server;

  handleConnection(client: Socket) {
    console.log('Connected to real time data gateway: ' + client.id);
  }

  handleDisconnect(client: Socket) {
    console.log('Disconnected from real time data gateway: ' + client.id);
  }

  @SubscribeMessage('message')
  handleMessage(
    @MessageBody() payload: any,
    @ConnectedSocket() client: Socket,
  ): void {
    console.log('Client message: ', payload);

    client.emit('message', 'hello from emit gateway');
  }

  @SubscribeMessage('continuos_message')
  handleContinuosMessage(
    @MessageBody() payload: any,
    @ConnectedSocket() client: Socket,
  ): void {
    console.log('Client message: ', payload);
    let counter = 0;
    setInterval(() => {
      client.emit('message', counter++);
    }, 1000);
  }
}
