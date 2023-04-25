import { IDelegateObject } from 'src/types/payloads/IGetDelegatedStakes';
import Modal from 'src/components/common/Modal';
import UnstakingModalContent from './UnstakingModalContent';

interface IUnstakingModalProps {
  modalView: boolean;
  onCloseModal: React.Dispatch<React.SetStateAction<boolean>>;
  stakeStatus: IDelegateObject;
}

const UnstakingModal: React.FC<IUnstakingModalProps> = ({ modalView, onCloseModal, stakeStatus }) => {
  return (
    <Modal open={modalView} onClose={onCloseModal}>
      {modalView ? <UnstakingModalContent onCloseModal={onCloseModal} stakeStatus={stakeStatus} /> : <div></div>}
    </Modal>
  );
};

export default UnstakingModal;
