import {
  AmountContainer,
  Container,
  CopyImg,
  DisconnectButton,
  TokenImg,
  TokenLoading,
  Value,
  ValueContainer,
} from './styled';
import { useCallback, useRef, useState } from 'react';
import { useRecoilState } from 'recoil';

import DisplayAmount from 'src/components/DisplayAmount';
import checkIconSVG from 'src/assets/icons/common/CheckIcon.svg';
import copy from 'copy-to-clipboard';
import copyIconSVG from 'src/assets/icons/common/CopyIcon.svg';
import { localStorageState } from 'src/store/recoil/localStorage';
import { reduceString } from 'src/function/stringFunctions';
import suiTokenSVG from 'src/assets/icons/common/SuiToken.svg';
import { throttle } from 'lodash';
import { useGetAllBalancesSwr } from 'src/requesters/swr/wave3/useGetAllBalancesSwr';
import { useWalletKit } from '@mysten/wallet-kit';

export default function DropdownAccount() {
  const { disconnect } = useWalletKit();

  const [localStorageInfo, setLocalStorageInfo] = useRecoilState(localStorageState);

  const address = localStorageInfo.account?.[0] || '';

  const { loading, makeData: suiAmount } = useGetAllBalancesSwr(address);

  const [copyClick, setCopyClick] = useState(false);
  const timeout = useRef<NodeJS.Timeout>();

  const copyToClipboard = useCallback(
    () =>
      throttle(() => {
        setCopyClick(true);

        copy(address);

        if (timeout.current) {
          clearTimeout(timeout.current);
        }

        timeout.current = setTimeout(() => {
          setCopyClick(false);
        }, 1000);
      }, 300),
    [address],
  );

  const defaultWallet = {
    ...localStorageInfo,
    walletType: null,
    isConnect: false,
    account: [],
  };

  const disconnectWallet = () => {
    void (async function async() {
      if (localStorageInfo.walletType === 'sui-extension') {
        disconnect();

        setLocalStorageInfo(defaultWallet);
      } else if (localStorageInfo.walletType === 'cosmostation-extension') {
        try {
          const provider = await window.cosmostation.sui;

          await provider.disconnect();

          setLocalStorageInfo(defaultWallet);
        } catch {
          return;
        }
      } else if (localStorageInfo.walletType === 'wallet-connect') {
        setLocalStorageInfo(defaultWallet);
      } else if (localStorageInfo.walletType === null) {
        return;
      }
    })();
  };

  return (
    <Container>
      <ValueContainer>
        Address
        <Value>
          <span>{reduceString(address, 10, 10)}</span>
          {copyClick ? (
            <CopyImg src={checkIconSVG} alt="check-icon" />
          ) : (
            <CopyImg onClick={copyToClipboard()} src={copyIconSVG} alt="copy-icon" />
          )}
        </Value>
      </ValueContainer>
      <ValueContainer>
        Total balance
        <Value>
          <AmountContainer>
            <TokenImg src={suiTokenSVG} alt="sui-token" />
            {!loading ? <DisplayAmount data={suiAmount} size="large" /> : <TokenLoading />}
          </AmountContainer>
        </Value>
      </ValueContainer>
      <DisconnectButton onClick={() => disconnectWallet()}>
        <div>Disconnect wallet</div>
      </DisconnectButton>
    </Container>
  );
}
