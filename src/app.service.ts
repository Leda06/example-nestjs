import { Injectable } from '@nestjs/common';

const envToDisplay = process.env.ENV_TO_DISPLAY || 'nada' ;

@Injectable()
export class AppService {
  getHello(): string {
    console.log(`ENV: ${envToDisplay}`);
    return `Hello World! This is the env to display ${envToDisplay}`;
  }
}
