import AbstractChain from 'src/constant/chains/AbstractChain';
import { IMessageData } from 'src/types/payloads/common/ITxMessage';

export interface ITxMsgParserProps {
  chain: AbstractChain;
}

export interface ITxMsgParserConstructor {
  new (params: ITxMsgParserProps): TxMsgParser;
}

export abstract class TxMsgParser {
  protected readonly chain: AbstractChain;

  constructor({ chain }: ITxMsgParserProps) {
    this.chain = chain;
  }

  abstract payloadParse(message: any, moduleValue?: string[]): IMessageData;
  abstract eventsParse(message: any): IMessageData;
  abstract changesParse(message: any): IMessageData;
}
