import { Body as BaseBody, BgContainer, Container, Content } from './styled';

import Background from 'src/assets/icons/common/BackgroundImg.png';
import Header from 'src/components/Header';
import Loading from 'src/components/Loading';
import SubHeader from 'src/components/SubHeader';
import { loaderState } from 'src/store/recoil/loader';
import { useRecoilValue } from 'recoil';

type LayoutProps = {
  children: JSX.Element;
};

export default function Body({ children }: LayoutProps) {
  const showLoader = useRecoilValue(loaderState);

  return (
    <BaseBody>
      <BgContainer data-bg={Background} />
      <Container>
        <>
          {showLoader && <Loading />}
          {!showLoader && (
            <>
              <Header />

              <Content>
                <div>
                  <SubHeader />
                  {children}
                </div>
              </Content>
            </>
          )}
        </>
      </Container>
    </BaseBody>
  );
}
