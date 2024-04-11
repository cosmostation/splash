import { RiskBar, ValidatorImg, ValidatorName, ValidatorNameWrapper } from './styled';

import { ReactComponent as ArrowColorIcon } from 'src/assets/icons/common/ArrowColorIcon.svg';
import Card from 'src/components/Card';
import CardItem from 'src/components/Card/CardItem';
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

export default function ValidatorCard({ validator }: IValidatorParseProps) {
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
    <Card>
      {{
        header: {
          border: false,
          dense: false,
          content: (
            <ValidatorNameWrapper onClick={() => walletControl()}>
              <ValidatorName>
                <ValidatorImg
                  data-risk={validator.atRisk?.toString() || 'false'}
                  Img={validator.name.logo || DefaultValidatorIcon}
                />
                {validator.atRisk && <RiskBar>AT RISK</RiskBar>}
                {validator.name.name}
              </ValidatorName>
              <div>
                <Image Img={ArrowColorIcon} />
                <ConnectWalletModal modalView={modalView} onCloseModal={setModalView} />
                <StakingModal
                  modalView={walletModalView}
                  onCloseModal={setWalletModalView}
                  validatorAddress={validator.address}
                />
              </div>
            </ValidatorNameWrapper>
          ),
        },
        content: (
          <>
            <CardItem typeName="Current staked">
              <DisplayAmount data={makeIAmountType(validator.stake, chain.denom)} size="small" />
            </CardItem>
            <CardItem typeName="APY / Commission">
              <div>
                {Number(validator.apy) > 100000 ? reduceString(validator.apy, 3, 5) : fixed(validator.apy, 2)} % /{' '}
                {fixed(validator.commission, 2)} %
              </div>
            </CardItem>
          </>
        ),
      }}
    </Card>
  );
}
