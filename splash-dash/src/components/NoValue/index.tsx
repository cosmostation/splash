import { Container, NoValueImg } from './styled';

import { ReactComponent as NoData } from 'src/assets/icons/common/NoData.svg';

type NoValueProps = {
  comment: string;
};

export default function NoValue({ comment, ...remainder }: NoValueProps) {
  return (
    <Container {...remainder}>
      <NoValueImg Img={NoData} />
      {comment}
    </Container>
  );
}
