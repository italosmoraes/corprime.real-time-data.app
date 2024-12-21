import { Injectable } from '@nestjs/common';
import Alpaca from '@alpacahq/alpaca-trade-api';

console.log(require('@alpacahq/alpaca-trade-api'));
// Alpaca() requires the API key and sectret to be set, even for crypto
const alpaca = new Alpaca({
  keyId: process.env.ALPACA_API_KEY,
  secretKey: process.env.ALPACA_API_SECRET,
});

@Injectable()
export class MarketDataService {
  getMarketData(): string {
    return 'Market data';
  }

  async getMarketDataFromAlpaca(): Promise<string> {
    let options = {
      start: '2022-09-01',
      end: '2022-09-07',
      timeframe: alpaca.newTimeframe(1, alpaca.timeframeUnit.DAY),
    };

    const bars = await alpaca.getCryptoBars(['BTC/USD'], options);

    console.table(bars.get('BTC/USD'));

    bars.get('BTC/USD').forEach((bar) => {
      console.log(bar);
    });

    return bars.get('BTC/USD').toString();
  }
}
