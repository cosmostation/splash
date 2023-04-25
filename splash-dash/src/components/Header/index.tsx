import {
  ArrowImg,
  ButtonWrapper,
  ChainHeaderRight,
  ConnectButton,
  ConnectedButton,
  Container,
  DashIcon,
  EpochContainer,
  HeaderContainer,
  MobileHeaderButton,
  MobileHeaderButtonWrapper,
  NetworkButton,
} from './styled';

import { ReactComponent as ArrowIcon } from 'src/assets/icons/common/ArrowIcon.svg';
import ConnectWalletModal from './ConnectWalletModal';
import DrawerContainer from './DrawerContainer';
import DropdownAccount from './DropdownAccount';
import DropdownNetwork from './DropdownNetwork';
import EpochTime from './EpochTime';
import { ReactComponent as EpochTimeIcon } from 'src/assets/icons/header/EpochTimeIcon.svg';
import EpochTimestampModal from './EpochTimestampModal';
import { ReactComponent as NavigateIcon } from 'src/assets/icons/header/NavigateIcon.svg';
import { ReactComponent as SplashDashIcon } from 'src/assets/icons/header/SplashDashIcon.svg';
import { device } from 'src/constant/muiSize';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { localStorageState } from 'src/store/recoil/localStorage';
import { reduceString } from 'src/function/stringFunctions';
import useMediaQuery from '@mui/material/useMediaQuery';
import { useRecoilValue } from 'recoil';
import { useState } from 'react';

export default function Header() {
  const localStorageInfo = useRecoilValue(localStorageState);
  const chain = useRecoilValue(getChainInstanceState);

  const isLaptop = useMediaQuery(device.laptop);

  const [drawer, setDrawer] = useState(false);
  const [epochTimestamp, setEpochTimestamp] = useState(false);
  const [modalView, setModalView] = useState(false);
  const [walletControlView, setWalletControlView] = useState(false);
  const [networkControlView, setNetworkControlView] = useState(false);

  const isConnect = localStorageInfo.isConnect;

  return (
    <>
      <Container>
        <HeaderContainer>
          <DashIcon Img={SplashDashIcon} />
          {isLaptop ? (
            <MobileHeaderButtonWrapper>
              <MobileHeaderButton Img={EpochTimeIcon} onClick={() => setEpochTimestamp(true)} />
              <MobileHeaderButton Img={NavigateIcon} onClick={() => setDrawer(true)} />
              <EpochTimestampModal modalView={epochTimestamp} onCloseModal={setEpochTimestamp} />
              <DrawerContainer drawer={drawer} setDrawer={setDrawer} />
            </MobileHeaderButtonWrapper>
          ) : (
            <ChainHeaderRight>
              <NetworkButton>
                <ButtonWrapper
                  onClick={() => {
                    setNetworkControlView(!networkControlView);
                    setWalletControlView(false);
                  }}
                >
                  {chain.network}
                  <ArrowImg Img={ArrowIcon} />
                </ButtonWrapper>
                {networkControlView && <DropdownNetwork />}
              </NetworkButton>
              {isConnect ? (
                <ConnectedButton>
                  <ButtonWrapper
                    onClick={() => {
                      setWalletControlView(!walletControlView);
                      setNetworkControlView(false);
                    }}
                  >
                    {reduceString(localStorageInfo.account?.[0] || '', 6, 6)}
                    <ArrowImg Img={ArrowIcon} />
                  </ButtonWrapper>
                  {walletControlView && <DropdownAccount />}
                </ConnectedButton>
              ) : (
                <ConnectButton onClick={() => setModalView(!modalView)}>Connect Wallet</ConnectButton>
              )}
            </ChainHeaderRight>
          )}
        </HeaderContainer>
      </Container>
      <EpochContainer>
        <EpochTime />
      </EpochContainer>
      <ConnectWalletModal modalView={modalView} onCloseModal={setModalView} />
    </>
  );
}
