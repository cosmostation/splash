import { ISwr } from '../common/swr';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useChainSWR } from '../common/useChainSWR';
import { useRecoilValue } from 'recoil';
import { v1 as uuid } from 'uuid';
import { type DelegatedStake } from '@mysten/sui.js';

export const useGetStakesSwr = (address: string): ISwr<DelegatedStake[]> => {
  const chain = useRecoilValue(getChainInstanceState);

  const getObjectsOwnedByAddress = {
    id: uuid(),
    jsonrpc: '2.0',
    method: 'suix_getStakes',
    params: [address],
  };

  const url = chain.urlRequester.getCallSuiPostUrl();

  const fetcher = (fetchUrl: string): Promise<any> =>
    chain.urlRequester.fetcher(fetchUrl, 'POST', getObjectsOwnedByAddress);

  const { data, error, loading } = useChainSWR([url, `suix_getStakes-${address}`], fetcher, {
    refreshInterval: 60000,
    revalidateOnFocus: true,
  });

  return {
    loading,
    data: data?.result,
    error,
  };
};
