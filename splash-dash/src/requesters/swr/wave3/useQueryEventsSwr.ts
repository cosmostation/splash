import { ISwr } from '../common/swr';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useChainSWR } from '../common/useChainSWR';
import { useRecoilValue } from 'recoil';
import { v1 as uuid } from 'uuid';
import { SuiEvent, type EventId } from '@mysten/sui.js';

export const VALIDATORS_EVENTS_QUERY = '0x3::validator_set::ValidatorEpochInfoEvent';

export const useQueryEventsSwr = (limit: number | null, order: boolean, cursor?: EventId | null): ISwr<SuiEvent[]> => {
  const chain = useRecoilValue(getChainInstanceState);

  const eventCursor = cursor || null;
  const eventLimit = limit || null;

  const event = [{ MoveEventType: VALIDATORS_EVENTS_QUERY }, eventCursor, eventLimit, order];

  const getValidators = {
    id: uuid(),
    jsonrpc: '2.0',
    method: 'suix_queryEvents',
    params: event,
  };

  const url = chain.urlRequester.getCallSuiPostUrl();

  const fetcher = (fetchUrl: string): Promise<any> => chain.urlRequester.fetcher(fetchUrl, 'POST', getValidators);

  const { data, error, loading } = useChainSWR([url, `suix_queryEvents-${limit}`], fetcher, {
    refreshInterval: 0,
    revalidateOnFocus: false,
  });

  return {
    loading,
    data: data?.result?.data,
    error,
  };
};
