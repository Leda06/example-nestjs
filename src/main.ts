import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

const port = process.env.PORT || 3000;
const envToDisplay = process.env.ENV_TO_DISPLAY || 'no env' ;
console.log(`Launching NestJS app on port ${port}, URL: http://0.0.0.0:${port}, ENV: ${envToDisplay}`);

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(port);
}
bootstrap();
