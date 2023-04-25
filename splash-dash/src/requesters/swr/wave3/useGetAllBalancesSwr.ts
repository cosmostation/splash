import { v1 as uuid } from 'uuid';
import { ISwr } from '../common/swr';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useChainSWR } from '../common/useChainSWR';
import { useRecoilValue } from 'recoil';
import { type CoinBalance } from '@mysten/sui.js';
import { useMemo } from 'react';
import { SUI_TOKEN_TYPE } from 'src/constant/coin';

export const useGetAllBalancesSwr = (address: string): ISwr<CoinBalance[]> => {
  const chain = useRecoilValue(getChainInstanceState);

  const getObjectsOwnedByAddress = {
    id: uuid(),
    jsonrpc: '2.0',
    method: 'suix_getAllBalances',
    params: [address],
  };

  const url = chain.urlRequester.getCallSuiPostUrl();

  const fetcher = (fetchUrl: string): Promise<any> =>
    chain.urlRequester.fetcher(fetchUrl, 'POST', getObjectsOwnedByAddress);

  const { data, error, loading } = useChainSWR([url, `suix_getAllBalances-${address}`], fetcher, {
    refreshInterval: 0,
    revalidateOnFocus: true,
  });

  const makeSuiAmount = useMemo(() => {
    const suiToken = data?.result?.find((v) => {
      return v.coinType === SUI_TOKEN_TYPE;
    });

    if (suiToken) {
      return {
        amount: suiToken.totalBalance,
        denom: chain.denom,
      };
    }

    return {
      amount: 0,
      denom: chain.denom,
    };
  }, [data]);

  return {
    loading,
    data: data?.result,
    error,
    makeData: makeSuiAmount,
  };
};
