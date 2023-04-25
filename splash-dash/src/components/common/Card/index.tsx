import { Container } from './styled';
import { Typography } from '@mui/material';

type CardProps = {
  children: JSX.Element;
  width?: string;
  title?: string;
  typoVarient?: 'h4' | 'h5' | 'subtitle1';
};

export default function Card({ children, title, typoVarient = 'h4', ...remainder }: CardProps) {
  return (
    <Container {...remainder} data-width={remainder.width}>
      <Typography variant={typoVarient}>{title}</Typography>
      {children}
    </Container>
  );
}
