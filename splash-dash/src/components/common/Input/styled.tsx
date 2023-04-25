import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const InputContainer = styled('div')<any>({
  width: '100%',
});

export const InputContent = styled('input')(({ theme }) => ({
  width: '100%',
  overflow: 'hidden',

  border: `0.1rem solid ${theme.colors.base02}`,
  padding: '2.2rem 3rem',

  backgroundColor: `${theme.colors.base07}`,
  color: theme.colors.base01,

  '&:hover': {
    border: `0.1rem solid ${theme.colors.base01}`,
  },

  '&:focus': {
    border: `0.1rem solid ${theme.colors.base01}`,
  },

  '&::placeholder': {
    color: theme.colors.base02,
  },

  [`@media ${device.laptop}`]: {
    padding: '1.9rem 1.6rem',
  },
}));
