import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { MarketDataService } from './alpaca-marketdata/alpacaMarketdata.service';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly marketDataService: MarketDataService,
  ) {}

  @Get('/health-check')
  healthCheck(): string {
    return this.appService.healthCheck();
  }

  @Get('/market-data-service')
  getMarketData(): string {
    return this.marketDataService.getMarketData();
  }

  @Get('/market-data-from-alpaca')
  async getMarketDataFromAlpaca(): Promise<string> {
    return this.marketDataService.getMarketDataFromAlpaca();
  }
}
