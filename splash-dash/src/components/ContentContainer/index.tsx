import { Container, Title } from './styled';

type ContentContainerProps = {
  title?: string;
  children: JSX.Element;
};

export default function ContentContainer({ title, children }: ContentContainerProps) {
  return (
    <Container>
      {title && <Title>{title}</Title>}
      {children}
    </Container>
  );
}
