import { Container } from './styled';
import MyAccountInfo from 'src/components/common/MyAccountInfo';
import ValidatorList from './ValidatorList';

export default function Content() {
  return (
    <Container>
      <MyAccountInfo />
      <ValidatorList />
    </Container>
  );
}
