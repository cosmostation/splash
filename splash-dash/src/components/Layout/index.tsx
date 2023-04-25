import { localStorageState } from 'src/store/recoil/localStorage';
import { useRecoilState, useSetRecoilState } from 'recoil';

import { Body } from './styled';
import { LocalStorage } from 'src/types/localStorage';
import NotFound from 'src/pages/NotFound';
import { chainInstanceState } from 'src/store/recoil/chainInstance';
import { getChainInstance } from 'src/store/getChainInstance';
import { isNil } from 'lodash';
import { useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { useWalletKit } from '@mysten/wallet-kit';

type LayoutProps = {
  children: JSX.Element;
};

export default function Layout({ children }: LayoutProps) {
  const { chainName } = useParams();
  const [localStorageInfo, setLocalStorageInfo] = useRecoilState(localStorageState);
  const network = getChainInstance(chainName);

  const { isConnected, currentAccount } = useWalletKit();

  if (isNil(network)) {
    return <NotFound />;
  }

  const setChainInstanceInfo = useSetRecoilState(chainInstanceState);

  useEffect(() => {
    setChainInstanceInfo(network);
  }, [chainName]);

  useEffect(() => {
    void (function callWallet() {
      if (localStorageInfo.walletType === 'sui-extension') {
        const localInfo: LocalStorage = {
          ...localStorageInfo,
          isConnect: isConnected,
          account: [currentAccount?.address || ''],
        };

        setLocalStorageInfo(localInfo);
      } else if (localStorageInfo.walletType === null) {
        setLocalStorageInfo((prev) => prev);
      }
    })();
  }, [currentAccount, localStorageInfo.walletType, window]);

  return <Body>{children}</Body>;
}
