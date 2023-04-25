import { Requester } from '../Requester';

export class SuiRequester extends Requester {
  constructor({ host }) {
    super({ host });
  }

  getCallSuiPostUrl(): string {
    return this.makeUrl('');
  }
}
