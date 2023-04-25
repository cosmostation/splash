import { Container } from './styled';

interface IModalContentProps {
  children: JSX.Element;
}

const ModalContent: React.FC<IModalContentProps> = ({ children, ...remainder }) => {
  return <Container {...remainder}>{children}</Container>;
};

export default ModalContent;
