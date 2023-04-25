import { ClickButton, Container, CurrentWrapper, Page, PageWrapper } from './styled';
import { floor, max, min, range } from 'lodash';

import { ReactComponent as DarkFirstPageButton } from 'src/assets/icons/common/DarkFirstPageButton.svg';
import { ReactComponent as DarkLastPageButton } from 'src/assets/icons/common/DarkLastPageButton.svg';
import { ReactComponent as DarkLeftPageButton } from 'src/assets/icons/common/DarkLeftPageButton.svg';
import { ReactComponent as DarkRightPageButton } from 'src/assets/icons/common/DarkRightPageButton.svg';
import { IPaginationProps } from '..';
import { ReactComponent as LightFirstPageButton } from 'src/assets/icons/common/LightFirstPageButton.svg';
import { ReactComponent as LightLastPageButton } from 'src/assets/icons/common/LightLastPageButton.svg';
import { ReactComponent as LightLeftPageButton } from 'src/assets/icons/common/LightLeftPageButton.svg';
import { ReactComponent as LightRightPageButton } from 'src/assets/icons/common/LightRightPageButton.svg';
import { THEME_TYPE } from 'src/constant/theme';
import { device } from 'src/constant/muiSize';
import { localStorageState } from 'src/store/recoil/localStorage';
import useMediaQuery from '@mui/material/useMediaQuery';
import { useRecoilValue } from 'recoil';

const PER_PAGE = 5;
const BEFORE = floor(PER_PAGE / 2);
const AFTER = PER_PAGE - BEFORE - 1;

const getFirst = (current: number, lastPage: number): number => {
  if (current + AFTER > lastPage) {
    return max([1, lastPage - PER_PAGE + 1]) || 1;
  }
  return max([current - BEFORE, 1]) || 1;
};

const getLast = (first: number, lastPage: number): number => {
  const last = first + PER_PAGE - 1;
  return min([last, lastPage]) || 1;
};

export default function DefaultPagination({ current, lastPage, goToPage }: IPaginationProps) {
  const localStorageInfo = useRecoilValue(localStorageState);

  const isLaptop = useMediaQuery(device.laptop);

  const first = getFirst(current, lastPage);
  const last = getLast(first, lastPage);
  const pages = range(first, last + 1, 1);

  const isDarkMode = localStorageInfo.theme === THEME_TYPE.DARK;

  return (
    <Container>
      <button onClick={() => goToPage(1)}>
        <ClickButton
          Img={isDarkMode ? DarkFirstPageButton : LightFirstPageButton}
          data-inactive={(current === 1).toString()}
        />
      </button>
      <button onClick={() => current > 1 && goToPage(current - 1)}>
        <ClickButton
          Img={isDarkMode ? DarkLeftPageButton : LightLeftPageButton}
          data-inactive={(current <= 1).toString()}
        />
      </button>
      <PageWrapper>
        {isLaptop ? (
          <CurrentWrapper>{`${current} / ${lastPage}`}</CurrentWrapper>
        ) : (
          <>
            {pages.map((v, i) => (
              <button onClick={() => goToPage(v)} key={i}>
                <Page data-target={(v === current).toString()}>{v}</Page>
              </button>
            ))}
          </>
        )}
      </PageWrapper>
      <button onClick={() => current < lastPage && goToPage(current + 1)}>
        <ClickButton
          Img={isDarkMode ? DarkRightPageButton : LightRightPageButton}
          data-inactive={(current >= lastPage).toString()}
        />
      </button>
      <button onClick={() => goToPage(lastPage)} disabled={current === lastPage}>
        <ClickButton
          Img={isDarkMode ? DarkLastPageButton : LightLastPageButton}
          data-inactive={(current === lastPage).toString()}
        />
      </button>
    </Container>
  );
}
