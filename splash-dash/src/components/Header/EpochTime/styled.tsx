import { styled } from '@mui/material/styles';

type PercentBarProps = {
  'data-percent'?: string;
};

export const EpochHeaderContainer = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  width: '120rem',
  height: '4rem',
  margin: '0 auto',

  color: theme.colors.base03,
}));

export const EpochInfo = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  marginLeft: '0.8rem',

  color: theme.colors.base01,
  whiteSpace: 'nowrap',
}));

export const ProgressBar = styled('div')(({ theme }) => ({
  position: 'relative',

  width: '100%',
  height: '0.8rem',
  backgroundColor: theme.colors.base04,
  margin: '0 2rem 0 1.4rem',
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

export const EpochCountdownContainer = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  paddingLeft: '2rem',
  borderLeft: `0.1rem solid ${theme.colors.base02}`,

  whiteSpace: 'nowrap',
}));
