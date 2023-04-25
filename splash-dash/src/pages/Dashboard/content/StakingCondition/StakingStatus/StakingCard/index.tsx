import {
  ArrowImg,
  Container,
  StakeButton,
  StakeContainer,
  StakeNameContainer,
  ValidatorImg,
  ValidatorName,
} from './styled';

import { ReactComponent as ArrowColorIcon } from 'src/assets/icons/common/ArrowColorIcon.svg';
import CardItem from 'src/components/Card/CardItem';
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

type IStakingCardProps = {
  index: number;
  stakeStatus: IDelegateObject;
  stakingStatus: number;
  setStakingStatus: React.Dispatch<React.SetStateAction<number>>;
};

export default function StakingCard({ index, stakeStatus, stakingStatus, setStakingStatus }: IStakingCardProps) {
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

  const onErrorImg = (e) => {
    e.target.src = DefaultValidatorIcon;
  };

  return (
    <Container data-select={isNowRow.toString()}>
      {{
        header: {
          border: false,
          dense: false,
          content: (
            <StakeNameContainer onClick={() => walletControl()}>
              <ValidatorName>
                <ValidatorImg Img={stakeStatus.img || DefaultValidatorIcon} />
                {stakeStatus.name}
              </ValidatorName>
              <ArrowImg data-select={isNowRow.toString()} Img={ArrowColorIcon} />
            </StakeNameContainer>
          ),
        },
        content: (
          <>
            <CardItem typeName="Staked amount">
              <DisplayAmount data={makeIAmountType(stakeStatus.principal, chain.denom)} size="small" />
            </CardItem>
            <CardItem typeName="Starts earning">
              <div>{`Epoch #${plus(stakeStatus.stakeActiveEpoch, 1)}`}</div>
            </CardItem>
            <CardItem typeName="Reward">
              <DisplayAmount data={makeIAmountType(stakeStatus.estimatedReward || 0, chain.denom)} size="small" />
            </CardItem>
            {isNowRow && (
              <StakeContainer>
                <StakeButton onClick={() => setStakeWalletModalView(!stakeWalletModalView)}>Stake</StakeButton>
                <StakeButton onClick={() => setUnStakeWalletModalView(!unStakeWalletModalView)}>Unstake</StakeButton>
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
              </StakeContainer>
            )}
          </>
        ),
      }}
    </Container>
  );
}
