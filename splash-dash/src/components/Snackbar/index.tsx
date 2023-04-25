import {
  ArrowImg,
  CloseImage,
  Container,
  ContentWrapper,
  ErrorComment,
  Header,
  PercentBar,
  ProgressBar,
  ProgressWrapper,
  StatusImage,
  Title,
  ViewWrapper,
} from './styled';
import { CustomContentProps, SnackbarContent, useSnackbar } from 'notistack';
import { forwardRef, useCallback, useEffect, useState } from 'react';

import { ReactComponent as ArrowColorIcon } from 'src/assets/icons/common/ArrowColorIcon.svg';
import { ReactComponent as TransactionFail } from 'src/assets/icons/common/TransactionFail.svg';
import { ReactComponent as TransactionSuccess } from 'src/assets/icons/common/TransactionSuccess.svg';
import { ReactComponent as closeIconSVG } from 'src/assets/icons/common/CloseIcon.svg';
import { multiply } from 'src/util/big';

interface SnackbarProps extends CustomContentProps {
  txHash?: string;
  errorMsg?: string;
}

const Snackbar = forwardRef<HTMLDivElement, SnackbarProps>(({ id, ...props }, ref) => {
  const { closeSnackbar } = useSnackbar();

  const handleDismiss = useCallback(() => {
    closeSnackbar(id);
  }, [id, closeSnackbar]);

  const [timeout, setTimeout] = useState(0);

  useEffect(() => {
    let count = 0;

    setInterval(function () {
      if (count >= 10.09) {
        handleDismiss();
        return;
      }
      setTimeout(count);
      count += 0.1;
    }, 100);
  }, [setTimeout]);

  return (
    <SnackbarContent ref={ref}>
      <Container>
        <ContentWrapper>
          <Header>
            <Title>
              <StatusImage Img={props.variant === 'success' ? TransactionSuccess : TransactionFail} />
              {props.message}
            </Title>
            <CloseImage Img={closeIconSVG} onClick={handleDismiss} />
          </Header>
          {props.txHash && (
            <ViewWrapper href={`https://explorer.sui.io/transaction/${props.txHash}`} target="_blank">
              View in explorer <ArrowImg Img={ArrowColorIcon} />
            </ViewWrapper>
          )}
          {props.errorMsg && <ErrorComment>{props.errorMsg}</ErrorComment>}
        </ContentWrapper>
        <ProgressWrapper>
          <ProgressBar>
            <PercentBar data-percent={`${multiply(timeout, 10, 1)}%`} />
          </ProgressBar>
        </ProgressWrapper>
      </Container>
    </SnackbarContent>
  );
});

Snackbar.displayName = 'Snackbar';

export default Snackbar;
