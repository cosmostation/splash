import { styled } from '@mui/material/styles';
import ImgView from 'src/components/common/Img';

type IValidatorImgProps = {
  'data-risk': string;
};

export const Container = styled('div')(({ theme }) => ({
  cursor: 'pointer',

  display: 'grid',
  gridTemplateColumns: '1.5fr 1.5fr 1.5fr 0.8fr 1fr 3.2rem',
  alignItems: 'center',

  width: '100%',
  borderBottom: `0.1rem solid ${theme.colors.base02}`,
  padding: '1.9rem 3rem',

  backgroundColor: 'transparent',

  '&:hover': {
    backgroundColor: theme.colors.base04,
  },
}));

export const NameContainer = styled('div')({
  position: 'relative',

  display: 'flex',
  alignItems: 'center',

  '& > span': {
    maxWidth: '18rem',

    overflow: 'hidden',
    textOverflow: 'ellipsis',
    whiteSpace: 'nowrap',
  },
});

export const ValidatorImg = styled(ImgView)<IValidatorImgProps>(({ ...props }) => ({
  width: '4.2rem',
  maxHeight: '4.2rem',
  borderRadius: '1rem',
  marginRight: '1.6rem',

  filter: props['data-risk'] === 'true' ? 'brightness(0.2)' : 'none',
}));

export const RiskBar = styled('div')(({ theme }) => ({
  position: 'absolute',
  left: '0',
  top: '35%',

  transform: 'rotate(-45deg)',

  color: theme.chainAccentColors.red,
  fontSize: '1.1rem',
}));
