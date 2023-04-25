import { Container, SelectButton, SelectButtonContainer, TitleContainer } from './styled';

import { Typography } from '@mui/material';

type SectionProps = {
  title?: string;
  typoVarient?:
    | 'typoBase01'
    | 'typoBase02'
    | 'typoBase03'
    | 'typoBase04'
    | 'typoBase05'
    | 'typoBase06'
    | 'typoBase07'
    | 'typoBase08';
  hasToggle?: boolean;
  active?: boolean;
  setActive?: any;
  children?: JSX.Element;
};

export default function SectionHeader({
  title,
  typoVarient = 'typoBase03',
  hasToggle = false,
  active = false,
  setActive,
  children,
  ...remainder
}: SectionProps) {
  return (
    <Container {...remainder}>
      <TitleContainer>
        {title && <Typography variant={typoVarient}>{title}</Typography>}
        {hasToggle && setActive && (
          <SelectButtonContainer>
            <SelectButton data-active={(!active).toString()} onClick={() => setActive(false)}>
              Summary
            </SelectButton>
            <SelectButton data-active={active.toString()} onClick={() => setActive(true)}>
              JSON
            </SelectButton>
          </SelectButtonContainer>
        )}
      </TitleContainer>
      {children}
    </Container>
  );
}
