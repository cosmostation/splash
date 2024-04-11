import { ITxMsgParserProps, TxMsgParser } from 'src/txParser/msgParser/TxMsgParser';

import { ITxMessage } from 'src/types/payloads/common/ITxMessage';
import { changesParser } from './changesParser';
import { eventsParser } from './eventsParser';
import { payloadParser } from './payloadParser';

export class SuiMsgParser extends TxMsgParser {
  constructor({ chain }: ITxMsgParserProps) {
    super({ chain });
  }

  payloadParse(message: ITxMessage, moduleValue?: string[]): any {
    return payloadParser(message, moduleValue);
  }

  eventsParse(message: ITxMessage): any {
    return eventsParser(message);
  }

  changesParse(message: any): any {
    return changesParser(message);
  }
}
