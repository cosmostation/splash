const BASE = '//raw.githubusercontent.com/cosmostation/chainlist/master/';

export const getJson = (path: string): string => BASE.concat(path);
