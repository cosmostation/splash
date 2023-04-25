import { EpochTimestampModalContent, EpochWrapper, HeaderImg, PercentBar, ProgressBar, RewardWrapper } from './styled';
import { divide, minus, multiply } from 'src/util/big';
import { useMemo, useState } from 'react';

import EpochCountdown from '../EpochTime/EpochCountdown';
import Modal from 'src/components/common/Modal';
import ModalHeader from 'src/components/common/Modal/ModalHeader';
import closeIconSVG from 'src/assets/icons/common/CloseIcon.svg';
import dayjs from 'dayjs';
import { useGetLatestSuiSystemStateSwr } from 'src/requesters/swr/wave3/useGetLatestSuiSystemStateSwr';

type IEpochTimestampModalProps = {
  modalView: boolean;
  onCloseModal: React.Dispatch<React.SetStateAction<boolean>>;
};

export default function EpochTimestampModal({ modalView, onCloseModal }: IEpochTimestampModalProps) {
  const currentDate = multiply(dayjs().unix(), 1000);

  const { data: latestSystemState, loading } = useGetLatestSuiSystemStateSwr();

  const [estimatedTime, setEstimatedTime] = useState<dayjs.Dayjs | null>(null);

  const remainEpochPercent = useMemo(() => {
    const startTime = Number(latestSystemState?.epochStartTimestampMs) || 0;
    const reminedTime = minus(currentDate, startTime);
    const percent = multiply(divide(reminedTime, latestSystemState?.epochDurationMs || 1), 100, 2);

    return Number(percent) > 100 ? '100.00' : percent;
  }, [latestSystemState, currentDate, estimatedTime]);

  return (
    <Modal open={modalView} onClose={onCloseModal}>
      <>
        <ModalHeader>
          <>
            <div></div>
            <HeaderImg onClick={() => onCloseModal(false)} src={closeIconSVG} alt="close-icon" />
          </>
        </ModalHeader>
        <EpochTimestampModalContent>
          <div>
            <div>
              Epoch
              <EpochWrapper>{latestSystemState?.epoch || 0}</EpochWrapper>
              <ProgressBar>
                <PercentBar data-percent={`${remainEpochPercent}%`} />
              </ProgressBar>
            </div>
            <RewardWrapper>
              Reward distribution in
              <EpochCountdown
                epochStartTimestamp={latestSystemState?.epochStartTimestampMs}
                epochDurationMs={latestSystemState?.epochDurationMs}
                loading={loading}
                estimatedTime={estimatedTime}
                setEstimatedTime={setEstimatedTime}
              />
            </RewardWrapper>
          </div>
        </EpochTimestampModalContent>
      </>
    </Modal>
  );
}
