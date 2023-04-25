import { styled } from '@mui/material/styles';

type StyledContainerProps = {
  'data-width'?: string;
};

export const Container = styled('div')<StyledContainerProps>(({ theme, ...props }) => ({
  width: props['data-width'] ? props['data-width'] : '100%',
  backgroundColor: theme.colors.base01,
  borderRadius: '0.8rem',

  fontSize: '1.2rem',

  padding: '2rem',
}));
