import { Container, Label, Value } from './styled';

type InfoRowProps = {
  label: string;
  children: JSX.Element;
};

export default function InfoRow({ label, children, ...remainder }: InfoRowProps) {
  return (
    <Container {...remainder}>
      <Label>{label}</Label>
      <Value>{children}</Value>
    </Container>
  );
}
