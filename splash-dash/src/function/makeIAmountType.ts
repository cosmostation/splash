import { IAmount } from 'src/types/payloads/common/IAmount';

export const makeIAmountType = (amount: string | number, denom: string): IAmount => {
  return {
    amount,
    denom,
  };
};
