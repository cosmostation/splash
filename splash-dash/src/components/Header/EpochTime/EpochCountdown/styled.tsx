import Image from 'src/components/common/Image';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Container = styled('div')({
  minWidth: '7.5rem',
});

export const CurrentEpochEndContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  width: '100%',
  marginLeft: '0.8rem',

  [`@media ${device.laptop}`]: {
    margin: '0.4rem 0 0',
    width: '10rem',
  },
});

export const EpochLoadingContainer = styled(CurrentEpochEndContainer)({
  justifyContent: 'center',
});

export const EndContainer = styled('div')({
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  justifyContent: 'center',
});

export const Time = styled('div')(({ theme }) => ({
  fontSize: '1.6rem',
  color: theme.colors.base01,
}));

export const LoadingImg = styled(Image)({
  width: '5rem',
  height: '100%',

  '& > svg': {
    height: '2rem',
  },
});
