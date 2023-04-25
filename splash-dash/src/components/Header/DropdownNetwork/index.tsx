import { CheckImage, Container, HyperLinkButton, ValueContainer } from './styled';

import { ReactComponent as checkIconSVG } from 'src/assets/icons/common/CheckIcon.svg';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { getNetworks } from 'src/constant/networks';
import { useLocation } from 'react-router-dom';
import { useNavigate } from 'src/hooks/useNavigate';
import { useRecoilValue } from 'recoil';

export default function DropdownNetwork() {
  const { navigate } = useNavigate();
  const { pathname } = useLocation();

  const networks = getNetworks();
  const chain = useRecoilValue(getChainInstanceState);

  const currentTitle = `/${pathname.split('/')[2]}`;

  return (
    <Container>
      <ValueContainer>
        {networks.map((v, idx) => {
          const isCurrentNetwork = chain.network === v.network;

          return (
            <HyperLinkButton
              key={v.network + '/' + idx}
              onClick={() => {
                navigate(`/${v.network}${currentTitle}`);
              }}
            >
              {v.network}
              {isCurrentNetwork && <CheckImage Img={checkIconSVG} />}
            </HyperLinkButton>
          );
        })}
      </ValueContainer>
    </Container>
  );
}
