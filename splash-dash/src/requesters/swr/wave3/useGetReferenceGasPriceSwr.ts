import { IGasReferenceGasPrice } from 'src/types/payloads/IGasReferenceGasPrice';
import { ISwr } from '../common/swr';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useChainSWR } from '../common/useChainSWR';
import { useRecoilValue } from 'recoil';

export const useGetReferenceGasPriceSwr = (): ISwr<number> => {
  const chain = useRecoilValue(getChainInstanceState);

  const getValidators = {
    id: 'suix_getReferenceGasPrice',
    jsonrpc: '2.0',
    method: 'suix_getReferenceGasPrice',
    params: [],
  };

  const url = chain.urlRequester.getCallSuiPostUrl();

  const fetcher = (fetchUrl: string): Promise<IGasReferenceGasPrice> =>
    chain.urlRequester.fetcher(fetchUrl, 'POST', getValidators);

  const { data, error, loading } = useChainSWR([url, 'suix_getReferenceGasPrice'], fetcher, {
    refreshInterval: 0,
    revalidateOnFocus: false,
  });

  return {
    loading,
    data: data?.result,
    error,
  };
};
