import { HeaderImg, HeaderTitle, WalletConnectModalContent } from './styled';

import ConnectWalletContent from './ConnectWalletContent';
import Modal from 'src/components/common/Modal';
import ModalHeader from 'src/components/common/Modal/ModalHeader';
import closeIconSVG from 'src/assets/icons/common/CloseIcon.svg';

interface IConnectWalletModalProps {
  modalView: boolean;
  onCloseModal: React.Dispatch<React.SetStateAction<boolean>>;
}

const ConnectWalletModal: React.FC<IConnectWalletModalProps> = ({ modalView, onCloseModal }) => {
  return (
    <Modal open={modalView} onClose={onCloseModal}>
      <>
        <ModalHeader>
          <>
            <HeaderTitle>Connect wallet</HeaderTitle>
            <HeaderImg onClick={() => onCloseModal(false)} src={closeIconSVG} alt="close-icon" />
          </>
        </ModalHeader>
        <WalletConnectModalContent>
          <ConnectWalletContent onCloseModal={onCloseModal} />
        </WalletConnectModalContent>
      </>
    </Modal>
  );
};

export default ConnectWalletModal;
