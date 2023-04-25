import { ThemeType } from './theme';

export type LocalStorage = {
  theme: ThemeType;
  walletType?: 'sui-extension' | 'cosmostation-extension' | 'wallet-connect' | 'splash-wallet' | null;
  isConnect: boolean;
  account?: string[];
};

export type LocalStorageKeys = keyof LocalStorage;
