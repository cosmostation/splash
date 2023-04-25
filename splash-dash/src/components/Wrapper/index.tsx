import Body from './Body';
import Init from './Init';

type WrapperType = {
  children: JSX.Element;
};

export default function Wrapper({ children }: WrapperType) {
  return (
    <Body>
      <Init>{children}</Init>
    </Body>
  );
}
