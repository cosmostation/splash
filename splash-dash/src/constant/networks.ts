import { ChainType } from 'src/types/chains';
import { Networks } from 'src/types/d.ts/Networks';
import SuiDevnetConst from 'src/constant/chains/SuiDevnet/constants';
import SuiTestnetConst from 'src/constant/chains/SuiTestnet/constants';
import { pick } from 'ramda';

const pickNetworkValues = (chainConsts: ChainType): Networks => {
  return pick(
    ['id', 'name', 'chainId', 'denom', 'decimal', 'dpDenom', 'geckoId', 'dashboardTitle', 'apiURL', 'network'],
    chainConsts,
  );
};

const productionNetworks: Networks[] = [pickNetworkValues(SuiTestnetConst), pickNetworkValues(SuiDevnetConst)];

export const getAllNetworks = (): Networks[] => {
  return [...productionNetworks];
};

export const getNetworks = (): Networks[] => {
  return getAllNetworks();
};
