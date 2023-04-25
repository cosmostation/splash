import { ImgContainer } from './styled';

type ButtonProps = React.DetailedHTMLProps<React.ButtonHTMLAttributes<HTMLButtonElement>, HTMLButtonElement> & {
  Img?: SvgElement;
};

export default function Image({ Img, ...remainder }: ButtonProps) {
  return (
    <ImgContainer {...remainder}>
      <Img />
    </ImgContainer>
  );
}
