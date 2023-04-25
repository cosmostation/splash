import { IPayload, ITranscationsProps } from 'src/types/payloads/ITransactionsSwr';
import { includes, isUndefined } from 'lodash';

import { IAmount } from 'src/types/payloads/common/IAmount';
import { ITx } from 'src/types/payloads/ITx';
import { TxParser } from './TxParser';
import { multiply } from 'src/util/big';
import { splitTimeStamp } from 'src/function/formatNumber';

// TODO: not use yet. because not support sui tx
const checkType = ['0x1::aptos_account::transfer', '0x1::coin::transfer'];

export class TxParserV1 extends TxParser {
  parsePayload(payload?: IPayload): IPayload | undefined {
    if (isUndefined(payload)) {
      return undefined;
    }

    return payload;
  }

  getAmount(payload?: IPayload): IAmount | undefined {
    if (isUndefined(payload)) {
      return undefined;
    }

    if (includes(checkType, payload.function)) {
      return {
        amount: payload.arguments[1] as string,
        denom: 'apt',
      };
    }

    return undefined;
  }

  getToAddress(payload?: IPayload): string | undefined {
    if (isUndefined(payload)) {
      return undefined;
    }

    if (includes(checkType, payload.function)) {
      return payload.arguments[0] as string;
    }

    const splitFunctionTo = payload.function?.split('::')[0];

    return splitFunctionTo;
  }

  getParsedTx(transaction: ITranscationsProps): ITx {
    const parsingTx = {
      hash: transaction.hash,
      success: transaction.success,
      version: transaction.version,
      gas_used: transaction.gas_used,
      type: transaction.type,
      timestamp: splitTimeStamp(transaction.timestamp),
      vm_status: transaction.vm_status,
      state_change_hash: transaction.state_change_hash,
      event_root_hash: transaction.event_root_hash,
      accumulator_root_hash: transaction.accumulator_root_hash,
      changes: transaction?.changes
        ? transaction.changes.map((e) => {
            return this.msgParser.changesParse(e);
          })
        : [],
    };

    if (transaction.type === 'user_transaction') {
      return {
        ...parsingTx,
        gas_unit_price: transaction?.gas_unit_price,
        sequence_number: transaction.sequence_number,
        max_gas_amount: transaction.max_gas_amount,
        from: transaction.sender,
        to: this.getToAddress(transaction?.payload),
        amount: this.getAmount(transaction?.payload),
        fee: {
          amount: multiply(transaction?.gas_unit_price || 0, transaction.gas_used),
          denom: 'apt',
        },
        payload: this.msgParser.payloadParse(transaction?.payload, transaction?.moduleValue),
        events: transaction?.events
          ? transaction.events.map((e) => {
              return this.msgParser.eventsParse(e);
            })
          : [],
      };
    } else if (transaction.type === 'block_metadata_transaction') {
      return {
        ...parsingTx,
        epoch: transaction.epoch,
        round: transaction.round,
        proposer: transaction.proposer,
        events: transaction?.events
          ? transaction.events.map((e) => {
              return this.msgParser.eventsParse(e);
            })
          : [],
      };
    }

    return {
      ...parsingTx,
    };
  }
}
