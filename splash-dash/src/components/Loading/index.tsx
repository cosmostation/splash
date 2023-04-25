import { ReactComponent as LoadingSpin } from 'src/assets/icons/common/LoadingSpin.svg';
import { Container, LoadingImg } from './styled';

type LoadingProps = {
  label?: string;
};

export default function Loading({ label, ...remainder }: LoadingProps) {
  return (
    <Container {...remainder}>
      <LoadingImg Img={LoadingSpin} />
      {label && <div>{label}</div>}
    </Container>
  );
}
