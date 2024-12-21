import { io as socketio } from 'socket.io-client';

export const socket = socketio('http://localhost:3000');

socket.on('connect', () => {
  console.log('Connected');
  socket.emit('datastream', 'Hello from client');
});

socket.on('message', (data) => {
  console.log('message received:', data);
});

socket.on('disconnect', () => {
  console.log('Disconnected');
  socket.emit('disconnect', 'Disconnecting');
});

socket.on('error', (error) => {
  console.log(error);
  socket.disconnect();
});

socket.on('connect_error', (error) => {
  console.log(error);
  socket.disconnect();
});

socket.on('exception', (error) => {
  console.log(error);
  socket.disconnect();
});
