import { always, equals } from 'ramda';

/** noop */
export const nothing = always(undefined);

/** noop => null */
export const nullish = always(null);

export function call<T>(fn: () => T): T {
  return fn();
}

export const eqValues = (a1: unknown[], a2: unknown[]): boolean => equals(new Set(a1), new Set(a2));

export function roundFloat(num: number, precision: number) {
  return parseFloat(num.toFixed(precision));
}
