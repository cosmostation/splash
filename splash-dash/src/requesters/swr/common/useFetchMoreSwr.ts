import { IPaginationSwr, SwrError, defaultOption } from './swr';
import { useCallback, useEffect, useMemo, useState } from 'react';
import useSWRInfinite, { SWRInfiniteConfiguration } from 'swr/infinite';

import { flatten } from 'ramda';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { isEmpty } from 'lodash';
import { useRecoilValue } from 'recoil';

type GenUrl = (limit: number, searchAfter?: string) => string | null;

interface IUseFetchMoreSwrParams<T> {
  genUrl: GenUrl;
  fetcher: (url: string) => Promise<T[]>;
  limit?: number;
}

interface IUrlDataParams {
  findKey?: string;
}

function useFetchMoreSwr<T = any>(
  { genUrl, fetcher, limit = 45 }: IUseFetchMoreSwrParams<T>,
  config: SWRInfiniteConfiguration,
  { findKey }: IUrlDataParams = {},
): IPaginationSwr<T[]> {
  const chain = useRecoilValue(getChainInstanceState);

  const [searchAfterId, setSearchAfter] = useState<string>();
  const [totalData, setTotalData] = useState<T[]>([]);

  useEffect(() => {
    setTotalData([]);
  }, [chain]);

  const getKey = useCallback(
    (_fromIdx: number, previousPageData: T[]): string | null => {
      if (previousPageData && !previousPageData.length) return null;

      const url = genUrl(limit, searchAfterId);

      if (!url) return null;

      return url;
    },
    [genUrl, searchAfterId],
  );

  const configs = {
    ...defaultOption,
    ...config,
  };

  const { data, error } = useSWRInfinite<T[], SwrError>(getKey, fetcher, configs);
  const findData = useMemo(() => {
    return findKey ? ([data?.[0][findKey]] as T[][]) : data;
  }, [data, findKey]);

  const fetchMore = useCallback(() => {
    if (isEmpty(data?.[0]['searchAfter'])) {
      return;
    } else if (data) {
      const getSearchAfter = data?.[0]['searchAfter'];

      setSearchAfter(getSearchAfter);
    }
  }, [data, findData, searchAfterId]);

  useEffect(() => {
    if (!loading && !isEmpty(data)) {
      setTotalData((prev) => {
        return [...prev, ...flatten(findData || [])];
      });
    }
  }, [data, findData]);

  const loading = !data && !error;

  return {
    loading,
    data: totalData,
    totalCount: data?.[0]['totalCount'],
    error,
    fetchMore,
  };
}

export default useFetchMoreSwr;
