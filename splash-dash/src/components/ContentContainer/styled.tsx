import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  width: '100%',
  height: 'fit-content',

  marginBottom: '8.6rem',
});

export const Title = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  marginBottom: '2rem',

  fontFamily: 'Inter600',
  fontSize: '3rem',

  [`@media ${device.laptop}`]: {
    marginBottom: '1.5rem',

    fontSize: '1.8rem',
  },
});
