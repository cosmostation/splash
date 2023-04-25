import { styled } from '@mui/material/styles';

type IContentProps = {
  'data-bg': string;
};

export const Body = styled('div')(({ theme }) => ({
  position: 'relative',

  display: 'flex',
  width: '100%',
  minHeight: '100vh',

  color: theme.colors.base01,
  overflow: 'hidden',

  // snackbar
  '& > .SnackbarContainer-root': {
    bottom: '2.4rem !important',

    '& .SnackbarContent-root': {
      fontFamily: theme.typography.h6.fontFamily,
      fontStyle: theme.typography.h6.fontStyle,
      fontSize: theme.typography.h6.fontSize,
      lineHeight: theme.typography.h6.lineHeight,
      letterSpacing: theme.typography.h6.letterSpacing,

      borderRadius: '0.8rem',

      minWidth: '29.2rem',

      minHeight: '4rem',

      paddingTop: 0,
      paddingBottom: 0,

      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',

      '& svg': {
        fill: 'white',

        marginRight: '0.4rem',

        minWidth: '1.6rem',
        height: '1.6rem',
      },

      '&.SnackbarItem-variantSuccess': {
        backgroundColor: theme.accentColors.green,
        color: 'white',
      },

      '&.SnackbarItem-variantError': {
        backgroundColor: theme.accentColors.red,
        color: 'white',
      },
    },
  },

  'div::-webkit-scrollbar': {
    width: '0.1rem',
    height: '0.1rem',
    backgroundColor: 'transparent',
  },
  'div::-webkit-scrollbar-thumb': {
    backgroundColor: theme.colors.base05,
  },
  'div::-webkit-scrollbar-corner': {
    backgroundColor: 'transparent',
  },
}));

export const BgContainer = styled('div')<IContentProps>(({ ...props }) => ({
  zIndex: '-1',

  position: 'absolute',
  top: 0,
  right: 0,

  width: '100%',
  height: '100%',
  maxWidth: '100%',

  backgroundAttachment: 'fixed',
  backgroundImage: `url(${props['data-bg']})`,
  backgroundRepeat: 'no-repeat',
  backgroundSize: 'cover',
  backgroundPosition: 'center',
}));

export const Container = styled('div')({
  width: '100%',
  minHeight: '100vh',
  maxWidth: '100%',
});

export const Content = styled('div')({
  minHeight: 'calc(100vh - 11.2rem)',
  minWidth: '100%',
});
