import { Container } from './styled';
import React from 'react';

interface IModalHeaderProps {
  border?: boolean;
  children: JSX.Element;
}

const ModalHeader: React.FC<IModalHeaderProps> = ({ border = false, children, ...remainder }) => {
  return (
    <Container {...remainder} data-border={border.toString()}>
      {children}
    </Container>
  );
};

export default ModalHeader;
