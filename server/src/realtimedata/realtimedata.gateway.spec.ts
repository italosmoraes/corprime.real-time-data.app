import { Test, TestingModule } from '@nestjs/testing';
import { RealtimedataGateway } from './realtimedata.gateway';

import { io as socketio } from 'socket.io-client';
import { INestApplication } from '@nestjs/common';
import { Socket } from 'socket.io-client';
import { AppModule } from '../../src/app.module';
import { AppController } from '../../src/app.controller';
import { AppService } from '../../src/app.service';
import { Server } from 'socket.io';

xdescribe('RealtimedataGateway', () => {
  let gateway: RealtimedataGateway;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [RealtimedataGateway],
    }).compile();

    gateway = module.get<RealtimedataGateway>(RealtimedataGateway);
  });

  it('should be defined', () => {
    expect(gateway).toBeDefined();
  });
});

describe('RealtimedataGateway e2e', () => {
  let app: INestApplication;
  let testSocket: Socket;
  let server: Server;

  beforeAll(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [RealtimedataGateway],
    }).compile();

    app = module.createNestApplication();
    await app.init();

    await app.listen(3000);
  });

  beforeEach(async () => {
    testSocket = socketio('http://localhost:3000', {
      transports: ['websocket'],
    });

    await new Promise((resolve) => {
      testSocket.on('error', (error) => {
        console.log(error);
        testSocket.disconnect();
      });
      testSocket.on('connect_error', (error) => {
        console.log(error);
        testSocket.disconnect();
      });

      testSocket.on('message', (data) => {
        console.log('test message received:', data);
      });
      testSocket.on('connect', () => {
        console.log('Connected to test websocket');
        resolve(true);
      });
      return true;
    });
  });

  it('should receive messages from the gateway socket', async () => {
    expect(testSocket.connected).toBe(true);

    testSocket.emit('message', 'hello from client');

    testSocket.on('message', (data) => {
      console.log(data);
      expect(data).toBe('hello from emit gateway');
    });

    await new Promise(async (resolve) => {
      testSocket.emit('message', 'hello from client');
      resolve(true);
    });

    await new Promise((resolve) => {
      testSocket.on('message', (data) => {
        console.log(data);
        expect(data).toBe('hello from emit gateway');
        resolve(true);
      });
      return true;
    });
  });

  afterEach(() => {
    testSocket.disconnect();
  });

  afterAll(async () => {
    await app.close();
  });
});
