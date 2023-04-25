import Image from 'src/components/common/Image';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

type ClickButtonProps = {
  'data-inactive'?: string;
};

type PageProps = {
  'data-target': string;
};

export const Container = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'flex-start',
  marginTop: '2.2rem',

  '& > button + button': {
    marginLeft: '1rem',
  },

  [`@media ${device.laptop}`]: {
    marginTop: '0.9rem',
    width: '100%',

    '& > button + button': {
      marginLeft: '0.7rem',
    },
  },
});

export const ClickButton = styled(Image)<ClickButtonProps>(({ theme, ...props }) => ({
  width: '2.4rem',
  height: '100%',
  objectFit: 'fill',

  cursor: props['data-inactive'] === 'true' ? 'not-allowed' : 'pointer',
  filter: props['data-inactive'] === 'true' ? 'opacity(0.5)' : 'none',
}));

export const PageWrapper = styled('div')({
  display: 'flex',
  justifyContent: 'flex-start',
  marginLeft: '1rem',

  [`@media ${device.laptop}`]: {
    width: '100%',
    margin: '0 0.6rem',
  },
});

export const Page = styled('p')<PageProps>(({ theme, ...props }) => ({
  cursor: 'pointer',

  marginRight: '2.1rem',

  fontFamily: 'Inter600',
  fontSize: '1.3rem',
  fontStretch: 'normal',
  textAlign: 'left',
  color: props['data-target'] === 'true' ? theme.colors.base06 : theme.colors.base04,
}));

export const CurrentWrapper = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',

  width: '100%',
  height: '100%',
  backgroundColor: theme.colors.base01,
  border: `0.1rem solid ${theme.colors.base03}`,
  borderRadius: '0.2rem',
  padding: '0.3rem 0',

  fontSize: '1.3rem',
}));
