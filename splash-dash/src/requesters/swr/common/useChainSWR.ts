import { ErrorBody, ISwr, SwrError, defaultOption } from './swr';
import useSWR, { SWRConfiguration } from 'swr';

import { Method } from 'axios';
import { useMemo } from 'react';

type Fetcher<P> = (url: string, method?: Method, data?: any) => Promise<P>;

/**
 * @description
 * Paused when the chain is not specified
 */
export const useChainSWR = <P, E = ErrorBody>(
  url: [string, any],
  fetcher: Fetcher<P>,
  options: SWRConfiguration<P, SwrError<E>> = {},
): ISwr<P, E> => {
  const option = {
    ...defaultOption,
    ...options,
  };

  const { data, error, mutate } = useSWR<P, SwrError<E>>(url, fetcher, option);

  // Loading is not turn on when this request is paused
  const loading = useMemo(() => !data && !error && !options.isPaused?.(), [data, error]);

  const dataError = useMemo(() => (data && data['error']) || error, [data, error]);

  return {
    loading,
    data,
    error: dataError,
    mutate,
  };
};
