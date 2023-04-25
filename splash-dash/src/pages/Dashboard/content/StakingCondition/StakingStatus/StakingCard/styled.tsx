import Button from 'src/components/common/Button';
import Card from 'src/components/Card';
import Image from 'src/components/common/Image';
import { styled } from '@mui/material/styles';
import ImgView from 'src/components/common/Img';

type SelectProps = {
  'data-select'?: string;
};

export const Container = styled(Card)<SelectProps>(({ theme, ...props }) => ({
  boxShadow: props['data-select'] === 'true' ? 'inset 0 0 0 0.2rem #3C7EFF, inset 0 0 0 0.2rem #3C7EFF' : 'none',
}));

export const StakeNameContainer = styled('div')({
  cursor: 'pointer',

  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  width: '100%',
});

export const ValidatorName = styled('div')({
  display: 'flex',
  alignItems: 'center',

  fontSize: '1.6rem',
});

export const ValidatorImg = styled(ImgView)({
  width: '3.6rem',
  maxHeight: '3.6rem',
  borderRadius: '1rem',
  marginRight: '1rem',
});

export const ArrowImg = styled(Image)<SelectProps>(({ ...props }) => ({
  cursor: 'pointer',

  transform: props['data-select'] === 'true' ? 'rotate(270deg)' : 'rotate(90deg)',
}));

export const StakeContainer = styled('div')({
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  columnGap: '1.1rem',
  alignItems: 'center',

  padding: '2rem 0 0.1rem',
});

export const StakeButton = styled(Button)({
  width: '100%',
  height: '4rem',

  fontSize: '1.4rem',
});
