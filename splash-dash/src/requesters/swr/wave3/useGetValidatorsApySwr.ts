import { ISwr } from '../common/swr';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useChainSWR } from '../common/useChainSWR';
import { useRecoilValue } from 'recoil';
import { v1 as uuid } from 'uuid';
import { type ValidatorsApy } from '@mysten/sui.js';

export const useGetValidatorsApySwr = (): ISwr<ValidatorsApy> => {
  const chain = useRecoilValue(getChainInstanceState);

  const getValidators = {
    id: uuid(),
    jsonrpc: '2.0',
    method: 'suix_getValidatorsApy',
    params: [],
  };

  const url = chain.urlRequester.getCallSuiPostUrl();

  const fetcher = (fetchUrl: string): Promise<any> => chain.urlRequester.fetcher(fetchUrl, 'POST', getValidators);

  const { data, error, loading } = useChainSWR([url, 'suix_getValidatorsApy'], fetcher, {
    refreshInterval: 0,
    revalidateOnFocus: false,
  });

  return {
    loading,
    data: data?.result,
    error,
  };
};
