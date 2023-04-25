import { InstallError } from '@cosmostation/extension-client';

export function isInstalled() {
  return !!window.cosmostation;
}

export function sui(): Promise<any> {
  return new Promise((resolve, reject) => {
    const interval = setInterval(() => {
      if (isInstalled()) {
        clearInterval(interval);
        resolve(window.cosmostation.sui);
      }
    }, 100);

    setTimeout(() => {
      clearInterval(interval);
      reject(new InstallError());
    }, 500);
  });
}
