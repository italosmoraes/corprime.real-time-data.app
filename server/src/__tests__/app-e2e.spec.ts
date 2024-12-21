import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { AppModule } from '../app.module';
const request = require('supertest'); // Annoying difference because alpaca uses whatever

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/ (GET)', () => {
    return request(app.getHttpServer())
      .get('/health-check')
      .expect(200)
      .expect('Nestjs server healthy!');
  });

  it('/ (GET)', () => {
    return request(app.getHttpServer())
      .get('/market-data-service')
      .expect(200)
      .expect('Market data');
  });

  it('/ (GET)', () => {
    return request(app.getHttpServer())
      .get('/market-data-from-alpaca')
      .expect(200)
      .expect(Object);
  });
});
