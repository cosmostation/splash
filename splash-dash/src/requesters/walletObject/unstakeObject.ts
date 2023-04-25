import { SUI_SYSTEM_STATE_OBJECT_ID, TransactionBlock } from '@mysten/sui.js';

import { DEFAULT_GAS_BUDGET_FOR_UNSTAKE } from 'src/constant/coin';
import { LocalStorage } from 'src/types/localStorage';

export const unstakeObject = async (
  walletType: LocalStorage['walletType'],
  stakedSuiId: string,
  signAndExecuteTransactionBlock: any,
) => {
  if (walletType === 'sui-extension') {
    const tx = new TransactionBlock();

    tx.setGasBudget(DEFAULT_GAS_BUDGET_FOR_UNSTAKE);

    tx.moveCall({
      target: '0x3::sui_system::request_withdraw_stake',
      arguments: [tx.object(SUI_SYSTEM_STATE_OBJECT_ID), tx.object(stakedSuiId)],
    });

    const validatorResponse = await signAndExecuteTransactionBlock({
      transactionBlock: tx,
      options: {
        showInput: true,
        showEffects: true,
        showEvents: true,
      },
    });

    return validatorResponse;
  }
  return { err: 'not Support' };
};
