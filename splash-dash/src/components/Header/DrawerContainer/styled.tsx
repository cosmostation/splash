import Button from 'src/components/common/Button';
import Image from 'src/components/common/Image';
import { styled } from '@mui/material/styles';

export const Container = styled('div')(({ theme }) => ({
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'space-between',

  height: '100%',
  width: '100%',
  backgroundColor: theme.colors.base06,

  color: theme.colors.base01,
}));

export const DrawerWrapper = styled('div')({
  height: 'calc(100% - 6.1rem)',
});

export const HeaderWrapper = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  backgroundColor: theme.colors.base05,
  borderBottom: `0.1rem solid ${theme.colors.base04}`,
  padding: '1.4rem 1.6rem',
}));

export const TitleImg = styled(Image)({
  width: '16rem',
  height: '2.8rem',

  '& > svg': {
    width: '16rem',
    height: '2.8rem',
  },
});

export const ButtonWrapper = styled('div')({
  display: 'flex',
  alignItems: 'center',
});

export const ButtonImg = styled(Image)({
  cursor: 'pointer',

  '& + &': {
    marginLeft: '1.6rem',
  },
});

export const ContentWrapper = styled('div')({
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'space-between',

  height: '100%',
});

export const NetworkWrapper = styled('div')({
  padding: '2rem',
});

export const ConnectWrapper = styled('div')({
  padding: '1.6rem',
});

export const NetworkButton = styled('div')(({ theme }) => ({
  border: '0.1rem solid transparent',
  borderRadius: '1rem',
  backgroundImage: `linear-gradient(${theme.colors.base06}, ${theme.colors.base06}), ${theme.chainAccentColors.gradient02}`,
  backgroundOrigin: 'border-box',
  backgroundClip: 'content-box, border-box',
}));

export const NetworkButtonWrapper = styled('div')({
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: ' center',

  padding: '1rem 1.2rem',

  fontSize: '1.6rem',
  textTransform: 'capitalize',
});

export const ArrowImg = styled(Image)(({ theme }) => ({
  width: '2.4rem',
  height: '2.4rem',
  marginLeft: '0.4rem',

  transform: 'rotate(270deg)',

  '& > svg': {
    width: '2.4rem',
    height: '2.4rem',
  },

  '& > svg > g > path': {
    fill: theme.colors.base03,
  },
}));

export const ConnectButtonWrapper = styled('div')({
  padding: '1.6rem',
});

export const ConnectedButton = styled('div')(({ theme }) => ({
  padding: '2rem',
  borderTop: `0.1rem solid ${theme.colors.base04}`,
}));

export const ConnectButton = styled(Button)({
  height: '5rem',

  fontSize: '1.6rem',
});
