import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { RealtimedataGateway } from './realtimedata/realtimedata.gateway';
import { MarketDataService } from './alpaca-marketdata/alpacaMarketdata.service';
import { BinanceDataStreamGateway } from './binance-data-stream/binanceDataStream.gateway';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [
    AppService,
    RealtimedataGateway,
    MarketDataService,
    BinanceDataStreamGateway,
  ],
})
export class AppModule {}
