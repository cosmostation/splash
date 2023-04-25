import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  fontSize: '1.5rem',

  [`@media ${device.laptop}`]: {
    fontSize: '1.2rem',
    wordBreak: 'break-all',
  },
});
