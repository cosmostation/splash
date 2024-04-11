import Button from 'src/components/common/Button';
import Image from 'src/components/common/Image';
import { styled } from '@mui/material/styles';
import ImgView from 'src/components/common/Img';

type IValidatorImgProps = {
  'data-risk': string;
};

type SelectProps = {
  'data-select'?: string;
};

export const Container = styled('div')<SelectProps>(({ theme, ...props }) => ({
  width: '100%',
  borderBottom: `0.1rem solid ${theme.colors.base02}`,

  backgroundColor: 'transparent',
  boxShadow: props['data-select'] === 'true' ? 'inset 0 0 0 0.2rem #3C7EFF, inset 0 0 0 0.2rem #3C7EFF' : 'none',

  '&:hover': {
    backgroundColor: props['data-select'] === 'true' ? 'none' : theme.colors.base04,
  },
}));

export const RowContainer = styled('div')({
  cursor: 'pointer',

  display: 'grid',
  gridTemplateColumns: '1.2fr 1fr 1fr 1.2fr 3.2rem',
  alignItems: 'center',

  padding: '1.9rem 3rem',
  width: '100%',
});

export const NameContainer = styled('div')({
  position: 'relative',

  display: 'flex',
  alignItems: 'center',
});

export const EpochWrapper = styled('div')({
  display: 'flex',
  alignItems: 'center',
});

export const PendingComment = styled('div')({
  marginLeft: '1rem',
});

export const ValidatorImg = styled(ImgView)<IValidatorImgProps>(({ ...props }) => ({
  width: '4.2rem',
  maxHeight: '4.2rem',
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
  fontSize: '1.1rem',
}));

export const StakeContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'flex-end',

  padding: '1rem 3rem 1.9rem',
});

export const ArrowImg = styled(Image)<SelectProps>(({ ...props }) => ({
  transform: props['data-select'] === 'true' ? 'rotate(270deg)' : 'rotate(90deg)',
}));

export const StakeButton = styled(Button)({
  width: '16rem',
  height: '4.4rem',
  borderRadius: '1rem',

  fontSize: '1.6rem',

  '& + &': {
    marginLeft: '1rem',
  },
});
