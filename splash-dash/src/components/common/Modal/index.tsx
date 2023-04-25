import { ModalContent, Overlay } from './styled';
import React, { useCallback, useEffect, useState } from 'react';
import { first, isFunction } from 'lodash';

interface IModalProps {
  open: boolean;
  children: JSX.Element;
  onClose: React.Dispatch<React.SetStateAction<boolean>>;
}

const Modal: React.FC<IModalProps> = ({ open, children, onClose }) => {
  const [visibility, setVisibility] = useState(false);

  useEffect(() => {
    setVisibility(open);

    // Disable scroll of background content
    const body = first(document.getElementsByTagName('body'));

    if (open && body) {
      body.style.overflow = 'hidden';
    } else if (!open && body) {
      body.style.overflow = 'auto';
    }
  }, [open]);

  const closeModal = useCallback(
    (e: any) => {
      e.stopPropagation();
      setVisibility(false);
      if (isFunction(onClose)) {
        onClose(false);
      }
    },
    [setVisibility, onClose],
  );

  const preventClosing = useCallback((e: any) => {
    e.stopPropagation();
  }, []);

  return (
    <div>
      {visibility && (
        <Overlay role="dialog" onClick={closeModal}>
          <ModalContent onClick={preventClosing} role="dialog">
            {children}
          </ModalContent>
        </Overlay>
      )}
    </div>
  );
};

export default Modal;
