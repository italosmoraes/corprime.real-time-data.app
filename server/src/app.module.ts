import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { RealtimedataGateway } from './realtimedata/realtimedata.gateway';
import { BinanceDataStreamGateway } from './binance-data-stream/binanceDataStream.gateway';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService, RealtimedataGateway, BinanceDataStreamGateway],
})
export class AppModule {}
