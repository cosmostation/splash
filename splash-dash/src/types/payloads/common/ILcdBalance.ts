import { IAmount } from '../common/IAmount';
import { IPagination } from './IPagination';

export interface ILcdBalance {
  balances?: IAmount[];
  // kava
  result?: IAmount[];
  pagination: IPagination;
}
