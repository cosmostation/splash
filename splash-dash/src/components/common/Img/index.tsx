import { ImageView } from './styled';
import DefaultValidatorIcon from 'src/assets/icons/validator/DefaultValidator.svg';

interface ButtonProps {
  Img?: string;
  defaultImg?: string;
}

export default function ImgView({ Img, defaultImg = DefaultValidatorIcon, ...remainder }: ButtonProps) {
  const onErrorImg = (event) => {
    event.target.src = DefaultValidatorIcon;
  };

  return <ImageView {...remainder} src={Img} onError={onErrorImg} />;
}
