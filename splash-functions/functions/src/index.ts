import * as functions from "firebase-functions";
import { Connection, JsonRpcProvider, TransactionBlock } from "@mysten/sui.js";
import { Transaction } from "@mysten/sui/transactions";
import { SuiClient } from "@mysten/sui/client";

const bytesToHex = (bytes: Uint8Array): string => {
  return Buffer.from(bytes).toString("hex");
};

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
export const buildSuiTransactionBlock = functions.https.onRequest(
  async (request, response) => {
    const connection = new Connection({ fullnode: request.body.rpc });
    const provider = new JsonRpcProvider(connection);
    const txBlock = TransactionBlock.from(request.body.txBlock);
    txBlock.setSenderIfNotSet(request.body.address);
    const build = await txBlock.build({ provider, onlyTransactionKind: false });
    response.send(bytesToHex(build));
  }
);

export const buildSuiTransaction = functions.https.onRequest(
  async (request, response) => {
    const client = new SuiClient({ url: request.body.rpc });

    const txBlock = Transaction.from(request.body.txBlock);
    txBlock.setSenderIfNotSet(request.body.address);

    const build = await txBlock.build({ client, onlyTransactionKind: false });

    response.send(bytesToHex(build));
  }
);

export const buildStakingRequest = functions.https.onRequest(
  async (request, response) => {
    const connection = new Connection({ fullnode: request.body.rpc });
    const provider = new JsonRpcProvider(connection);
    const tx = new TransactionBlock();
    const stakeCoin = tx.splitCoins(tx.gas, [tx.pure(request.body.amount)]);
    tx.moveCall({
      target: "0x3::sui_system::request_add_stake",
      arguments: [
        tx.object("0x0000000000000000000000000000000000000005"),
        stakeCoin,
        tx.pure(request.body.validatorAddress),
      ],
    });
    tx.setSenderIfNotSet(request.body.address);
    const build = await tx.build({ provider });
    response.send(bytesToHex(build));
  }
);

export const buildUnstakingRequest = functions.https.onRequest(
  async (request, response) => {
    const connection = new Connection({ fullnode: request.body.rpc });
    const provider = new JsonRpcProvider(connection);
    const tx = new TransactionBlock();
    tx.moveCall({
      target: "0x3::sui_system::request_withdraw_stake",
      arguments: [
        tx.object("0x0000000000000000000000000000000000000005"),
        tx.object(request.body.objectId),
      ],
    });
    tx.setSenderIfNotSet(request.body.address);
    const build = await tx.build({ provider });
    response.send(bytesToHex(build));
  }
);
