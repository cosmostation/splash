import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

type IContainerProps = {
  'data-border': string;
};

export const Container = styled('div')<IContainerProps>(({ theme, ...props }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  padding: '3rem 3rem 2rem',
  borderBottom: props['data-border'] === 'true' ? `0.1rem solid ${theme.colors.base02}` : 0,

  [`@media ${device.laptop}`]: {
    padding: '1.6rem',
  },
}));
