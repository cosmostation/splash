import { ITxMsgParserConstructor, TxMsgParser } from './msgParser/TxMsgParser';

import AbstractChain from 'src/constant/chains/AbstractChain';
import { ITranscationsProps } from 'src/types/payloads/ITransactionsSwr';
import { ITx } from 'src/types/payloads/ITx';

interface ITxParserProps {
  chain: AbstractChain;
  msgParser: ITxMsgParserConstructor;
}

export interface ITxParserConstructor {
  new (params: ITxParserProps): TxParser;
}

export abstract class TxParser {
  msgParser: TxMsgParser;

  protected readonly chain: AbstractChain;

  constructor({ chain, msgParser }: ITxParserProps) {
    this.chain = chain;
    this.msgParser = new msgParser({ chain });
  }

  abstract getParsedTx(tx: ITranscationsProps): ITx;
}
