import { Container, MenuContainer } from './styled';

import Image from 'src/components/common/Image';
import { ReactComponent as checkIconSVG } from 'src/assets/icons/common/CheckIcon.svg';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { menus } from 'src/constant/menu';
import { useLocation } from 'react-router-dom';
import { useNavigate } from 'src/hooks/useNavigate';
import { useRecoilValue } from 'recoil';

type IMenuDropdownProps = {
  setDrawer: (value: React.SetStateAction<boolean>) => void;
};

export default function MenuDropdown({ setDrawer }: IMenuDropdownProps) {
  const chain = useRecoilValue(getChainInstanceState);

  const { navigate } = useNavigate();
  const { pathname } = useLocation();

  return (
    <Container>
      {menus.map((v) => {
        const currentTitle = `/${pathname.split('/')[2] || ''}`;

        return (
          <MenuContainer
            key={v.display}
            onClick={() => {
              navigate(`/${chain.network}${v.route}`);
              setDrawer(false);
            }}
          >
            {v.display}
            {currentTitle === v.route && <Image Img={checkIconSVG} />}
          </MenuContainer>
        );
      })}
    </Container>
  );
}
