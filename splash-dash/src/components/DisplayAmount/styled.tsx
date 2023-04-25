import { styled } from '@mui/material/styles';

type DenomProps = {
  'denom-size': string;
};

export const Container = styled('div')({
  display: 'flex',
  alignItems: 'center',
});

export const Denom = styled('span')<DenomProps>(({ ...props }) => ({
  marginLeft: '0.5rem',

  fontSize: props['denom-size'],
}));
