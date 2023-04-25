import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const ButtonContainer = styled('button')(({ theme }) => ({
  cursor: 'pointer',

  width: '100%',
  background: theme.chainAccentColors.gradient01,
  borderRadius: '1rem',
  padding: '1.1rem 3.5rem',

  color: theme.colors.base01,

  [`@media ${device.laptop}`]: {
    padding: '1.5rem 0',
    borderRadius: '0.8rem',
  },

  '& svg': {
    fill: 'white',
  },

  '&:disabled': {
    backgroundColor: theme.colors.base04,
    color: theme.colors.base03,

    cursor: 'default',

    '& svg': {
      fill: theme.colors.base03,
    },
  },
}));

export const ContentContainer = styled('div')({
  display: 'flex',
  justifyContent: 'center',
  alignItems: 'center',
});
