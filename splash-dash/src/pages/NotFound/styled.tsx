import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Container = styled('div')(({ theme }) => ({
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  justifyContent: 'center',

  width: '100%',
  minHeight: 'calc(100vh - 26.7rem)',

  fontSize: '2rem',
  color: theme.colors.base06,
}));

export const Comment = styled('p')(({ theme }) => ({
  fontFamily: 'Inter600',
  fontSize: '3rem',
  color: theme.colors.base06,

  [`@media ${device.laptop}`]: {
    fontSize: '2rem',
  },
}));
