import { device, heightDevice } from 'src/constant/muiSize';

import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  overflowY: 'auto',
  overflowX: 'hidden',

  padding: '1rem 0 3rem',

  [`@media ${heightDevice.laptop}`]: {
    height: '55rem',
  },

  [`@media ${device.laptop}`]: {
    padding: '1.6rem 0',
    height: 'auto',
  },
});
