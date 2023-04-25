import { Container, Content, Header } from './styled';

type ICardProps = {
  children: {
    content: JSX.Element;
    header?: {
      content: JSX.Element;
      border?: boolean;
      dense?: boolean;
    };
  };
};

export default function Card({ children, ...remainder }: ICardProps) {
  const header = children.header;

  return (
    <Container {...remainder}>
      {header && (
        <Header data-border={header.border?.toString()} data-dense={header.dense?.toString()}>
          {header.content}
        </Header>
      )}
      <Content>{children.content}</Content>
    </Container>
  );
}
