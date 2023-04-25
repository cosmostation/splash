import AbstractChain from './AbstractChain';

abstract class DataSerialization {
  protected readonly chain: AbstractChain;

  constructor({ chain }) {
    this.chain = chain;
  }

  parseAccount(data: any): any {
    return;
  }

  parseTxs(data: any): any {
    return;
  }
}

export default DataSerialization;
