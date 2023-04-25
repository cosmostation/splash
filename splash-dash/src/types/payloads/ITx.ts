import { IAmount } from './common/IAmount';
import { IMessageData } from './common/ITxMessage';

// TODO: not use yet. because not support sui tx
export interface ITx {
  hash: string;
  success: boolean;
  version: string;
  gas_used: string;
  gas_unit_price?: string;
  type: string;
  timestamp: number;
  vm_status: string;
  sequence_number?: string;
  epoch?: string;
  round?: string;
  proposer?: string;
  max_gas_amount?: string;
  state_change_hash: string;
  event_root_hash: string;
  accumulator_root_hash: string;
  fee?: IAmount;
  from?: string;
  to?: string;
  amount?: IAmount;
  payload?: IMessageData;
  events?: IMessageData[];
  changes?: IMessageData[];
}

export interface ITxsPayload {
  txs: ITx[];
}
