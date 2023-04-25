import Loading from 'src/components/Loading';
import { styled } from '@mui/material/styles';

export const Container = styled('div')(({ theme }) => ({
  position: 'absolute',
  top: '4.8rem',
  right: '0',

  maxWidth: '30rem',
  background: theme.colors.base06,
  border: `0.1rem solid ${theme.colors.base02}`,
  borderRadius: '1.6rem',
  padding: '2rem',
}));

export const DisconnectButton = styled('div')(({ theme }) => ({
  cursor: 'pointer',

  marginTop: '3rem',
  border: '0.1rem solid transparent',
  borderRadius: '1rem',
  backgroundImage: `linear-gradient(${theme.colors.base06}, ${theme.colors.base06}), ${theme.chainAccentColors.gradient02}`,
  backgroundOrigin: 'border-box',
  backgroundClip: 'content-box, border-box',

  '& > div': {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',

    padding: '1.2rem 0',
  },
}));

export const ValueContainer = styled('div')(({ theme }) => ({
  display: 'flex',
  flexDirection: 'column',

  fontSize: '1.4rem',
  color: theme.colors.base03,

  '& + &': {
    marginTop: '3rem',
  },
}));

export const Value = styled('div')(({ theme }) => ({
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'center',

  marginTop: '0.8rem',

  color: theme.colors.base01,

  '& > span': {
    marginRight: '1.8rem',

    wordWrap: 'break-word',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
  },
}));

export const CopyImg = styled('img')({
  cursor: 'pointer',

  width: '2.4rem',
  height: '2.4rem',
});

export const AmountContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
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
