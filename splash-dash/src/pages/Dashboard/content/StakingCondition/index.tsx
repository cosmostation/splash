import {
  ButtonWrapper,
  ConnectButton,
  ConnectInfo,
  CustomSection,
  CustomSectionContent,
  CustomSectionHeader,
  NotConnectContainer,
  ObjectCount,
  WalletImg,
} from './styled';
import { useMemo, useState } from 'react';

import ConnectWalletModal from 'src/components/Header/ConnectWalletModal';
import Loading from 'src/components/Loading';
import StakingStatus from './StakingStatus';
import WalletIconSVG from 'src/assets/icons/dashboard/WalletIcon.svg';
import { flatten } from 'lodash';
import { localStorageState } from 'src/store/recoil/localStorage';
import { useGetLatestSuiSystemStateSwr } from 'src/requesters/swr/wave3/useGetLatestSuiSystemStateSwr';
import { useGetStakesSwr } from 'src/requesters/swr/wave3/useGetStakesSwr';
import { useRecoilValue } from 'recoil';

export default function StakingCondition() {
  const localStorageInfo = useRecoilValue(localStorageState);

  const address = localStorageInfo.account?.[0] || '';

  const { data: stakeData, loading: stakeLoading } = useGetStakesSwr(address);
  const { data: latestSystemState } = useGetLatestSuiSystemStateSwr();

  const [modalView, setModalView] = useState(false);

  const delegateObjects = useMemo(() => {
    if (!stakeData) return [];

    return flatten(
      stakeData?.map((v) => {
        const getTargetValidator = latestSystemState?.activeValidators.find((a) => v.validatorAddress === a.suiAddress);

        return v.stakes.map((s) => {
          return {
            ...s,
            stakingPool: v.stakingPool,
            validatorAddress: v.validatorAddress,
            name: (getTargetValidator?.name as string) || 'unknown',
            img: getTargetValidator?.imageUrl || null,
          };
        });
      }),
    );
  }, [stakeData, latestSystemState]);

  return (
    <CustomSection>
      {localStorageInfo.isConnect ? (
        <>
          <CustomSectionHeader data-length={(delegateObjects.length > 0).toString()}>
            <>
              My staking status <ObjectCount>({delegateObjects.length} object)</ObjectCount>
            </>
          </CustomSectionHeader>
          <CustomSectionContent>
            <>
              {stakeLoading && <Loading />}
              {!stakeLoading && <StakingStatus delegatedStakes={delegateObjects} />}
            </>
          </CustomSectionContent>
        </>
      ) : (
        <NotConnectContainer>
          <WalletImg src={WalletIconSVG} alt="wallet-icon" />
          No Wallet Connected
          <ConnectInfo>Connect wallet to begin using Splash dashboard</ConnectInfo>
          <ButtonWrapper>
            <ConnectButton onClick={() => setModalView(!modalView)}>Connect Wallet</ConnectButton>
          </ButtonWrapper>
          <ConnectWalletModal modalView={modalView} onCloseModal={setModalView} />
        </NotConnectContainer>
      )}
    </CustomSection>
  );
}
