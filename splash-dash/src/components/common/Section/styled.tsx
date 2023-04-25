import { styled } from '@mui/material/styles';

export const Container = styled('div')(({ theme }) => ({
  width: '100%',
  background: theme.colors.base05,
  borderRadius: '1.6rem',
  padding: '3rem',
  border: `0.1rem solid ${theme.colors.base02}`,
}));
