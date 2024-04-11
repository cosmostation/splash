import AbstractChain from 'src/constant/chains/AbstractChain';
import SuiDevnetChain from 'src/constant/chains/SuiDevnet/SuiDevnet';
import SuiTestnetChain from 'src/constant/chains/SuiTestnet/SuiTestnet';
import SuiMainnetChain from 'src/constant/chains/SuiMainnet/SuiMainnet';

export const getChainInstance = (network?: string): AbstractChain | null => {
  switch (network) {
    case 'mainnet':
      return new SuiMainnetChain();
    case 'testnet':
      return new SuiTestnetChain();
    case 'devnet':
      return new SuiDevnetChain();
    default:
      return null;
  }
};
