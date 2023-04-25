import Image from 'src/components/common/Image';
import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  justifyContent: 'center',

  height: '100%',
});

export const LoadingImg = styled(Image)({
  width: '5rem',
  height: '100%',
  marginBottom: '1rem',

  opacity: '1',
});
