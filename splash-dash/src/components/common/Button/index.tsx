import { ButtonContainer, ContentContainer } from './styled';

type ButtonProps = React.DetailedHTMLProps<React.ButtonHTMLAttributes<HTMLButtonElement>, HTMLButtonElement> & {
  Icon?: SvgElement;
};

export default function Button({ children, Icon, type, ...remainder }: ButtonProps) {
  return (
    <ButtonContainer {...remainder} type={type ?? 'button'}>
      <ContentContainer>
        {Icon && <Icon />}
        {children && children}
      </ContentContainer>
    </ButtonContainer>
  );
}
