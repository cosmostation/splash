import { EpochCountdownContainer, EpochHeaderContainer, EpochInfo, PercentBar, ProgressBar } from './styled';
import { divide, minus, multiply } from 'src/util/big';
import { useMemo, useState } from 'react';

import EpochCountdown from './EpochCountdown';
import dayjs from 'dayjs';
import { useGetLatestSuiSystemStateSwr } from 'src/requesters/swr/wave3/useGetLatestSuiSystemStateSwr';

export default function EpochTime() {
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
    <EpochHeaderContainer>
      Epoch
      <EpochInfo>{latestSystemState?.epoch || '-'}</EpochInfo>
      <ProgressBar>
        <PercentBar data-percent={`${remainEpochPercent}%`} />
      </ProgressBar>
      <EpochCountdownContainer>
        Reward distribution in
        <EpochCountdown
          epochStartTimestamp={latestSystemState?.epochStartTimestampMs}
          epochDurationMs={latestSystemState?.epochDurationMs}
          loading={loading}
          estimatedTime={estimatedTime}
          setEstimatedTime={setEstimatedTime}
        />
      </EpochCountdownContainer>
    </EpochHeaderContainer>
  );
}
