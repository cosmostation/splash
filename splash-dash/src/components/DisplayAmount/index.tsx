import { Container, Denom } from './styled';
import { isNil, truncate } from 'lodash';

import Decimal from '../common/Decimal';
import { IAmount } from 'src/types/payloads/common/IAmount';
import { divide } from 'src/util/big';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useMemo } from 'react';
import { useRecoilValue } from 'recoil';

type IDisplayAmountProps = {
  data: IAmount | null;
  size?: 'small' | 'medium' | 'large' | 'sxlarge' | 'xlarge' | '2xlarge';
  decimal?: number;
  decimalized?: boolean;
};

export default function DisplayAmount({
  data,
  size = '2xlarge',
  decimal = 6,
  decimalized = false,
  ...remainder
}: IDisplayAmountProps) {
  const chain = useRecoilValue(getChainInstanceState);

  const parsed = useMemo(() => {
    if (isNil(data)) {
      return [0, chain.denom];
    }

    return [divide(data.amount, Math.pow(10, chain.decimal), chain.decimal), chain.denom];
  }, [data, chain]);

  const [amount, denom] = parsed;

  const dpDenom = (chain.dpDenom || denom) as string;

  const denomSize = useMemo(() => {
    if (size === 'small') {
      return '1.4rem';
    } else if (size === 'medium') {
      return '1.6rem';
    } else if (size === 'large') {
      return '1.8rem';
    } else if (size === 'sxlarge') {
      return '2.6rem';
    } else if (size === 'xlarge') {
      return '3rem';
    } else if (size === '2xlarge') {
      return '3.6rem';
    }

    return '1.4rem';
  }, [size]);

  return (
    <Container {...remainder}>
      <Decimal number={amount} decimal={decimal} size={size} />
      <Denom denom-size={denomSize}>{truncate(dpDenom, { length: 15 })}</Denom>
    </Container>
  );
}
