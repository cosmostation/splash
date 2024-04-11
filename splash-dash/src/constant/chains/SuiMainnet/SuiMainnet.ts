import AbstractChain from '../AbstractChain';
import { SuiMsgParser } from './msgParsers/SuiMsgParser';
import { SuiRequester } from 'src/requesters/requester/SuiRequester';
import SuiSerialization from './SuiSerialization';
import { TxParser } from 'src/txParser/TxParser';
import { TxParserV1 } from 'src/txParser/TxParser.v1';
import consts from './constants';

class SuiChain extends AbstractChain {
  readonly txParser: TxParserV1;

  constructor() {
    super({
      ...consts,
      urlRequester: new SuiRequester({ host: consts.apiURL }),
      dataSerialization: new SuiSerialization({ chain: consts.id }),
    });

    this.txParser = new TxParserV1({ chain: this, msgParser: SuiMsgParser });
  }

  getParser(_chainId: string): TxParser {
    return this.txParser;
  }
}

export default SuiChain;
