import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  display: 'flex',
  flexDirection: 'column',

  padding: '2.6rem 1.2rem',
});

export const MenuContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  fontSize: '2rem',

  '& + &': {
    marginTop: '3rem',
  },
});
