import AmountInfoCard from '../AmountInfoCard';
import { Container } from './styled';
import DisplayAmount from 'src/components/DisplayAmount';
import { device } from 'src/constant/muiSize';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { localStorageState } from 'src/store/recoil/localStorage';
import { makeIAmountType } from 'src/function/makeIAmountType';
import { plus } from 'src/util/big';
import { useGetAllBalancesSwr } from 'src/requesters/swr/wave3/useGetAllBalancesSwr';
import { useGetStakesSwr } from 'src/requesters/swr/wave3/useGetStakesSwr';
import { useMediaQuery } from '@mui/material';
import { useMemo } from 'react';
import { useRecoilValue } from 'recoil';

export default function MyAccountInfo() {
  const localStorageInfo = useRecoilValue(localStorageState);
  const chain = useRecoilValue(getChainInstanceState);

  const address = localStorageInfo.account?.[0] || '';

  const isLaptop = useMediaQuery(device.laptop);

  const { makeData: suiAmount } = useGetAllBalancesSwr(address);
  const { data: stakeData } = useGetStakesSwr(address);

  const stakeTokens = useMemo(() => {
    if (!stakeData) return null;

    const stakeTokenAmount = stakeData.reduce((result, delegation) => {
      const targetValiStakeAmount = delegation.stakes.reduce(
        (valiResult, stake) => Number(plus(valiResult, stake.principal)),
        0,
      );

      return Number(plus(result, targetValiStakeAmount));
    }, 0);

    const earnTokenAmount = stakeData.reduce((result, delegation) => {
      const targetValiStakeAmount = delegation.stakes.reduce(
        (valiResult, stake) => Number(plus(valiResult, stake.estimatedReward || 0)),
        0,
      );

      return Number(plus(result, targetValiStakeAmount));
    }, 0);

    return {
      stake: stakeTokenAmount,
      earn: earnTokenAmount,
    };
  }, [stakeData]);

  return (
    <Container>
      <AmountInfoCard title="Available">
        <div>
          {localStorageInfo.isConnect ? (
            <DisplayAmount data={suiAmount} decimal={6} size={isLaptop ? 'xlarge' : '2xlarge'} />
          ) : (
            '-'
          )}
        </div>
      </AmountInfoCard>
      <AmountInfoCard title="Staked">
        <div>
          {localStorageInfo.isConnect ? (
            <DisplayAmount
              data={makeIAmountType(stakeTokens?.stake || 0, chain.denom)}
              decimal={6}
              size={isLaptop ? 'xlarge' : '2xlarge'}
            />
          ) : (
            '-'
          )}
        </div>
      </AmountInfoCard>
      <AmountInfoCard title="Earned">
        <div>
          {localStorageInfo.isConnect ? (
            <DisplayAmount
              data={makeIAmountType(stakeTokens?.earn || 0, chain.denom)}
              decimal={6}
              size={isLaptop ? 'xlarge' : '2xlarge'}
            />
          ) : (
            '-'
          )}
        </div>
      </AmountInfoCard>
    </Container>
  );
}
