import {
  ArrowImg,
  ButtonImg,
  ButtonWrapper,
  ConnectButton,
  ConnectButtonWrapper,
  ConnectedButton,
  Container,
  ContentWrapper,
  DrawerWrapper,
  HeaderWrapper,
  NetworkButton,
  NetworkButtonWrapper,
  NetworkWrapper,
  TitleImg,
} from './styled';

import { ReactComponent as ArrowIcon } from 'src/assets/icons/common/ArrowIcon.svg';
import ConnectWalletModal from '../ConnectWalletModal';
import { Drawer } from '@mui/material';
import { ReactComponent as EpochTimeIcon } from 'src/assets/icons/header/EpochTimeIcon.svg';
import EpochTimestampModal from '../EpochTimestampModal';
import LoginAccountInfo from './LoginAccountInfo';
import MenuDropdown from './MenuDropdown';
import NetworkModal from './NetworkModal';
import { ReactComponent as SplashDashIcon } from 'src/assets/icons/header/SplashDashIcon.svg';
import { ReactComponent as closeIconSVG } from 'src/assets/icons/common/CloseIcon.svg';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { localStorageState } from 'src/store/recoil/localStorage';
import { useRecoilValue } from 'recoil';
import { useState } from 'react';

type IDrawerContainerProps = {
  drawer: boolean;
  setDrawer: (value: React.SetStateAction<boolean>) => void;
};

export default function DrawerContainer({ drawer, setDrawer }: IDrawerContainerProps) {
  const chain = useRecoilValue(getChainInstanceState);
  const localStorageInfo = useRecoilValue(localStorageState);

  const [epochTimestamp, setEpochTimestamp] = useState(false);
  const [networkControlView, setNetworkControlView] = useState(false);
  const [modalView, setModalView] = useState(false);

  const isConnect = localStorageInfo.isConnect;

  return (
    <Drawer
      PaperProps={{
        sx: {
          width: '100%',
        },
      }}
      anchor="right"
      open={drawer}
      onClose={() => setDrawer(false)}
    >
      <Container>
        <DrawerWrapper>
          <HeaderWrapper>
            <TitleImg Img={SplashDashIcon} />
            <ButtonWrapper>
              <ButtonImg Img={EpochTimeIcon} onClick={() => setEpochTimestamp(true)} />
              <ButtonImg Img={closeIconSVG} onClick={() => setDrawer(false)} />
              <EpochTimestampModal modalView={epochTimestamp} onCloseModal={setEpochTimestamp} />
            </ButtonWrapper>
          </HeaderWrapper>
          <ContentWrapper>
            <NetworkWrapper>
              <NetworkButton onClick={() => setNetworkControlView(!networkControlView)}>
                <NetworkButtonWrapper>
                  {chain.network}
                  <ArrowImg Img={ArrowIcon} />
                </NetworkButtonWrapper>
                <NetworkModal modalView={networkControlView} onCloseModal={setNetworkControlView} />
              </NetworkButton>
              <MenuDropdown setDrawer={setDrawer} />
            </NetworkWrapper>
            {isConnect ? (
              <ConnectedButton>
                <LoginAccountInfo />
              </ConnectedButton>
            ) : (
              <ConnectButtonWrapper>
                <ConnectButton onClick={() => setModalView(!modalView)}>Connect Wallet</ConnectButton>
                <ConnectWalletModal modalView={modalView} onCloseModal={setModalView} />
              </ConnectButtonWrapper>
            )}
          </ContentWrapper>
        </DrawerWrapper>
      </Container>
    </Drawer>
  );
}
