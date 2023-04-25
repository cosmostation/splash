import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  display: 'flex',

  marginBottom: '2.4rem',

  fontSize: '1.5rem',

  '&:last-child': {
    marginBottom: '0',
  },

  [`@media ${device.laptop}`]: {
    flexDirection: 'column',

    marginBottom: '2rem',

    fontSize: '1.2rem',
  },
});

export const Label = styled('div')({
  display: 'flex',

  maxWidth: '24.4rem',
  minWidth: '24.4rem',

  fontFamily: 'Inter600',

  [`@media ${device.laptop}`]: {
    marginBottom: '0.6rem',
  },
});

export const Value = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  color: theme.colors.base05,
  wordBreak: 'break-all',
  overflowWrap: 'anywhere',
}));
