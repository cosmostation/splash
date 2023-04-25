import axios, { AxiosResponse, Method } from 'axios';

export interface IReqeuster {
  host: string;
}

export abstract class Requester {
  readonly host: string;

  constructor({ host }: IReqeuster) {
    this.host = host;
  }

  makeUrl(url: string): string {
    return `${this.host}${url}`;
  }

  async rawFetcher<T = any>(url: string, method: Method, data?: any): Promise<AxiosResponse<T>> {
    try {
      const result = await axios({
        method,
        url,
        data,
        params: method === 'GET' ? data : undefined,
        headers: {
          // 'X-Trace-Id': 'jjRzAytUOvGqRUlS1Q7k',
        },
      });

      return result;
    } catch (err) {
      throw err;
    }
  }

  async fetcher<T = any>(url: string, method: Method, data?: any): Promise<T> {
    try {
      const result = await this.rawFetcher(url, method, data);

      return result.data;
    } catch (err) {
      throw err;
    }
  }
}
