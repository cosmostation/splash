import ModalContent from 'src/components/common/Modal/ModalContent';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const HeaderTitle = styled('div')({
  fontSize: '3rem',

  [`@media ${device.laptop}`]: {
    fontSize: '2.2rem',
  },
});

export const HeaderImg = styled('img')({
  cursor: 'pointer',
});

export const WalletConnectModalContent = styled(ModalContent)({
  padding: '3rem',

  [`@media ${device.laptop}`]: {
    // marginTop: '-4rem',
    padding: '0 0 3rem',
  },
});
