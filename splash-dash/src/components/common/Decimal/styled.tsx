import { styled } from '@mui/material/styles';

type StyledDecimalProps = {
  'data-size'?: string;
};

export const Container = styled('div')({
  display: 'flex',
  alignItems: 'baseline',
});

export const UpperDecimal = styled('span')<StyledDecimalProps>(({ ...props }) => ({
  fontSize: props['data-size'],
}));

export const LowDecimal = styled('span')<StyledDecimalProps>(({ ...props }) => ({
  fontSize: props['data-size'],
}));
