import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  display: 'grid',
  gridTemplateColumns: '1fr 1fr 1fr',

  width: '100%',
  height: '7.4rem',
  marginBottom: '5.5rem',

  [`@media ${device.laptop}`]: {
    display: 'flex',
    flexDirection: 'column',

    height: '100%',
    marginBottom: '1rem',
  },
});
