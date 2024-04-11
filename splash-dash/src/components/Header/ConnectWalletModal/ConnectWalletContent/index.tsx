import { ArrowImg, ConnectContainer, ConnectContent, Container, WalletImg, WalletName } from './styled';
import { useRecoilState, useSetRecoilState } from 'recoil';

import { ReactComponent as ArrowIcon } from 'src/assets/icons/common/ArrowIcon.svg';
import CosmostationIcon from 'src/assets/icons/walletConnect/CosmostationIcon.svg';
import DefaultValidatorIcon from 'src/assets/icons/validator/DefaultValidator.svg';
import { LocalStorage } from 'src/types/localStorage';
import { loaderState } from 'src/store/recoil/loader';
import { localStorageState } from 'src/store/recoil/localStorage';
import { useSnackbar } from 'notistack';
import { useWalletKit } from '@mysten/wallet-kit';

interface IConnectWalletContent {
  onCloseModal: React.Dispatch<React.SetStateAction<boolean>>;
}

const ConnetWalletContent: React.FC<IConnectWalletContent> = ({ onCloseModal }) => {
  const { enqueueSnackbar } = useSnackbar();
  const setIsShowLoader = useSetRecoilState(loaderState);
  const [localStorageInfo, setLocalStorageInfo] = useRecoilState(localStorageState);

  const { connect, wallets } = useWalletKit();

  const stakeSupportedWallets = wallets
    .filter((wallet) => {
      if (!('wallet' in wallet)) {
        return false;
      }

      return wallet;
    })
    .sort((wallet) => {
      if (wallet.name === 'Cosmostation Wallet') {
        return -1;
      }
      return 1;
    });

  const handleOnClickExtension = async (walletType: LocalStorage['walletType'], name?: string) => {
    setIsShowLoader(true);

    if (walletType === 'sui-extension') {
      try {
        if (stakeSupportedWallets.length >= 1) {
          await connect(name || '');

          const localInfo: LocalStorage = {
            ...localStorageInfo,
            walletType,
            isConnect: false,
            account: [],
          };

          setLocalStorageInfo(localInfo);
          onCloseModal(false);

          return;
        }

        window.open('https://chrome.google.com/webstore/detail/sui-wallet/opcgpfmipidbgpenhmajoajpbobppdil');
      } catch (e) {
        enqueueSnackbar('Wallet not connected', {
          variant: 'error',
          // @ts-ignore
          errorMsg: (e as { message?: string }).message,
        });
      } finally {
        setIsShowLoader(false);
      }
    } else {
      enqueueSnackbar('Not Support', { variant: 'error' });
      setIsShowLoader(false);
    }
  };

  return (
    <Container>
      {!stakeSupportedWallets.length && (
        <ConnectContent
          onClick={() =>
            window.open('https://chrome.google.com/webstore/detail/cosmostation/fpkhgmpbidmiogeglndfbkegfdlnajnf')
          }
        >
          <ConnectContainer>
            <WalletImg Img={CosmostationIcon} />
            <WalletName>
              Cosmostation<div>Cosmostation extension</div>
            </WalletName>
          </ConnectContainer>
          <ArrowImg Img={ArrowIcon} />
        </ConnectContent>
      )}
      {stakeSupportedWallets.map((v) => {
        return (
          <ConnectContent key={v.name} onClick={() => handleOnClickExtension('sui-extension', v.name)}>
            <ConnectContainer>
              <WalletImg Img={v.icon || DefaultValidatorIcon} />
              <WalletName>
                {v.name}
                <div>{v.name} extension</div>
              </WalletName>
            </ConnectContainer>
            <ArrowImg Img={ArrowIcon} />
          </ConnectContent>
        );
      })}
    </Container>
  );
};

export default ConnetWalletContent;
