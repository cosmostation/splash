import { Container, Header, Value } from './styled';

type IMyAccountInfoProps = {
  title: string;
  children: JSX.Element;
};

export default function AmountInfoCard({ title, children }: IMyAccountInfoProps) {
  return (
    <Container>
      <Header>{title}</Header>
      <Value>{children}</Value>
    </Container>
  );
}
