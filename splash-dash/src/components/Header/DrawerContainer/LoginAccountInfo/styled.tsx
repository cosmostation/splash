import Loading from 'src/components/Loading';
import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
});

export const ValueContainer = styled('div')({
  display: 'flex',
  flexDirection: 'column',

  fontSize: '1.4rem',
});

export const ButtonWrapper = styled('div')({
  display: 'flex',
  alignItems: 'center',
});

export const CopyImg = styled('img')({
  cursor: 'pointer',

  width: '3.2rem',
  height: '3.2rem',

  '& + &': {
    marginLeft: '2rem',
  },
});

export const AmountContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',

  marginTop: '0.8rem',
});

export const TokenImg = styled('img')({
  cursor: 'pointer',

  width: '2rem',
  height: '2rem',
  marginRight: '0.8rem',
});

export const TokenLoading = styled(Loading)({
  height: '2rem',

  '& > span ': {
    marginBottom: '0',

    '& > svg': {
      height: '2rem',
    },
  },
});
