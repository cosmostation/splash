import Section from 'src/components/common/Section';
import SectionContent from 'src/components/common/Section/SectionContent';
import SectionHeader from 'src/components/common/Section/SectionHeader';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const CustomSection = styled(Section)({
  padding: '0',
});

export const CustomSectionHeader = styled(SectionHeader)(({ theme }) => ({
  padding: '3rem 3rem 0',

  [`@media ${device.laptop}`]: {
    padding: '1.6rem 1.6rem 2rem',
    borderBottom: `0.1rem solid ${theme.colors.base02}`,
  },
}));

export const CustomSectionContent = styled(SectionContent)({
  paddingBottom: '3rem',

  [`@media ${device.laptop}`]: {
    paddingBottom: '0',
  },
});

export const ValidatorsContainer = styled('div')({
  fontSize: '1.8rem',
});

export const HeaderContainer = styled('ul')(({ theme }) => ({
  display: 'grid',
  gridTemplateColumns: '1.5fr 1.5fr 1.5fr 0.8fr 1fr 3.2rem',

  padding: '2.2rem 3rem',
  borderBottom: `0.1rem solid ${theme.colors.base02}`,

  color: theme.colors.base03,
}));

export const ValidatorsList = styled('div')({
  display: 'flex',
  flexDirection: 'column',
});
