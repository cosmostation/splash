import Modal from 'src/components/common/Modal';
import StakingModalContent from './StakingModalContent';

interface IStakingModalProps {
  modalView: boolean;
  onCloseModal: React.Dispatch<React.SetStateAction<boolean>>;
  validatorAddress: string;
}

const StakingModal: React.FC<IStakingModalProps> = ({ modalView, onCloseModal, validatorAddress }) => {
  return (
    <Modal open={modalView} onClose={onCloseModal}>
      {modalView ? (
        <StakingModalContent onCloseModal={onCloseModal} validatorAddress={validatorAddress} />
      ) : (
        <div></div>
      )}
    </Modal>
  );
};

export default StakingModal;
