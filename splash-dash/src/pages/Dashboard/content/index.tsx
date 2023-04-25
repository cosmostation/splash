import { Container } from './styled';
import MyAccountInfo from 'src/components/common/MyAccountInfo';
import StakingCondition from './StakingCondition';

export default function Content() {
  return (
    <Container>
      <MyAccountInfo />
      <StakingCondition />
    </Container>
  );
}
