import { Container } from './styled';

type SectionProps = {
  children: JSX.Element;
};

export default function Section({ children, ...remainder }: SectionProps) {
  return <Container {...remainder}>{children}</Container>;
}
