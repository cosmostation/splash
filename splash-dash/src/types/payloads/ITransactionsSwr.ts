// TODO: not use yet. because not support sui tx
export class Payload {
  arguments: string[];
  function: string;
  type: 'entry_function_payload' | 'script_payload';
  type_arguments: string[];
}

export class ChangeData<T = unknown> {
  type: string;
  data: T;
}

export class Changes<T = unknown> {
  address: string;
  data: ChangeData<T>;
  state_key_hash: string;
  handle?: string;
  key?: string;
  type: 'write_resource' | 'write_table_item' | 'write_module' | 'delete_table_item' | 'delete_resource';
}

export class WriteTableItemChange extends Changes {
  type: 'write_table_item';
  value: string;
}

export class Events<T = unknown> {
  type: string;
  sequence_number: string;
  data: T;
  guid: {
    account_address: string;
    creation_number: string;
  };
}

export class StateCheckpointTransactionPayload {
  accumulator_root_hash: string;
  changes: [];
  event_root_hash: string;
  gas_used: string;
  hash: string;
  state_change_hash: string;
  state_checkpoint_hash: string;
  success: boolean;
  timestamp: string;
  type: 'state_checkpoint_transaction';
  version: string;
  vm_status: string;
  moduleValue?: string[];
}

export class BlockMetadataTransactionPayload {
  accumulator_root_hash: string;
  changes: Changes[];
  epoch: string;
  event_root_hash: string;
  events: Events[];
  failed_proposer_indices: number[];
  gas_used: string;
  hash: string;
  id: string;
  previous_block_votes_bitvec: number[];
  proposer: string;
  round: string;
  state_change_hash: string;
  state_checkpoint_hash: null;
  success: boolean;
  timestamp: string;
  type: 'block_metadata_transaction';
  version: string;
  vm_status: string;
  moduleValue?: string[];
}

export class UserTransactionPayload {
  accumulator_root_hash: string;
  changes: Changes[];
  event_root_hash: string;
  events: Events[];
  expiration_timestamp_secs: string;
  gas_unit_price?: string;
  gas_used: string;
  hash: string;
  max_gas_amount: string;
  payload: Payload;
  sender: string;
  sequence_number: string;
  signature: {
    public_key: string;
    signature: string;
    type: string;
  };
  state_change_hash: string;
  state_checkpoint_hash: null;
  success: boolean;
  timestamp: string;
  type: 'user_transaction';
  version: string;
  vm_status: string;
  moduleValue?: string[];
}

export interface IPayload {
  function: string;
  arguments: unknown[];
  type_arguments: unknown[];
  type: string;
}

export type ITranscationsProps =
  | StateCheckpointTransactionPayload
  | BlockMetadataTransactionPayload
  | UserTransactionPayload;

export interface ITransaction {
  transaction: ITranscationsProps;
}

export interface ITransactions {
  transactions: ITranscationsProps[];
  totalCount: string;
  searchAfter?: string;
}
