import Image from 'src/components/common/Image';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';
import ImgView from 'src/components/common/Img';

export const Container = styled('div')({
  width: '100%',
});

export const ConnectContent = styled('div')(({ theme }) => ({
  cursor: 'pointer',

  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  background: theme.colors.base05,
  padding: '2rem',
  borderRadius: '1rem',

  fontSize: '2.2rem',

  '&:hover': {
    background: theme.colors.base04,
  },

  '& + &': {
    marginTop: '2rem',
  },

  [`@media ${device.laptop}`]: {
    margin: '0 1rem',
    padding: '1rem',

    fontSize: '2rem',

    '& + &': {
      marginTop: '1rem',
    },
  },
}));

export const WalletImg = styled(ImgView)({
  cursor: 'pointer',

  width: '6.4rem',
  height: '6.4rem',

  [`@media ${device.laptop}`]: {
    width: '4.8rem',
    height: '4.8rem',
  },
});

export const WalletName = styled('div')(({ theme }) => ({
  marginLeft: '2rem',

  '& > div': {
    marginTop: '0.6rem',

    fontSize: '1.8rem',
    color: theme.colors.base03,

    [`@media ${device.laptop}`]: {
      fontSize: '1.4rem',
    },
  },

  [`@media ${device.laptop}`]: {
    marginLeft: '1rem',

    fontSize: '1.6rem',
  },
}));

export const ConnectContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',

  [`@media ${device.laptop}`]: {
    width: '100%',
  },
});

export const ArrowImg = styled(Image)({
  transform: 'rotate(270deg)',
});
