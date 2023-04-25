import {
  ArrowImg,
  Container,
  EpochWrapper,
  NameContainer,
  PendingComment,
  RowContainer,
  StakeButton,
  StakeContainer,
  ValidatorImg,
} from './styled';

import { ReactComponent as ArrowColorIcon } from 'src/assets/icons/common/ArrowColorIcon.svg';
import DefaultValidatorIcon from 'src/assets/icons/validator/DefaultValidator.svg';
import DisplayAmount from 'src/components/DisplayAmount';
import { IDelegateObject } from 'src/types/payloads/IGetDelegatedStakes';
import StakingModal from 'src/components/Modal/StakingModal';
import UnstakingModal from 'src/components/Modal/UnstakingModal';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { makeIAmountType } from 'src/function/makeIAmountType';
import { plus } from 'src/util/big';
import { useRecoilValue } from 'recoil';
import { useState } from 'react';

type IStakingRowProps = {
  index: number;
  stakeStatus: IDelegateObject;
  stakingStatus: number;
  setStakingStatus: React.Dispatch<React.SetStateAction<number>>;
};

export default function StakingRow({ index, stakeStatus, stakingStatus, setStakingStatus }: IStakingRowProps) {
  const chain = useRecoilValue(getChainInstanceState);

  const [stakeWalletModalView, setStakeWalletModalView] = useState(false);
  const [unStakeWalletModalView, setUnStakeWalletModalView] = useState(false);

  const isNowRow = index === stakingStatus;

  const walletControl = () => {
    if (isNowRow) {
      setStakingStatus(-1);
      return;
    }

    setStakingStatus(index);
  };

  return (
    <>
      <Container data-select={isNowRow.toString()}>
        <RowContainer onClick={() => walletControl()}>
          <NameContainer>
            <ValidatorImg Img={stakeStatus.img || DefaultValidatorIcon} />
            {stakeStatus.name}
          </NameContainer>
          <DisplayAmount data={makeIAmountType(stakeStatus.principal, chain.denom)} size="large" />
          <EpochWrapper>
            {`Epoch #${plus(stakeStatus.stakeActiveEpoch, 1)}`}
            {stakeStatus.status === 'Pending' && <PendingComment>(Pending)</PendingComment>}
          </EpochWrapper>
          <DisplayAmount data={makeIAmountType(stakeStatus.estimatedReward || 0, chain.denom)} size="large" />
          <ArrowImg data-select={isNowRow.toString()} Img={ArrowColorIcon} />
        </RowContainer>
        {isNowRow && (
          <StakeContainer>
            <StakeButton onClick={() => setStakeWalletModalView(!stakeWalletModalView)}>Stake</StakeButton>
            <StakeButton onClick={() => setUnStakeWalletModalView(!unStakeWalletModalView)}>Unstake</StakeButton>
          </StakeContainer>
        )}
      </Container>
      <StakingModal
        modalView={stakeWalletModalView}
        onCloseModal={setStakeWalletModalView}
        validatorAddress={stakeStatus.validatorAddress}
      />
      <UnstakingModal
        modalView={unStakeWalletModalView}
        onCloseModal={setUnStakeWalletModalView}
        stakeStatus={stakeStatus}
      />
    </>
  );
}
