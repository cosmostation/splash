import AbstractChain from 'src/constant/chains/AbstractChain';
import SuiDevnetChain from 'src/constant/chains/SuiDevnet/SuiDevnet';
import SuiTestnetChain from 'src/constant/chains/SuiTestnet/SuiTestnet';

export const getChainInstance = (network?: string): AbstractChain | null => {
  switch (network) {
    case 'testnet':
      return new SuiTestnetChain();
    case 'devnet':
      return new SuiDevnetChain();
    default:
      return null;
  }
};
