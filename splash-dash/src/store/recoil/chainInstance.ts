import { atom, selector } from 'recoil';

import AbstractChain from 'src/constant/chains/AbstractChain';
import SuiChain from 'src/constant/chains/SuiTestnet/SuiTestnet';
import { getChainInstance } from '../getChainInstance';
import { isNil } from 'lodash';
import { useParams } from 'react-router-dom';

export const chainInstanceState = atom<AbstractChain | null>({
  key: '#chainInstance',
  effects: [
    ({ setSelf }) => {
      const { chainName } = useParams();
      const chain = getChainInstance(chainName);

      setSelf(chain);
    },
  ],
});

export const getChainInstanceState = selector<AbstractChain>({
  key: '#getChainInstance',
  get: ({ get }) => {
    const firstChain = new SuiChain();
    const getChain = get(chainInstanceState);

    return !isNil(getChain) ? getChain : firstChain;
  },
});
