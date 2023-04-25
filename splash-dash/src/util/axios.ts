import axios, { AxiosResponse, Method } from 'axios';

import type { AxiosError } from 'axios';

async function rawFetcher<T = any>(url: string, method: Method, data?: any): Promise<AxiosResponse<T>> {
  try {
    const result = await axios({
      method,
      url,
      data,
      params: data,
    });

    return result;
  } catch (err) {
    throw err;
  }
}

export async function get<T = any>(url: string, method: Method, data?: any): Promise<T> {
  try {
    const result = await rawFetcher(url, method, data);

    return result.data;
  } catch (err) {
    throw err;
  }
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function isAxiosError(e: any): e is AxiosError {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
  return typeof e?.response?.status === 'number';
}
