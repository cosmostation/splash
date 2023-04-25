import ModalContent from 'src/components/common/Modal/ModalContent';
import { styled } from '@mui/material/styles';

type PercentBarProps = {
  'data-percent'?: string;
};

export const HeaderImg = styled('img')({
  cursor: 'pointer',
});

export const EpochTimestampModalContent = styled(ModalContent)(({ theme }) => ({
  margin: '-3.5rem 2rem 2rem',
  padding: '1rem 0 !important',

  color: theme.colors.base03,
  fontSize: '1.6rem',
}));

export const EpochWrapper = styled('span')(({ theme }) => ({
  marginLeft: '0.6rem',

  color: theme.colors.base01,
}));

export const ProgressBar = styled('div')(({ theme }) => ({
  position: 'relative',

  width: '100%',
  height: '0.8rem',
  backgroundColor: theme.colors.base04,
  marginTop: '1rem',
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

export const RewardWrapper = styled('div')({
  marginTop: '2rem',
});
