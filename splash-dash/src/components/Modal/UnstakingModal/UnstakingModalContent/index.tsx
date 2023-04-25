import {
  ActionButton,
  CurrentInfoValue,
  CurrentInfoWrapper,
  CurrentStakeInfo,
  HeaderImg,
  HeaderTitle,
  NameWrapper,
  StakeContent,
  StakeValue,
  StakingContainer,
  StakingInfo,
  StakingModalContentWrapper,
  StakingModalHeader,
  ValidatorImg,
  ValidatorNameBox,
} from './styled';
import { DEFAULT_GAS_BUDGET_FOR_UNSTAKE } from 'src/constant/coin';
import { fixed, plus } from 'src/util/big';

import DefaultValidatorIcon from 'src/assets/icons/validator/DefaultValidator.svg';
import DisplayAmount from 'src/components/DisplayAmount';
import { IDelegateObject } from 'src/types/payloads/IGetDelegatedStakes';
import closeIconSVG from 'src/assets/icons/common/CloseIcon.svg';
import { device } from 'src/constant/muiSize';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { localStorageState } from 'src/store/recoil/localStorage';
import { makeIAmountType } from 'src/function/makeIAmountType';
import { unstakeObject } from 'src/requesters/walletObject/unstakeObject';
import { useGetAllBalancesSwr } from 'src/requesters/swr/wave3/useGetAllBalancesSwr';
import { useMakeValidatorListSwr } from 'src/requesters/swr/wave3/combine/useMakeValidatorListSwr';
import { useMediaQuery } from '@mui/material';
import { useMemo } from 'react';
import { useRecoilValue } from 'recoil';
import { useSnackbar } from 'notistack';
import { useWalletKit } from '@mysten/wallet-kit';

interface IUnstakingModalContentProps {
  onCloseModal: React.Dispatch<React.SetStateAction<boolean>>;
  stakeStatus: IDelegateObject;
}

const UnstakingModalContent: React.FC<IUnstakingModalContentProps> = ({ onCloseModal, stakeStatus }) => {
  const { enqueueSnackbar } = useSnackbar();
  const localStorageInfo = useRecoilValue(localStorageState);
  const chain = useRecoilValue(getChainInstanceState);

  const { signAndExecuteTransactionBlock } = useWalletKit();

  const address = localStorageInfo.account?.[0] || '';

  const { makeData: suiAmount } = useGetAllBalancesSwr(address);
  const { data: validatorsData } = useMakeValidatorListSwr();

  const currentValidatorInfo = useMemo(() => {
    return validatorsData?.find((v) => v.address === stakeStatus.validatorAddress);
  }, [validatorsData]);

  const isLaptop = useMediaQuery(device.laptop);

  const isActiveButton = stakeStatus.status !== 'Pending';

  const callUnstake = async () => {
    if (!isActiveButton) {
      return;
    } else if (Number(suiAmount?.totalBalance) < DEFAULT_GAS_BUDGET_FOR_UNSTAKE) {
      enqueueSnackbar('Transaction failed', {
        variant: 'error',
        // @ts-ignore
        errorMsg: 'Not enough balance to pay for the transaction.',
      });
      return;
    }

    try {
      const txResult = await unstakeObject(
        localStorageInfo.walletType,
        stakeStatus.stakedSuiId,
        signAndExecuteTransactionBlock,
      );

      if (txResult.effects.status.status === 'failure') {
        enqueueSnackbar('Transaction fail', {
          variant: 'error',
          // @ts-ignore
          errorMsg: txResult.effects.status.error,
          txHash: txResult.digest as string,
        });
        return;
      }

      onCloseModal(false);
      enqueueSnackbar('Transaction success', {
        variant: 'success',
        // @ts-ignore
        txHash: txResult.digest as string,
      });
    } catch (e) {
      enqueueSnackbar('Failed to sign', {
        variant: 'error',
        // @ts-ignore
        errorMsg: (e as { message?: string }).message,
      });
    }
  };

  return (
    <>
      <StakingModalHeader>
        <>
          <HeaderTitle>Unstaking object</HeaderTitle>
          <HeaderImg onClick={() => onCloseModal(false)} src={closeIconSVG} alt="close-icon" />
        </>
      </StakingModalHeader>
      <StakingModalContentWrapper>
        <StakingContainer>
          <ValidatorNameBox>
            <NameWrapper>
              <ValidatorImg Img={currentValidatorInfo?.name.logo || DefaultValidatorIcon} />
              {currentValidatorInfo?.name.name || ''}
            </NameWrapper>
          </ValidatorNameBox>
          <StakingInfo>
            <StakeContent>
              Total amount
              <StakeValue>
                <DisplayAmount
                  data={makeIAmountType(
                    plus(stakeStatus.principal || 0, stakeStatus.estimatedReward || 0, 9),
                    chain.denom,
                  )}
                  decimal={6}
                  size={isLaptop ? 'large' : 'sxlarge'}
                />
              </StakeValue>
            </StakeContent>
            <StakeContent>
              Earned
              <StakeValue>
                <DisplayAmount
                  data={makeIAmountType(stakeStatus.estimatedReward || 0, chain.denom)}
                  decimal={6}
                  size={isLaptop ? 'large' : 'sxlarge'}
                />
              </StakeValue>
            </StakeContent>
            <StakeContent>
              APY
              <StakeValue>{fixed(currentValidatorInfo?.apy, 2)}%</StakeValue>
            </StakeContent>
            <StakeContent>
              Commission
              <StakeValue>{fixed(currentValidatorInfo?.commission, 2)}%</StakeValue>
            </StakeContent>
          </StakingInfo>
          <CurrentStakeInfo>
            <CurrentInfoWrapper>
              Gas fee
              <CurrentInfoValue>
                <DisplayAmount
                  data={makeIAmountType(14265000, chain.denom)}
                  decimal={7}
                  size={isLaptop ? 'small' : 'large'}
                />
              </CurrentInfoValue>
            </CurrentInfoWrapper>
          </CurrentStakeInfo>
          <ActionButton data-on={String(isActiveButton)} onClick={() => callUnstake()}>
            Unstake
          </ActionButton>
        </StakingContainer>
      </StakingModalContentWrapper>
    </>
  );
};

export default UnstakingModalContent;
