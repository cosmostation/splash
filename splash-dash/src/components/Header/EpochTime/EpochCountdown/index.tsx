import { Container, CurrentEpochEndContainer, EndContainer, EpochLoadingContainer, LoadingImg, Time } from './styled';
import { useEffect, useMemo, useRef } from 'react';

import { ReactComponent as LoadingSpin } from 'src/assets/icons/common/LoadingSpin.svg';
import dayjs from 'dayjs';
import { divide } from 'src/util/big';
import { max } from 'lodash';

type EpochCountdownProps = {
  epochStartTimestamp?: string;
  epochDurationMs?: string;
  loading: boolean;
  estimatedTime: dayjs.Dayjs | null;
  setEstimatedTime: React.Dispatch<React.SetStateAction<dayjs.Dayjs | null>>;
};

export default function EpochCountdown({
  epochStartTimestamp,
  epochDurationMs,
  loading,
  estimatedTime,
  setEstimatedTime,
}: EpochCountdownProps) {
  const intervalRef = useRef<NodeJS.Timer>();

  useEffect(() => {
    const _estimatedTime = dayjs
      .unix(Number(divide(epochStartTimestamp || 0, 1000)))
      .add(Number(epochDurationMs) || 0, 'milliseconds');

    if (!estimatedTime) {
      setEstimatedTime(_estimatedTime);

      if (!intervalRef.current) {
        intervalRef.current = setInterval(() => {
          const currentTime = _estimatedTime.subtract(1, 'milliseconds');
          setEstimatedTime(currentTime);
        }, 1000);
      }
    } else if (intervalRef.current) {
      clearInterval(intervalRef.current);

      intervalRef.current = setInterval(() => {
        const currentTime = _estimatedTime.subtract(1, 'milliseconds');
        setEstimatedTime(currentTime);
      }, 1000);
    }

    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, [epochStartTimestamp, epochDurationMs, estimatedTime, setEstimatedTime]);

  useEffect(() => {
    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, []);

  const durations = useMemo(() => {
    const current = dayjs();
    const targetTime = estimatedTime || current;

    const days = max([targetTime.diff(current, 'days'), 0]) || 0;
    const hours = max([targetTime.diff(current, 'hours') - days * 24, 0]) || 0;
    const minutes = max([targetTime.diff(current, 'minutes') - (hours + days * 24) * 60, 0]) || 0;
    const seconds = max([targetTime.diff(current, 'seconds') - (minutes + (hours + days * 24) * 60) * 60, 0]) || 0;

    return {
      days,
      hours,
      minutes,
      seconds,
    };
  }, [estimatedTime]);

  return (
    <Container>
      {loading ? (
        <EpochLoadingContainer>
          <LoadingImg Img={LoadingSpin} />
        </EpochLoadingContainer>
      ) : (
        <CurrentEpochEndContainer>
          <EndContainer>
            <Time>{String(durations.hours).padStart(2, '0')}</Time>
          </EndContainer>
          <Time>:</Time>
          <EndContainer>
            <Time>{String(durations.minutes).padStart(2, '0')}</Time>
          </EndContainer>
          <Time>:</Time>
          <EndContainer>
            <Time>{String(durations.seconds).padStart(2, '0')}</Time>
          </EndContainer>
        </CurrentEpochEndContainer>
      )}
    </Container>
  );
}
