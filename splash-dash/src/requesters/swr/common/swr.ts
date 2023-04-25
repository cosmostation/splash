import { KeyedMutator, SWRConfiguration } from 'swr/dist/types';

import { AxiosError } from 'axios';

export interface ErrorBody {
  error_code: number;
  error_msg: string;
}

export type SwrError<E = ErrorBody> = AxiosError<E>;

export type ISwr<T, E = ErrorBody> = {
  loading: boolean;
  data?: T;
  makeData?: any;
  error?: SwrError<E>;
  url?: string;
  revalidate?: () => Promise<boolean>;
  mutate?: KeyedMutator<T>;
};

export type IPaginationSwr<T> = ISwr<T> & {
  totalCount?: string;
  fetchMore: () => void;
};

export const defaultOption: SWRConfiguration = {
  errorRetryCount: 0,
  shouldRetryOnError: false,
  refreshWhenHidden: false,
  refreshWhenOffline: false,
  revalidateIfStale: false,
  revalidateOnFocus: true,
};
