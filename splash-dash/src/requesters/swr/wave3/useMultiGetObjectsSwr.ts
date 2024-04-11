import { ISwr } from '../common/swr';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useChainSWR } from '../common/useChainSWR';
import { useRecoilValue } from 'recoil';
import { v1 as uuid } from 'uuid';
import { type SuiObjectResponse } from '@mysten/sui.js';

export const useMultiGetObjectsSwr = (address: (string | undefined)[]): ISwr<SuiObjectResponse[]> => {
  const chain = useRecoilValue(getChainInstanceState);

  const options = {
    showBcs: false,
    showContent: true,
    showDisplay: true,
    showOwner: true,
    showPreviousTransaction: true,
    showStorageRebate: true,
    showType: true,
  };

  const event = [address, options];

  const getValidators = {
    id: uuid(),
    jsonrpc: '2.0',
    method: 'sui_multiGetObjects',
    params: event,
  };

  const url = chain.urlRequester.getCallSuiPostUrl();

  const fetcher = (fetchUrl: string): Promise<any> => chain.urlRequester.fetcher(fetchUrl, 'POST', getValidators);

  const { data, error, loading } = useChainSWR([url, `sui_multiGetObjects-${address}`], fetcher, {
    refreshInterval: 0,
    revalidateOnFocus: false,
  });

  return {
    loading,
    data: data?.result,
    error,
  };
};
