import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

type SelectButtonProps = {
  'data-active'?: string;
};

export const Container = styled('div')({
  marginBottom: '2.45rem',

  [`@media ${device.laptop}`]: {
    marginBottom: '0',
  },
});

export const TitleContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  [`@media ${device.laptop}`]: {
    flexDirection: 'column',
    alignItems: 'flex-start',
  },
});

export const SelectButtonContainer = styled('div')(({ theme }) => ({
  display: 'flex',
  justifyContent: 'flex-end',

  border: `0.1rem solid ${theme.colors.base03}`,
  borderRadius: '0.5rem',
  padding: '0.4rem',
  backgroundColor: theme.colors.base02,

  [`@media ${device.laptop}`]: {
    width: '100%',
    marginTop: '1rem',
  },
}));

export const SelectButton = styled('button')<SelectButtonProps>(({ theme, ...props }) => ({
  cursor: 'pointer',

  borderRadius: '0.5rem',
  width: '9rem',
  height: '2.4rem',
  backgroundColor: props['data-active'] === 'true' ? theme.colors.base06 : 'none',

  fontFamily: 'Inter600',
  color: props['data-active'] === 'true' ? theme.colors.base01 : theme.colors.base04,
  fontSize: '1.1rem',
  marginRight: '0.5rem',

  '&:last-child': {
    marginRight: '0',
  },

  [`@media ${device.laptop}`]: {
    width: '100%',
    height: '2.2rem',
  },
}));
