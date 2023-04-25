import { Requester } from '../Requester';
import qs from 'qs';

/**
 * For api.mintscan.io
 */
export class MintscanApiRequester extends Requester {
  protected readonly utilsUrl = '/v1/utils';
  protected readonly utilsV2Url = '/v2/utils';

  constructor() {
    super({ host: process.env.REACT_APP_MINTSCAN_API_ENDPOINT! });
  }

  getServerStatus(): string {
    return this.makeUrl(`${this.utilsUrl}/server-status`);
  }

  getMarketHistoryUrl(denom: string, duration: number): string {
    const query = qs.stringify(
      {
        duration,
      },
      { addQueryPrefix: true },
    );

    return this.makeUrl(`${this.utilsV2Url}/market/history/${denom}${query}`);
  }

  getMarketPricesUrl(currency?: string): string {
    const query = qs.stringify(
      {
        currency,
      },
      { addQueryPrefix: true },
    );

    return this.makeUrl(`${this.utilsV2Url}/market/prices${query}`);
  }

  getMarketPriceUrl(denom: string, currency?: string): string {
    const query = qs.stringify(
      {
        currency,
      },
      { addQueryPrefix: true },
    );

    return this.makeUrl(`${this.utilsV2Url}/market/price/${denom}${query}`);
  }
}
