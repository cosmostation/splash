import { IPaginationSwr, SwrError, defaultOption } from './swr';
import { isEmpty, isUndefined } from 'lodash';
import { useCallback, useEffect, useMemo, useState } from 'react';
import useSWRInfinite, { SWRInfiniteConfiguration } from 'swr/infinite';

import { flatten } from 'ramda';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useRecoilValue } from 'recoil';

type GenUrl<T> = (start: string, lastId: number, prevData?: T[]) => string | null;

interface IUseFetchMoreSwrParams<T> {
  genUrl: GenUrl<T>;
  fetcher: (url: string) => Promise<T[]>;
  propKey?: string;
  start: string;
  messageType?: string;
  keyword?: string;
}

function useFetchMoreOffsetSwr<T = any>(
  { genUrl, fetcher, start = '0', messageType, keyword }: IUseFetchMoreSwrParams<T>,
  config: SWRInfiniteConfiguration,
): IPaginationSwr<T[]> {
  const chain = useRecoilValue(getChainInstanceState);

  const [offset, setOffset] = useState(0);
  const [totalData, setTotalData] = useState<T[]>([]);

  useEffect(() => {
    setTotalData([]);
  }, [chain, messageType, keyword]);

  const getKey = useCallback(
    (_fromIdx: number, previousPageData: T[]): string | null => {
      if (previousPageData && !previousPageData.length) return null;

      const url = genUrl(start, offset, previousPageData);

      if (!url) return null;

      return url;
    },
    [genUrl, start, offset],
  );

  const configs = {
    ...defaultOption,
    ...config,
  };

  const { data, error } = useSWRInfinite<T[], SwrError>(getKey, fetcher, configs);

  const loading = useMemo(() => {
    return !data && !error;
  }, [data, error]);

  const fetchMore = useCallback(() => {
    if (data) {
      const currentOffset = Number(start) + offset;

      setOffset(currentOffset);
    }
  }, [data, offset]);

  useEffect(() => {
    if (!isUndefined(data)) {
      return undefined;
    } else if (!loading && !isEmpty(data)) {
      setTotalData((prev) => {
        return [...prev, ...flatten(data || [])];
      });
    }
  }, [data, loading]);

  return {
    loading,
    data: totalData,
    error,
    fetchMore,
  };
}

export default useFetchMoreOffsetSwr;
