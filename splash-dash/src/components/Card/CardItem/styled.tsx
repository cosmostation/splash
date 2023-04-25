import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  display: 'flex',
  justifyContent: 'space-between',

  height: '1.5rem',

  fontSize: '1.4rem',

  '& + &': {
    marginTop: '1rem',
  },
});

export const Label = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  height: '1.6rem',

  color: theme.colors.base03,
}));

export const Value = styled(Label)(({ theme }) => ({
  color: theme.colors.base01,
}));
