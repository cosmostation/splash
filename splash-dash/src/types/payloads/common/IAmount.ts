/**
 * COIN: staking token, ibc token, bridge token
 * CW20: token by cw20 contract
 */
export enum EN_ASSET_TYPE {
  COIN = 'COIN',
  CW20 = 'CW20',
}

export interface IAmount {
  denom: string;
  amount: string | number;

  assetType?: EN_ASSET_TYPE;
}
