import { EmptyContainer, HeaderContainer, StakeNowButton, ValidatorsContainer, ValidatorsList } from './styled';
import { isEmpty, orderBy } from 'lodash';

import { IDelegateObject } from 'src/types/payloads/IGetDelegatedStakes';
import StakingCard from './StakingCard';
import StakingModal from 'src/components/Modal/StakingModal';
import StakingRow from './StakingRow';
import { device } from 'src/constant/muiSize';
import useMediaQuery from '@mui/material/useMediaQuery';
import { useMemo, useState } from 'react';
import { useMakeValidatorListSwr } from 'src/requesters/swr/wave3/combine/useMakeValidatorListSwr';

type IStakingStatusProps = {
  delegatedStakes?: IDelegateObject[];
};

export default function StakingStatus({ delegatedStakes }: IStakingStatusProps) {
  const isLaptop = useMediaQuery(device.laptop);

  const [stakingStatus, setStakingStatus] = useState(-1);
  const [stakeWalletModalView, setStakeWalletModalView] = useState(false);
  const { data: validatorsData } = useMakeValidatorListSwr();

  const sortValidators = orderBy(
    delegatedStakes,
    [(delegate) => delegate.stakeRequestEpoch, (delegate) => delegate.principal],
    ['desc', 'desc'],
  );

  const targetValidator = useMemo(() => {
    const getValidator = validatorsData.find((v) => v.name.name === 'Cosmostation');

    if (getValidator) {
      return getValidator.address;
    }

    return validatorsData[0]?.address;
  }, [validatorsData]);

  return (
    <div>
      {isEmpty(delegatedStakes) ? (
        <EmptyContainer>
          No staking detected. Stake $SUI to start receiving staking rewards.
          <StakeNowButton onClick={() => setStakeWalletModalView(!stakeWalletModalView)}>Stake now</StakeNowButton>
          <StakingModal
            modalView={stakeWalletModalView}
            onCloseModal={setStakeWalletModalView}
            validatorAddress={targetValidator}
          />
        </EmptyContainer>
      ) : (
        <div>
          {isLaptop ? (
            <ValidatorsList>
              {sortValidators?.map((v, idx) => (
                <StakingCard
                  key={idx}
                  index={idx}
                  stakeStatus={v}
                  stakingStatus={stakingStatus}
                  setStakingStatus={setStakingStatus}
                />
              ))}
            </ValidatorsList>
          ) : (
            <ValidatorsContainer>
              <HeaderContainer>
                <li>Validators</li>
                <li>Staked amount</li>
                <li>Starts earning</li>
                <li>Reward</li>
                <li></li>
              </HeaderContainer>
              <ValidatorsList>
                {sortValidators?.map((v, idx) => (
                  <StakingRow
                    key={idx}
                    index={idx}
                    stakeStatus={v}
                    stakingStatus={stakingStatus}
                    setStakingStatus={setStakingStatus}
                  />
                ))}
              </ValidatorsList>
            </ValidatorsContainer>
          )}
        </div>
      )}
    </div>
  );
}
