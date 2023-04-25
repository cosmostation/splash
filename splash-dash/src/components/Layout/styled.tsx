import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Body = styled('div')({
  display: 'flex',

  overflowY: 'scroll',

  width: '120rem',
  height: '100%',
  margin: '0 auto',

  [`@media ${device.laptop}`]: {
    width: '100%',
    padding: '0 1.4rem',
  },
});
