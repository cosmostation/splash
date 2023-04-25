import DataSerialization from '../DataSerialization';
import { startsWith } from 'lodash';

class SuiSerialization extends DataSerialization {
  parseAccount(data: any): any {
    const checkTokens = data?.filter((v) => startsWith(v.type, '0x1::coin::CoinStore'));
    return;
  }

  parseTxs(data: any): any {
    return;
  }
}

export default SuiSerialization;
