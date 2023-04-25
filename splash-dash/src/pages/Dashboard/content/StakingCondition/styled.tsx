import Button from 'src/components/common/Button';
import Section from 'src/components/common/Section';
import SectionContent from 'src/components/common/Section/SectionContent';
import SectionHeader from 'src/components/common/Section/SectionHeader';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const CustomSection = styled(Section)({
  padding: '0',
});

export const CustomSectionHeader = styled(SectionHeader)(({ theme, ...props }) => ({
  padding: '3rem 3rem 0',

  fontSize: '2.2rem',

  [`@media ${device.laptop}`]: {
    padding: '1.6rem 1.6rem 2rem',
    borderBottom: props['data-length'] === 'true' ? `0.1rem solid ${theme.colors.base02}` : 'none',

    fontSize: '2rem',
  },
}));

export const ObjectCount = styled('span')(({ theme }) => ({
  color: theme.colors.base03,
}));

export const CustomSectionContent = styled(SectionContent)({
  paddingBottom: '3rem',

  [`@media ${device.laptop}`]: {
    paddingBottom: '1.6rem',
  },
});

export const NotConnectContainer = styled('div')({
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  justifyContent: 'center',

  margin: '5rem 0',

  fontSize: '3.6rem',

  [`@media ${device.laptop}`]: {
    margin: '4rem 0 1.8rem',

    fontSize: '2.2rem',
  },
});

export const WalletImg = styled('img')({
  marginBottom: '3rem',

  [`@media ${device.laptop}`]: {
    width: '10rem',
    marginBottom: '2rem',
  },
});

export const ConnectInfo = styled('div')(({ theme }) => ({
  width: '31.7rem',
  marginTop: '1.3rem',

  textAlign: 'center',
  color: theme.colors.base03,
  fontSize: '2.2rem',

  [`@media ${device.laptop}`]: {
    width: '24rem',
    marginTop: '1.2rem',

    fontSize: '1.8rem',
  },
}));

export const ButtonWrapper = styled('div')({
  display: 'flex',
  justifyContent: 'center',

  width: '100%',
  padding: '0 1.6rem',
});

export const ConnectButton = styled(Button)({
  marginTop: '6rem',
  width: '38rem',
  height: '6rem',

  fontSize: '2.2rem',

  [`@media ${device.laptop}`]: {
    marginTop: '4.4rem',
    width: '100%',
    height: '5rem',

    fontSize: '1.6rem',
  },
});
