import {
  ActionButton,
  AvailableAmount,
  AvailableWrapper,
  ContentWrapper,
  CurrentInfoValue,
  CurrentInfoWrapper,
  CurrentStakeInfo,
  EnterAmountWrapper,
  ErrorIconImg,
  HeaderImg,
  HeaderTitle,
  HyperLinkButton,
  InputAmountWrapper,
  MaxButton,
  NameWrapper,
  RiskBar,
  SelectBoxContaier,
  StakeContent,
  StakeValue,
  StakingContainer,
  StakingInfo,
  StakingModalContentWrapper,
  StakingModalHeader,
  ValidatorDataRow,
  ValidatorDataWrapper,
  ValidatorImg,
  ValidatorName,
  ValidatorNameBox,
  ValidatorStakingModalContent,
  Value,
  WarningComment,
} from './styled';
import { DEFAULT_GAS_BUDGET_FOR_STAKE, TESTNET_DEFAULT_GAS_BUDGET_FOR_STAKE } from 'src/constant/coin';
import { divide, fixed, minus, multiply, plus } from 'src/util/big';
import { formatNumber, humanFormat } from 'src/function/formatNumber';
import { isEmpty, orderBy } from 'lodash';
import { useMemo, useState } from 'react';

import { ReactComponent as ArrowColorIcon } from 'src/assets/icons/common/ArrowColorIcon.svg';
import DefaultValidatorIcon from 'src/assets/icons/validator/DefaultValidator.svg';
import DisplayAmount from 'src/components/DisplayAmount';
import Image from 'src/components/common/Image';
import backIconSVG from 'src/assets/icons/common/BackIcon.svg';
import closeIconSVG from 'src/assets/icons/common/CloseIcon.svg';
import { device } from 'src/constant/muiSize';
import errorIconSVG from 'src/assets/icons/common/ErrorIcon.svg';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { localStorageState } from 'src/store/recoil/localStorage';
import { makeIAmountType } from 'src/function/makeIAmountType';
import { reduceString } from 'src/function/stringFunctions';
import { stakeObject } from 'src/requesters/walletObject/stakeObject';
import { useGetLatestSuiSystemStateSwr } from 'src/requesters/swr/wave3/useGetLatestSuiSystemStateSwr';
import { useGetStakesSwr } from 'src/requesters/swr/wave3/useGetStakesSwr';
import { useMakeObjectsSwr } from 'src/requesters/swr/wave3/combine/useMakeObjectsSwr';
import { useMakeValidatorListSwr } from 'src/requesters/swr/wave3/combine/useMakeValidatorListSwr';
import { useMediaQuery } from '@mui/material';
import { useRecoilValue } from 'recoil';
import { useSnackbar } from 'notistack';
import { useWalletKit } from '@mysten/wallet-kit';

interface IStakingModalContentProps {
  onCloseModal: React.Dispatch<React.SetStateAction<boolean>>;
  validatorAddress: string;
}

