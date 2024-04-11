import { ISwr } from '../common/swr';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useChainSWR } from '../common/useChainSWR';
import { useRecoilValue } from 'recoil';
import { v1 as uuid } from 'uuid';
import { type SuiObjectResponse } from '@mysten/sui.js';

export const useGetOwnedObjectsSwr = (
  address: string,
  limit?: number | null,
  cursor?: string | null,
): ISwr<SuiObjectResponse[]> => {
  const chain = useRecoilValue(getChainInstanceState);

  const eventCursor = cursor || null;
  const eventLimit = limit || null;

  const event = [address, {}, eventCursor, eventLimit];

  const getValidators = {
    id: uuid(),
    jsonrpc: '2.0',
    method: 'suix_getOwnedObjects',
    params: event,
  };

  const url = chain.urlRequester.getCallSuiPostUrl();

  const fetcher = (fetchUrl: string): Promise<any> => chain.urlRequester.fetcher(fetchUrl, 'POST', getValidators);

  const { data, error, loading } = useChainSWR([url, `suix_getOwnedObjects-${address}`], fetcher, {
    refreshInterval: 6000,
    revalidateOnFocus: true,
  });

  return {
    loading,
    data: data?.result?.data,
    error,
  };
};
