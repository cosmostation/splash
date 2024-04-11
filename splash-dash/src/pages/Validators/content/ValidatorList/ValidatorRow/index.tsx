import { Container, NameContainer, RiskBar, ValidatorImg } from './styled';

import { ReactComponent as ArrowColorIcon } from 'src/assets/icons/common/ArrowColorIcon.svg';
import ConnectWalletModal from 'src/components/Header/ConnectWalletModal';
import DefaultValidatorIcon from 'src/assets/icons/validator/DefaultValidator.svg';
import DisplayAmount from 'src/components/DisplayAmount';
import { IValidatorParseProps } from 'src/function/parseValidator';
import Image from 'src/components/common/Image';
import StakingModal from 'src/components/Modal/StakingModal';
import { fixed } from 'src/util/big';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { localStorageState } from 'src/store/recoil/localStorage';
import { makeIAmountType } from 'src/function/makeIAmountType';
import { reduceString } from 'src/function/stringFunctions';
import { useRecoilValue } from 'recoil';
import { useState } from 'react';

export default function ValidatorList({ validator }: IValidatorParseProps) {
  const localStorageInfo = useRecoilValue(localStorageState);
  const chain = useRecoilValue(getChainInstanceState);

  const [modalView, setModalView] = useState(false);
  const [walletModalView, setWalletModalView] = useState(false);

  const walletControl = () => {
    if (localStorageInfo.isConnect) {
      setWalletModalView(!walletModalView);
      return;
    }

    setModalView(!modalView);
  };

  return (
    <>
      <Container onClick={() => walletControl()}>
        <NameContainer>
          <ValidatorImg
            data-risk={validator.atRisk?.toString() || 'false'}
            Img={validator.name.logo || DefaultValidatorIcon}
          />
          {validator.atRisk && <RiskBar>AT RISK</RiskBar>}
          <span>{validator.name.name}</span>
        </NameContainer>
        <div>
          <DisplayAmount data={makeIAmountType(validator.stake, chain.denom)} size="large" />
        </div>
        <div>
          <DisplayAmount data={makeIAmountType(validator.nextEpochStake, chain.denom)} size="large" />
        </div>
        <div>{Number(validator.apy) > 100000 ? reduceString(validator.apy, 3, 5) : fixed(validator.apy, 2)}%</div>
        <div>{fixed(validator.commission, 2)}%</div>
        <div>
          <Image Img={ArrowColorIcon} />
        </div>
      </Container>
      <ConnectWalletModal modalView={modalView} onCloseModal={setModalView} />
      <StakingModal
        modalView={walletModalView}
        onCloseModal={setWalletModalView}
        validatorAddress={validator.address}
      />
    </>
  );
}
