import { chunk, isEqual, size } from 'lodash';
import { useCallback, useEffect, useState } from 'react';

import { flatten } from 'ramda';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useRecoilValue } from 'recoil';

export interface IPager<T> {
  lastPage: number;
  slice: T[];
  slices: T[][];
  current: number;
}

const _initialState: IPager<any> = {
  lastPage: 0,
  slice: [],
  slices: [],
  current: 1,
};

/**
 * Slice data for use in pagination with perPage
 *
 * @param id Unique id
 * @param chain AbstractChain
 * @param data
 * @param perPage
 * @param fetchMore If present, called when the last page is accessed
 * @returns
 */
function usePagination<T = any>(
  id: string,
  data: T[] = [],
  perPage = 5,
  fetchMore?: () => void,
): [IPager<T>, (page: number) => void] {
  const chain = useRecoilValue(getChainInstanceState);
  const [pager, setPager] = useState<IPager<T>>(_initialState);

  useEffect(() => {
    if (size(data) === 0) {
      setPager(_initialState);
      return;
    }

    const slices = chunk(data, perPage);

    const isSame = isEqual(flatten(pager.slices), data);

    if (isSame) {
      return;
    }

    const lastPage = size(slices);
    const current = pager.current > lastPage ? lastPage : pager.current;
    const slice = slices[current - 1] || [];

    setPager((prevPager) => {
      return {
        ...prevPager,
        current,
        lastPage,
        slices,
        slice,
      };
    });
  }, [id, chain, perPage, data, fetchMore]);

  const goToPage = useCallback(
    (pageNumber: number) => {
      if (pager.lastPage >= pageNumber && pageNumber > 0) {
        pager.current = pageNumber;
        pager.slice = pager.slices[pageNumber - 1] || [];
        setPager({ ...pager });
      }

      if (pageNumber === pager.lastPage) {
        fetchMore?.();
      }
    },
    [pager],
  );

  return [pager, goToPage];
}

export default usePagination;
