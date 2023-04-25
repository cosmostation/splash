import Image from '../common/Image';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

type PercentBarProps = {
  'data-percent'?: string;
};

export const Container = styled('div')(({ theme }) => ({
  display: 'flex',
  justifyContent: 'space-between',
  flexDirection: 'column',

  width: '40rem',
  backgroundColor: theme.colors.base06,
  border: `0.1rem solid ${theme.colors.base02}`,
  borderRadius: '1.6rem',

  color: theme.colors.base01,
}));

export const ContentWrapper = styled('div')({
  display: 'flex',
  flexDirection: 'column',

  padding: '2rem 2.2rem',

  [`@media ${device.laptop}`]: {
    padding: '1.7rem 1.6rem 3rem',
  },
});

export const Header = styled('div')({
  display: 'flex',
  justifyContent: 'space-between',
});

export const Title = styled('div')({
  display: 'flex',
  alignItems: 'center',

  fontSize: '2.2rem',

  [`@media ${device.laptop}`]: {
    fontSize: '2rem',
  },
});

export const StatusImage = styled(Image)({
  width: '2.2rem',
  height: '2.2rem',

  marginRight: '1.2rem',

  '& > svg': {
    width: '2.2rem',
    height: '2.2rem',
  },
});

export const CloseImage = styled(Image)({
  cursor: 'pointer',

  width: '2.4rem',
  height: '2.4rem',

  '& > svg': {
    width: '2.4rem',
    height: '2.4rem',
  },
});

export const ViewWrapper = styled('a')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  marginTop: '3rem',

  color: theme.colors.base03,
  fontSize: '1.4rem',
}));

export const ErrorComment = styled('div')(({ theme }) => ({
  marginTop: '1rem',

  color: theme.colors.base03,
  fontSize: '1.6rem',

  [`@media ${device.laptop}`]: {
    fontSize: '1.4rem',
  },
}));

export const ArrowImg = styled(Image)({
  marginLeft: '0.4rem',

  width: '2.4rem',
  height: '2.4rem',

  '& > svg': {
    width: '2.4rem',
    height: '2.4rem',
  },
});

export const ProgressWrapper = styled('div')({
  padding: '0 1rem 1rem',
});

export const ProgressBar = styled('div')(({ theme }) => ({
  position: 'relative',

  width: '100%',
  height: '0.8rem',
  backgroundColor: theme.colors.base03,
  borderRadius: '0.6rem',
}));

export const PercentBar = styled('div')<PercentBarProps>(({ theme, ...props }) => ({
  position: 'absolute',
  left: '0',

  width: props['data-percent'],
  maxWidth: '100%',
  height: '0.8rem',
  background: theme.chainAccentColors.gradient01,
  borderRadius: '0.6rem',
}));
