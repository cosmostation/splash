import { HeaderImg, HeaderTitle, HyperLinkButton, WalletConnectModalContent } from './styled';

import Image from 'src/components/common/Image';
import Modal from 'src/components/common/Modal';
import ModalHeader from 'src/components/common/Modal/ModalHeader';
import { ReactComponent as checkIconSVG } from 'src/assets/icons/common/CheckIcon.svg';
import closeIconSVG from 'src/assets/icons/common/CloseIcon.svg';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { getNetworks } from 'src/constant/networks';
import { useLocation } from 'react-router-dom';
import { useNavigate } from 'src/hooks/useNavigate';
import { useRecoilValue } from 'recoil';

interface INetworkModalProps {
  modalView: boolean;
  onCloseModal: React.Dispatch<React.SetStateAction<boolean>>;
}

const NetworkModal: React.FC<INetworkModalProps> = ({ modalView, onCloseModal }) => {
  const { navigate } = useNavigate();
  const { pathname } = useLocation();

  const networks = getNetworks();
  const chain = useRecoilValue(getChainInstanceState);

  const currentTitle = `/${pathname.split('/')[2]}`;

  return (
    <Modal open={modalView} onClose={onCloseModal}>
      <>
        <ModalHeader>
          <>
            <HeaderTitle>Select network</HeaderTitle>
            <HeaderImg onClick={() => onCloseModal(false)} src={closeIconSVG} alt="close-icon" />
          </>
        </ModalHeader>
        <WalletConnectModalContent>
          <>
            {networks.map((v, idx) => {
              const isCurrentNetwork = chain.network === v.network;

              return (
                <HyperLinkButton
                  key={v.network + '/' + idx}
                  onClick={() => {
                    navigate(`/${v.network}${currentTitle}`);
                  }}
                >
                  {v.network}
                  {isCurrentNetwork && <Image Img={checkIconSVG} />}
                </HyperLinkButton>
              );
            })}
          </>
        </WalletConnectModalContent>
      </>
    </Modal>
  );
};

export default NetworkModal;
