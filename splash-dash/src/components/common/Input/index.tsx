import { InputContainer, InputContent } from './styled';

import { OutlinedInputProps } from '@mui/material';

type IInputProps = OutlinedInputProps & {
  placeholder?: string;
  value: string;
  children?: JSX.Element;
};

export default function Input({
  placeholder,
  value,
  onChange,
  onKeyDown,
  onClick,
  onBlur,
  children,
  ...remainder
}: IInputProps) {
  return (
    <InputContainer {...remainder}>
      <InputContent
        placeholder={placeholder}
        value={value}
        onChange={onChange}
        onKeyDown={onKeyDown}
        onClick={onClick}
        onBlur={onBlur}
      />
      {children}
    </InputContainer>
  );
}
