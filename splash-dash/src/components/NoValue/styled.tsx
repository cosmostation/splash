import Image from 'src/components/common/Image';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  justifyContent: 'center',

  height: '20rem',

  fontFamily: 'Inter600',
  fontSize: '1.8rem',

  [`@media ${device.laptop}`]: {
    fontSize: '1.5rem',
  },
});

export const NoValueImg = styled(Image)({
  marginBottom: '1rem',

  [`@media ${device.laptop}`]: {
    marginBottom: '0.4rem',
  },
});
