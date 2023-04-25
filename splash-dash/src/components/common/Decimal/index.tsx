import { Container, LowDecimal, UpperDecimal } from './styled';

import { formatNumber } from 'src/function/formatNumber';
import { isNil } from 'lodash';
import { useMemo } from 'react';

type DecimalProps = {
  number: number | string;
  decimal?: number;
  size?: 'small' | 'medium' | 'large' | 'sxlarge' | 'xlarge' | '2xlarge';
};

export default function Decimal({ number, decimal = 6, size = '2xlarge', ...remainder }: DecimalProps) {
  const split = useMemo(() => {
    const _split = formatNumber(number.toString()).split('.');

    if (isNil(_split[1])) {
      _split[1] = '';
    }

    if (_split[1].length < decimal) {
      _split[1] += '0'.repeat(decimal - _split[1].length);
    } else if (_split[1].length > decimal) {
      _split[1] = _split[1].substr(0, decimal);
    }

    return _split;
  }, [number, decimal]);

  const decimalSize = useMemo(() => {
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
      <UpperDecimal data-size={decimalSize}>{split[0]}</UpperDecimal>
      {decimal > 0 && <LowDecimal data-size={decimalSize}>.{split[1]}</LowDecimal>}
    </Container>
  );
}
