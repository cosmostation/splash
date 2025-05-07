import * as functions from 'firebase-functions';
import { Connection, JsonRpcProvider, TransactionBlock } from '@mysten/sui.js';
import { Transaction } from '@mysten/sui/transactions';
import { SuiClient } from '@mysten/sui/client';
import { IotaClient } from '@iota/iota-sdk/client';
import { Transaction as IotaTransaction } from '@iota/iota-sdk/transactions';
import { IOTA_SYSTEM_STATE_OBJECT_ID } from '@iota/iota-sdk/utils';

const bytesToHex = (bytes: Uint8Array): string => {
  return Buffer.from(bytes).toString('hex');
};

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
export const buildSuiTransactionBlock = functions.https.onRequest(async (request, response) => {
  const connection = new Connection({ fullnode: request.body.rpc });
  const provider = new JsonRpcProvider(connection);
  const txBlock = TransactionBlock.from(request.body.txBlock);
  txBlock.setSenderIfNotSet(request.body.address);
  const build = await txBlock.build({ provider, onlyTransactionKind: false });
  response.send(bytesToHex(build));
});

export const buildSuiTransaction = functions.https.onRequest(async (request, response) => {
  const client = new SuiClient({ url: request.body.rpc });

  const txBlock = Transaction.from(request.body.txBlock);
  txBlock.setSenderIfNotSet(request.body.address);

  const build = await txBlock.build({ client, onlyTransactionKind: false });

  response.send(bytesToHex(build));
});

export const buildStakingRequest = functions.https.onRequest(async (request, response) => {
  const connection = new Connection({ fullnode: request.body.rpc });
  const provider = new JsonRpcProvider(connection);
  const tx = new TransactionBlock();
  const stakeCoin = tx.splitCoins(tx.gas, [tx.pure(request.body.amount)]);
  tx.moveCall({
    target: '0x3::sui_system::request_add_stake',
    arguments: [tx.object('0x0000000000000000000000000000000000000005'), stakeCoin, tx.pure(request.body.validatorAddress)],
  });
  tx.setSenderIfNotSet(request.body.address);
  const build = await tx.build({ provider });
  response.send(bytesToHex(build));
});

export const buildUnstakingRequest = functions.https.onRequest(async (request, response) => {
  const connection = new Connection({ fullnode: request.body.rpc });
  const provider = new JsonRpcProvider(connection);
  const tx = new TransactionBlock();
  tx.moveCall({
    target: '0x3::sui_system::request_withdraw_stake',
    arguments: [tx.object('0x0000000000000000000000000000000000000005'), tx.object(request.body.objectId)],
  });
  tx.setSenderIfNotSet(request.body.address);
  const build = await tx.build({ provider });
  response.send(bytesToHex(build));
});

export const buildIotaStakingRequest = functions.https.onRequest(async (request, response) => {
  const client = new IotaClient({ url: request.body.rpc });

  const tx = new IotaTransaction();

  const rawAmount = request.body.amount;
  if (rawAmount === undefined || rawAmount === null) {
    response.status(400).send('Missing staking amount');
    return;
  }

  let stakingAmount: bigint;
  try {
    stakingAmount = BigInt(rawAmount);
  } catch (err) {
    response.status(400).send('Invalid staking amount');
    return;
  }

  const stakeCoin = tx.splitCoins(tx.gas, [stakingAmount]);

  if (!request.body.validatorAddress) {
    response.status(400).send('Missing validator address');
    return;
  }

  tx.moveCall({
    target: '0x3::iota_system::request_add_stake',
    arguments: [
      tx.sharedObjectRef({
        objectId: IOTA_SYSTEM_STATE_OBJECT_ID,
        initialSharedVersion: 1,
        mutable: true,
      }),
      stakeCoin,
      tx.pure.address(request.body.validatorAddress),
    ],
  });

  if (!request.body.address) {
    response.status(400).send('Missing sender address');
    return;
  }

  tx.setSenderIfNotSet(request.body.address);

  const build = await tx.build({ client });
  response.send(bytesToHex(build));
});

export const buildIotaUnstakingRequest = functions.https.onRequest(async (request, response) => {
  const client = new IotaClient({ url: request.body.rpc });

  const tx = new IotaTransaction();
  tx.moveCall({
    target: '0x3::iota_system::request_withdraw_stake',
    arguments: [tx.object(IOTA_SYSTEM_STATE_OBJECT_ID), tx.object(request.body.objectId)],
  });

  tx.setSenderIfNotSet(request.body.address);
  const build = await tx.build({ client });
  response.send(bytesToHex(build));
});

export const buildIotaTransaction = functions.https.onRequest(async (request, response) => {
  const client = new IotaClient({ url: request.body.rpc });

  const txBlock = IotaTransaction.from(request.body.txBlock);
  txBlock.setSenderIfNotSet(request.body.address);

  const build = await txBlock.build({ client, onlyTransactionKind: false });

  response.send(bytesToHex(build));
});
