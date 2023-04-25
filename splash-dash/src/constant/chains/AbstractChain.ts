import { ChainType } from 'src/types/chains';

import DataSerialization from './DataSerialization';
import { ITranscationsProps } from 'src/types/payloads/ITransactionsSwr';
import { ITx } from 'src/types/payloads/ITx';
import { MintscanApiRequester } from 'src/requesters/requester/MintscanApiRequester';
import { MovescanApiRequester } from 'src/requesters/requester/MoveApiRequester';
import { SuiRequester } from 'src/requesters/requester/SuiRequester';
import { TxParser } from 'src/txParser/TxParser';

interface IAbstractChainProps extends ChainType {
  dataSerialization: DataSerialization;
  urlRequester: SuiRequester;
}

abstract class AbstractChain {
  readonly dataSerialization: DataSerialization;
  readonly urlRequester: SuiRequester;
  readonly mintscanApiRequester: MintscanApiRequester;
  readonly movescanApiRequester: MovescanApiRequester;

  readonly id: string;
  readonly name: string;
  readonly chainId: string;
  readonly denom: string;
  readonly decimal: number;
  readonly dpDenom: string;
  readonly geckoId: string;
  readonly dashboardTitle: string;
  readonly chainColor: string;
  readonly network: string;
  readonly description?: string;

  constructor({
    id,
    name,
    chainId,
    denom,
    decimal,
    dpDenom,
    geckoId,
    dashboardTitle,
    chainColor,
    network,
    description,
    urlRequester,
    dataSerialization,
  }: IAbstractChainProps) {
    this.id = id;
    this.name = name;
    this.chainId = chainId;
    this.denom = denom;
    this.decimal = decimal;
    this.dpDenom = dpDenom;
    this.geckoId = geckoId;
    this.dashboardTitle = dashboardTitle;
    this.chainColor = chainColor;
    this.network = network;
    this.description = description;

    this.urlRequester = urlRequester;
    this.dataSerialization = dataSerialization;

    this.mintscanApiRequester = new MintscanApiRequester();
    this.movescanApiRequester = new MovescanApiRequester();
  }

  parseTx(txs?: ITranscationsProps[]): ITx[] {
    return (
      txs?.map((tx) => {
        const txParser = this.getParser(this.id);

        return txParser.getParsedTx(tx);
      }) || []
    );
  }

  abstract getParser(chainId: string): TxParser;
}

export default AbstractChain;
