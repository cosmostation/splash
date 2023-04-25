import { Link } from 'react-router-dom';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

type MenuContainerProps = {
  'match-root'?: string;
};

export const Container = styled('div')({
  width: '100%',
  marginBottom: '5.85rem',

  [`@media ${device.laptop}`]: {
    marginBottom: '3rem',
  },
});

export const MenuContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',

  width: '120rem',
  margin: '11.2rem auto 0',

  [`@media ${device.laptop}`]: {
    width: '100%',
    padding: '0 1.6rem',
    margin: '9.6rem auto 0',
  },
});

export const MenuWrapper = styled(Link)<MenuContainerProps>(({ theme, ...props }) => ({
  cursor: 'pointer',

  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',

  padding: '4rem 0 1.4rem',
  marginRight: '7rem',

  color: props['match-root'] === 'true' ? theme.colors.base01 : theme.colors.base03,
  fontSize: '3.6rem',

  '&:hover': {
    color: theme.colors.base01,
  },
}));

export const SelectBar = styled('div')<MenuContainerProps>(({ theme, ...props }) => ({
  background: props['match-root'] === 'true' ? theme.chainAccentColors.gradient02 : 'transparent',
  width: '-webkit-fill-available',
  height: '0.3rem',
  marginTop: '1rem',
  borderRadius: '1rem',
}));

export const PageTitle = styled('div')({
  fontSize: '3.6rem',
});
