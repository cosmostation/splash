import Image from 'src/components/common/Image';
import { styled } from '@mui/material/styles';

export const Container = styled('div')(({ theme }) => ({
  position: 'absolute',
  top: '4.8rem',
  right: '0',

  width: '19.6rem',
  background: theme.colors.base06,
  border: `0.1rem solid ${theme.colors.base02}`,
  borderRadius: '1.6rem',
  padding: '1rem',
}));

export const ValueContainer = styled('div')(({ theme }) => ({
  display: 'flex',
  flexDirection: 'column',

  fontSize: '1.4rem',
  color: theme.colors.base01,

  '& + &': {
    marginTop: '3rem',
  },
}));

export const HyperLinkButton = styled('div')(({ theme }) => ({
  cursor: 'pointer',

  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  height: '3.8rem',
  padding: '1rem',
  borderRadius: '0.6rem',

  textTransform: 'capitalize',

  '&:hover': {
    backgroundColor: theme.colors.base04,
  },
}));

export const CheckImage = styled(Image)({
  width: '1.8rem',
  height: '1.8rem',

  '& > svg': {
    width: '1.8rem',
    height: '1.8rem',
  },
});
