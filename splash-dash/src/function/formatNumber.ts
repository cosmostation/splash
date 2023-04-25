import { isEmpty } from 'lodash';

export const formatNum = (num): string => {
  const n = num.toString();
  const p = n.indexOf('.');

  return n.replace(/\d(?=(?:\d{3})+(?:\.|$))/g, (m, i) => (p < 0 || i < p ? `${m},` : m));
};

export const formatNumber = (v?: string | number): string => {
  if (!v) {
    return '0';
  }

  const str = v.toString();
  if (isEmpty(str)) return 'NaN';

  return formatNum(str);
};

export const humanFormat = (v?: string | number): string => {
  if (!v) {
    return '0';
  }

  const str = Number(v);
  const formatter = new Intl.NumberFormat('en', { notation: 'compact' });

  return formatter.format(str);
};

export const splitTimeStamp = (date: string): number => {
  if (date.length > 13) {
    return Number(date.substring(0, 13));
  }

  return Number(date);
};
