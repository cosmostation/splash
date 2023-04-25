import Image from 'src/components/common/Image';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

type PercentBarProps = {
  'data-percent'?: string;
};

export const Container = styled('div')(({ theme }) => ({
  zIndex: '1101',
  position: 'fixed',
  top: '0',
  left: '0',

  width: '100%',
  backgroundColor: '#001F52',

  fontSize: '1.4rem',

  [`@media ${device.laptop}`]: {
    borderBottom: `0.1rem solid ${theme.colors.base04}`,
  },
}));

export const EpochContainer = styled('div')(({ theme }) => ({
  zIndex: '1100',
  position: 'fixed',
  top: '7.2rem',
  left: '0',

  width: '100%',
  backgroundColor: theme.colors.base06,

  fontSize: '1.6rem',

  [`@media ${device.laptop}`]: {
    display: 'none',
  },
}));

export const HeaderContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  width: '120rem',
  height: '7.2rem',
  margin: '0 auto',

  [`@media ${device.laptop}`]: {
    width: '100%',
    height: '5.6rem',
    padding: '0 1.6rem',
  },
});

export const ConnectButton = styled('div')(({ theme }) => ({
  cursor: 'pointer',

  width: '100%',
  height: '4rem',
  background: theme.chainAccentColors.gradient01,
  borderRadius: '1rem',
  padding: '1.1rem 3.5rem',

  color: theme.colors.base01,

  '& >  button': {
    boxShadow: 'none',
    backgroundColor: 'transparent',
    padding: '0',

    fontFamily: 'Quicksans700',
    fontSize: '1.4rem',
    color: theme.colors.base01,
  },
}));

export const ChainHeaderRight = styled('div')({
  display: 'flex',
  alignItems: 'center',
});

export const ConnectedButton = styled('div')(({ theme }) => ({
  position: 'relative',

  height: '4rem',
  border: '0.1rem solid transparent',
  borderRadius: '1rem',
  backgroundImage: `linear-gradient(#001F52, #001F52), ${theme.chainAccentColors.gradient02}`,
  backgroundOrigin: 'border-box',
  backgroundClip: 'content-box, border-box',
}));

export const NetworkButton = styled(ConnectedButton)({
  marginRight: '1rem',
});

export const ButtonWrapper = styled('div')({
  cursor: 'pointer',

  display: 'flex',
  alignItems: 'center',

  height: '100%',
  padding: '0.8rem 1.2rem',

  textTransform: 'capitalize',
});

export const ArrowImg = styled(Image)({
  width: '2.4rem',
  height: '2.4rem',
  marginLeft: '0.4rem',

  '& > svg': {
    width: '2.4rem',
    height: '2.4rem',
  },
});

export const ChainPriceContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',

  paddingRight: '1.5rem',

  fontFamily: 'Inter600',
  fontSize: '1.3rem',

  [`@media ${device.laptop}`]: {
    paddingRight: '0',

    fontSize: '1.1rem',
  },
});

export const DashIcon = styled(Image)({
  [`@media ${device.laptop}`]: {
    width: '16rem',
  },
});

export const MobileHeaderButtonWrapper = styled('div')({
  display: 'flex',
  alignItems: 'center',
});

export const MobileHeaderButton = styled(Image)({
  cursor: 'pointer',

  '& + &': {
    marginLeft: '2rem',
  },
});