const StakingModalContent: React.FC<IStakingModalContentProps> = ({ onCloseModal, validatorAddress }) => {
  const { enqueueSnackbar } = useSnackbar();
  const localStorageInfo = useRecoilValue(localStorageState);
  const chain = useRecoilValue(getChainInstanceState);
  const { signAndExecuteTransactionBlock, currentAccount } = useWalletKit();

  const isLaptop = useMediaQuery(device.laptop);

  const address = localStorageInfo.account?.[0] || '';
  const extensionNetwork = useMemo(() => {
    return currentAccount?.chains[0].split(':')[1];
  }, [chain, currentAccount]);

  const { data: latestSystemState } = useGetLatestSuiSystemStateSwr();
  const { data: validatorsData } = useMakeValidatorListSwr();
  const { suiAmount } = useMakeObjectsSwr(address);
  const { data: stakeData } = useGetStakesSwr(address);

  const sortValidators = useMemo(
    () => orderBy(validatorsData, [(validator) => validator.name.name === 'Cosmostation'], ['desc']),
    [validatorsData],
  );

  const [currentValidatorAddress, setCurrentValidatorAddress] = useState(validatorAddress);
  const [input, setInput] = useState('');
  const [selectBox, setSelectBox] = useState(false);
  const [isActionButton, setIsActionButton] = useState(false);

  const gasBudget = useMemo(() => {
    if (chain.network === 'testnet') {
      return TESTNET_DEFAULT_GAS_BUDGET_FOR_STAKE;
    }

    return DEFAULT_GAS_BUDGET_FOR_STAKE;
  }, [chain]);

  const stakeTokenAmount = useMemo(() => {
    return stakeData?.reduce((result, delegation) => {
      if (delegation.validatorAddress === currentValidatorAddress) {
        const targetValiStakeAmount = delegation.stakes.reduce(
          (valiResult, stake) => Number(plus(valiResult, stake.principal)),
          0,
        );

        return Number(plus(result, targetValiStakeAmount));
      }

      return result;
    }, 0);
  }, [stakeData, currentValidatorAddress]);

  const availableAmount = useMemo(() => {
    const remainAmount = Number(minus(suiAmount.amount, gasBudget, 9));
    return Number(remainAmount) < 0 ? 0 : remainAmount;
  }, [suiAmount]);

  const maxAvailable = useMemo(() => {
    return Number(divide(availableAmount, Math.pow(10, chain.decimal), 9));
  }, [availableAmount]);

  const currentValidatorInfo = useMemo(() => {
    return sortValidators?.find((v) => v.address === currentValidatorAddress);
  }, [sortValidators, currentValidatorAddress]);

  const isActiveButton =
    chain.network === extensionNetwork &&
    !isActionButton &&
    Number(input) > 0 &&
    Number(input) >= 1 &&
    Number(input) <= maxAvailable &&
    Number(input.split('.')[1]?.length || 0) <= chain.decimal;

  const callStake = async () => {
    if (!isActiveButton) {
      return;
    }

    setIsActionButton(true);

    try {
      const amount = Number(multiply(input, Math.pow(10, chain.decimal)));

      const txResult = await stakeObject(
        currentValidatorAddress,
        localStorageInfo.walletType,
        amount,
        gasBudget,
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

      setIsActionButton(false);
    } catch (e) {
      enqueueSnackbar('Failed to sign', {
        variant: 'error',
        // @ts-ignore
        errorMsg: (e as { message?: string }).message,
      });

      setIsActionButton(false);
    }
  };

  return (
    <div>
      {selectBox ? (
        <SelectBoxContaier>
          <StakingModalHeader border>
            <HeaderTitle>
              <HeaderImg onClick={() => setSelectBox(!selectBox)} src={backIconSVG} alt="return" />
              <ValidatorName>Validator select</ValidatorName>
            </HeaderTitle>
          </StakingModalHeader>
          <ValidatorStakingModalContent>
            <>
              {sortValidators.map((v, idx) => {
                return (
                  <HyperLinkButton
                    key={v.address + '/' + idx}
                    onClick={() => {
                      setCurrentValidatorAddress(v.address);
                      setSelectBox(!selectBox);
                    }}
                  >
                    <NameWrapper>
                      <ValidatorImg
                        data-risk={v?.atRisk?.toString() || 'false'}
                        Img={v?.name.logo || DefaultValidatorIcon}
                      />
                      {v?.atRisk && <RiskBar>AT RISK</RiskBar>}
                      <ContentWrapper>
                        {v?.name.name || ''}
                        {isLaptop && (
                          <ValidatorDataWrapper>
                            <ValidatorDataRow>
                              APY :
                              <Value>{Number(v?.apy) > 100000 ? reduceString(v?.apy, 3, 5) : fixed(v?.apy, 2)}%</Value>
                            </ValidatorDataRow>
                            <ValidatorDataRow>
                              Commission :<Value>{fixed(v?.commission, 2)}%</Value>
                            </ValidatorDataRow>
                          </ValidatorDataWrapper>
                        )}
                      </ContentWrapper>
                    </NameWrapper>
                    {!isLaptop && (
                      <ValidatorDataWrapper>
                        <ValidatorDataRow>
                          APY :<Value>{Number(v?.apy) > 100000 ? reduceString(v?.apy, 3, 5) : fixed(v?.apy, 2)}%</Value>
                        </ValidatorDataRow>
                        <ValidatorDataRow>
                          Commission :<Value>{fixed(v?.commission, 2)}%</Value>
                        </ValidatorDataRow>
                      </ValidatorDataWrapper>
                    )}
                  </HyperLinkButton>
                );
              })}
            </>
          </ValidatorStakingModalContent>
        </SelectBoxContaier>
      ) : (
        <>
          <StakingModalHeader>
            <>
              <HeaderTitle>Staking SUI</HeaderTitle>
              <HeaderImg onClick={() => onCloseModal(false)} src={closeIconSVG} alt="close-icon" />
            </>
          </StakingModalHeader>
          <StakingModalContentWrapper>
            <StakingContainer>
              <ValidatorNameBox onClick={() => setSelectBox(!selectBox)}>
                <NameWrapper>
                  <ValidatorImg
                    Img={currentValidatorInfo?.name.logo || DefaultValidatorIcon}
                    data-risk={currentValidatorInfo?.atRisk?.toString() || 'false'}
                  />
                  {currentValidatorInfo?.atRisk && <RiskBar>AT RISK</RiskBar>}
                  {currentValidatorInfo?.name.name || ''}
                </NameWrapper>
                <Image Img={ArrowColorIcon} />
              </ValidatorNameBox>
              <StakingInfo>
                <StakeContent>
                  Current staked
                  <StakeValue>
                    {isLaptop ? (
                      <div>
                        {humanFormat(
                          divide(currentValidatorInfo?.stake || 0, Math.pow(10, chain.decimal), chain.decimal),
                        )}
                        &nbsp;
                        {chain.denom.toUpperCase()}
                      </div>
                    ) : (
                      <DisplayAmount
                        data={makeIAmountType(currentValidatorInfo?.stake || 0, chain.denom)}
                        decimal={2}
                        size={isLaptop ? 'large' : 'sxlarge'}
                      />
                    )}
                  </StakeValue>
                </StakeContent>
                <StakeContent>
                  Your staked
                  <StakeValue>
                    <DisplayAmount
                      data={makeIAmountType(stakeTokenAmount || 0, chain.denom)}
                      decimal={2}
                      size={isLaptop ? 'large' : 'sxlarge'}
                    />
                  </StakeValue>
                </StakeContent>
                <StakeContent>
                  APY
                  <StakeValue>
                    {Number(currentValidatorInfo?.apy) > 100000
                      ? reduceString(currentValidatorInfo?.apy || '0', 3, 5)
                      : fixed(currentValidatorInfo?.apy, 2)}
                    %
                  </StakeValue>
                </StakeContent>
                <StakeContent>
                  Commission
                  <StakeValue>{fixed(currentValidatorInfo?.commission, 2)}%</StakeValue>
                </StakeContent>
              </StakingInfo>
              <InputAmountWrapper>
                <AvailableWrapper>
                  Amount
                  <AvailableAmount>
                    (Avaialble :&nbsp;
                    <DisplayAmount
                      data={makeIAmountType(availableAmount, chain.denom)}
                      size={isLaptop ? 'small' : 'large'}
                      decimal={9}
                    />
                    )
                  </AvailableAmount>
                </AvailableWrapper>
                <EnterAmountWrapper
                  placeholder="Enter amount"
                  value={input}
                  onChange={(e) => setInput(e.currentTarget.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'))}
                >
                  <MaxButton onClick={() => setInput(String(maxAvailable))}>Max</MaxButton>
                </EnterAmountWrapper>
                {chain.network !== extensionNetwork && (
                  <WarningComment>
                    <ErrorIconImg src={errorIconSVG} alt="error-icon" />
                    Switch to&nbsp;<span style={{ textTransform: 'capitalize' }}>{chain.network}</span>
                  </WarningComment>
                )}
                {!isEmpty(input) && Number(input) < 1 && (
                  <WarningComment>
                    <ErrorIconImg src={errorIconSVG} alt="error-icon" />
                    Amount must be greater than 1 SUI
                  </WarningComment>
                )}
              </InputAmountWrapper>
              <CurrentStakeInfo>
                <CurrentInfoWrapper>
                  Start earning
                  <CurrentInfoValue>{`Epoch #${formatNumber(
                    plus(latestSystemState?.epoch || 0, 1),
                  )}`}</CurrentInfoValue>
                </CurrentInfoWrapper>
                <CurrentInfoWrapper>
                  Gas fee
                  <CurrentInfoValue>
                    <DisplayAmount
                      data={makeIAmountType(gasBudget, chain.denom)}
                      decimal={7}
                      size={isLaptop ? 'small' : 'large'}
                    />
                  </CurrentInfoValue>
                </CurrentInfoWrapper>
              </CurrentStakeInfo>
              <ActionButton data-on={String(isActiveButton)} onClick={() => callStake()}>
                Stake
              </ActionButton>
            </StakingContainer>
          </StakingModalContentWrapper>
        </>
      )}
    </div>
  );
};

export default StakingModalContent;
