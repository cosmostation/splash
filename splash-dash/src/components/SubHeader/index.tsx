import { Container, MenuContainer, MenuWrapper, PageTitle, SelectBar } from './styled';

import { PATH } from 'src/constant/route';
import { device } from 'src/constant/muiSize';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { menus } from 'src/constant/menu';
import { useLocation } from 'react-router-dom';
import useMediaQuery from '@mui/material/useMediaQuery';
import { useMemo } from 'react';
import { useNavigate } from 'src/hooks/useNavigate';
import { useRecoilValue } from 'recoil';

export default function SubHeader() {
  const { link } = useNavigate();
  const { pathname } = useLocation();

  const chain = useRecoilValue(getChainInstanceState);

  const isLaptop = useMediaQuery(device.laptop);

  const currentTitle = `/${pathname.split('/')[2]}`;

  const pageTitle = useMemo(() => {
    if (currentTitle === PATH.VALIDATORS) {
      return 'All validators';
    }

    return 'Dashboard';
  }, [currentTitle]);

  return (
    <Container>
      <MenuContainer>
        {isLaptop ? (
          <PageTitle>{pageTitle}</PageTitle>
        ) : (
          menus.map((v) => {
            const matchRoot = v.route === currentTitle;

            return (
              <MenuWrapper key={v.display} match-root={matchRoot.toString()} to={link(`/${chain.network}${v.route}`)}>
                {v.display}
                <SelectBar match-root={matchRoot.toString()} />
              </MenuWrapper>
            );
          })
        )}
      </MenuContainer>
    </Container>
  );
}
