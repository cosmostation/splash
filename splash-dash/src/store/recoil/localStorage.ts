import { LocalStorage } from 'src/types/localStorage';
import { THEME_TYPE } from 'src/constant/theme';
import { atom } from 'recoil';
import { persistAtom } from './atoms';

export const localStorageDefault: LocalStorage = {
  theme: THEME_TYPE.LIGHT,
  walletType: null,
  isConnect: false,
};

export const localStorageState = atom<LocalStorage>({
  key: '#localStorage',
  default: localStorageDefault,
  effects: [persistAtom],
});
