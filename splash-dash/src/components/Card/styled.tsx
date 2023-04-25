import { styled } from '@mui/material/styles';

type HeaderProps = {
  'data-dense'?: string;
  'data-border'?: string;
};

export const Container = styled('div')(({ theme }) => ({
  display: 'flex',
  flexFlow: 'column',

  width: '100%',
  height: 'fit-content',
  padding: '1.6rem',
  borderBottom: `0.1rem solid ${theme.colors.base02}`,

  fontSize: '1.4rem',

  '&:last-child': {
    borderBottom: '0',
  },
}));

export const Header = styled('div')<HeaderProps>(({ theme, ...props }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  height: props['data-dense'] === 'true' ? '2rem' : 'auto',
  paddingBottom: props['data-dense'] === 'true' ? '0.1rem' : '1.6rem',
  borderBottom: props['data-border'] === 'true' ? `0.1rem solid ${theme.colors.base02}` : 0,
}));

export const Content = styled('div')({
  paddingTop: '1rem',
});
