import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MarketDataService } from './alpaca-marketdata/alpacaMarketdata.service';

describe('AppController', () => {
  let appController: AppController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
      providers: [AppService, MarketDataService],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('controllers', () => {
    it('should return healthy', () => {
      expect(appController.healthCheck()).toBe('Nestjs server healthy!');
    });
  });
});
