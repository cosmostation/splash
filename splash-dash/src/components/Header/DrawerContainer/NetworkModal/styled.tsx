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
});

export const HyperLinkButton = styled('div')({
  cursor: 'pointer',

  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'center',

  borderRadius: '0.6rem',
  padding: '0 1.6rem',
  height: '2.4rem',

  fontSize: '1.8rem',
  textTransform: 'capitalize',

  '& + &': {
    marginTop: '2.5rem',
  },
});
