import { Requester } from '../Requester';
import qs from 'qs';

/**
 * For api.movescan.io
 */
export class MovescanApiRequester extends Requester {
  protected readonly transactionsUrl = '/transactions';
  protected readonly blocksUrl = '/blocks';
  protected readonly epochsUrl = '/epochs';
  protected readonly proposalsUrl = '/proposals';
  protected readonly accountsUrl = '/accounts';
  protected readonly validatorsUrl = '/validators';
  protected readonly searchUrl = '/search';

  constructor() {
    const isDev = process.env.NODE_ENV;

    super({
      host: isDev ? process.env.REACT_APP_DEV_MOVESCAN_API_ENDPOINT! : process.env.REACT_APP_MOVESCAN_API_ENDPOINT!,
    });
  }

  getStatusUrl(chain: string): string {
    return this.makeChainUrl(chain, '/status');
  }

  getTransactionsUrl(
    chain: string,
    limit: number,
    type?: string,
    searchAfter?: string,
    start_version?: number,
    end_version?: number | null,
  ): string {
    const query = qs.stringify(
      {
        type,
        limit,
        searchAfter,
        start_version,
        end_version,
      },
      { addQueryPrefix: true },
    );

    return this.makeChainUrl(chain, `${this.transactionsUrl}${query}`);
  }

  getTransactionUrl(chain: string, version: string): string {
    return this.makeChainUrl(chain, `${this.transactionsUrl}/${version}`);
  }

  getBlocksUrl(
    chain: string,
    limit: number,
    searchAfter?: string,
    start_height?: number,
    end_height?: number | null,
  ): string {
    const query = qs.stringify(
      {
        limit,
        searchAfter,
        start_height,
        end_height,
      },
      { addQueryPrefix: true },
    );

    return this.makeChainUrl(chain, `${this.blocksUrl}${query}`);
  }

  getBlockUrl(chain: string, height: string): string {
    return this.makeChainUrl(chain, `${this.blocksUrl}/${height}`);
  }

  getBlocksByVersionUrl(chain: string, version: string): string {
    return this.makeChainUrl(chain, `${this.blocksUrl}/by_version/${version}`);
  }

  getEpochsUrl(chain: string, limit: number, searchAfter?: string): string {
    const query = qs.stringify(
      {
        limit,
        searchAfter,
      },
      { addQueryPrefix: true },
    );

    return this.makeChainUrl(chain, `${this.epochsUrl}${query}`);
  }

  getEpochUrl(chain: string, epoch: string): string {
    return this.makeChainUrl(chain, `${this.epochsUrl}/${epoch}`);
  }

  getProposalsUrl(chain: string, resolved: boolean, limit: number, searchAfter?: string): string {
    const query = qs.stringify(
      {
        resolved,
        limit,
        searchAfter,
      },
      { addQueryPrefix: true },
    );

    return this.makeChainUrl(chain, `${this.proposalsUrl}${query}`);
  }

  getAccountTransactionsUrl(
    address: string,
    chain: string,
    limit: number,
    type?: string,
    searchAfter?: string,
    start_version?: number,
    end_version?: number | null,
  ): string {
    const query = qs.stringify(
      {
        type,
        limit,
        searchAfter,
        start_version,
        end_version,
      },
      { addQueryPrefix: true },
    );

    return this.makeChainUrl(chain, `${this.accountsUrl}/${address}/transactions${query}`);
  }

  getValidatorsPerformancesUrl(chain: string): string {
    return this.makeChainUrl(chain, `${this.validatorsUrl}/performances`);
  }

  getValidatorPerformancesUrl(address: string, chain: string, limit: number, searchAfter?: string): string {
    const query = qs.stringify(
      {
        limit,
        searchAfter,
      },
      { addQueryPrefix: true },
    );

    return this.makeChainUrl(chain, `${this.validatorsUrl}/${address}/performances${query}`);
  }

  getValidatorsProposedUrl(address: string, chain: string, limit: number, searchAfter?: string): string {
    const query = qs.stringify(
      {
        limit,
        searchAfter,
      },
      { addQueryPrefix: true },
    );

    return this.makeChainUrl(chain, `${this.validatorsUrl}/${address}/proposed${query}`);
  }

  getSearchUrl(chain: string, hash: string): string {
    const query = qs.stringify(
      {
        query: hash,
      },
      { addQueryPrefix: true },
    );

    return this.makeChainUrl(chain, `${this.searchUrl}${query}`);
  }

  private makeChainUrl(chain: string, url?: string): string {
    if (url) {
      return this.makeUrl(`/v1/${chain}${url}`);
    }

    return this.makeUrl(`/v1/${chain}`);
  }
}
