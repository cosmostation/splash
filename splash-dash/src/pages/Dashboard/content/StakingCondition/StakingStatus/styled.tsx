import Button from 'src/components/common/Button';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const EmptyContainer = styled('div')(({ theme }) => ({
  display: 'flex',
  flexDirection: 'column',

  padding: '0 3rem',

  fontSize: '1.8rem',
  color: theme.colors.base03,

  [`@media ${device.laptop}`]: {
    padding: '0 1.6rem',

    fontSize: '1.6rem',
  },
}));

export const StakeNowButton = styled(Button)({
  marginTop: '5rem',
  width: '16rem',
  height: '4.4rem',
  borderRadius: '1rem',

  fontSize: '1.6rem',

  [`@media ${device.laptop}`]: {
    width: '100%',
    height: '5rem',
  },
});

export const ValidatorsContainer = styled('div')({
  fontSize: '1.8rem',
});

export const HeaderContainer = styled('ul')(({ theme }) => ({
  display: 'grid',
  gridTemplateColumns: '1.2fr 1fr 1fr 1.2fr 3.2rem',

  padding: '2.2rem 3rem',
  borderBottom: `0.1rem solid ${theme.colors.base02}`,

  color: theme.colors.base03,
}));

export const ValidatorsList = styled('div')({
  display: 'flex',
  flexDirection: 'column',
});
