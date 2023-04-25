import { Container, Label, Value } from './styled';

type ICardItemProps = {
  children: JSX.Element;
  typeName: string;
};

export default function CardItem({ children, typeName, ...remainder }: ICardItemProps) {
  return (
    <Container {...remainder}>
      <Label>{typeName}</Label>
      <Value>{children}</Value>
    </Container>
  );
}
