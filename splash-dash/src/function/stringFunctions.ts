export function reduceHash(address: string): string {
  return reduceString(address, 8, 8);
}

export const reduceString = (str: string, from: number, end: number): string => {
  if (str.length <= from + end) {
    return str;
  }

  return str ? str.substring(0, from) + '...' + str.substring(str.length - end) : '-';
};
