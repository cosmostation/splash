import { styled } from '@mui/material/styles';
import ImgView from 'src/components/common/Img';

type IValidatorImgProps = {
  'data-risk': string;
};

export const Container = styled('div')(({ theme }) => ({
  display: 'flex',
  flexDirection: 'column',

  width: '100%',
  padding: '1.6rem',

  backgroundColor: 'transparent',

  '& + &': {
    borderTop: `0.1rem solid ${theme.colors.base02}`,
  },
}));

export const ValidatorNameWrapper = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  cursor: 'pointer',
  width: '100%',
});

export const ValidatorName = styled('div')({
  position: 'relative',

  display: 'flex',
  alignItems: 'center',

  fontSize: '1.6rem',
});

export const ValidatorImg = styled(ImgView)<IValidatorImgProps>(({ ...props }) => ({
  width: '3.6rem',
  maxHeight: '3.6rem',
  borderRadius: '1rem',
  marginRight: '1rem',

  filter: props['data-risk'] === 'true' ? 'brightness(0.2)' : 'none',
}));

export const RiskBar = styled('div')(({ theme }) => ({
  position: 'absolute',
  left: '0',
  top: '35%',

  transform: 'rotate(-45deg)',

  color: theme.chainAccentColors.red,
  fontSize: '1rem',
}));
