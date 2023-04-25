import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Container = styled('div')(({ theme }) => ({
  display: 'flex',
  flexDirection: 'column',

  width: '100%',
  paddingLeft: '3rem',
  borderRight: `0.1rem solid ${theme.colors.base03}`,

  '&:last-child': {
    borderRight: '0',
  },

  [`@media ${device.laptop}`]: {
    padding: '1.5rem 0.6rem',
    borderRight: '0',
  },
}));

export const Header = styled('div')(({ theme }) => ({
  marginBottom: '1rem',

  color: theme.colors.base03,
  fontSize: '1.8rem',

  [`@media ${device.laptop}`]: {
    fontSize: '1.6rem',
  },
}));

export const Value = styled('div')({
  fontSize: '3.7rem',

  [`@media ${device.laptop}`]: {
    fontSize: '3rem',
  },
});
