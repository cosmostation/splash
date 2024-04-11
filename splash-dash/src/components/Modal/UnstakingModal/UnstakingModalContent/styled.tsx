import Button from 'src/components/common/Button';
import ModalContent from 'src/components/common/Modal/ModalContent';
import ModalHeader from 'src/components/common/Modal/ModalHeader';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';
import ImgView from 'src/components/common/Img';

type IValidatorImgProps = {
  'data-risk': string;
};

type ActionButtonProps = {
  'data-on'?: string;
};

export const StakingModalHeader = styled(ModalHeader)({
  padding: '3rem 0 2rem',
  margin: '0 3rem',

  [`@media ${device.laptop}`]: {
    padding: '1.6rem 0 2rem',
    margin: '0 1.6rem',
  },
});

export const StakingModalContentWrapper = styled(ModalContent)({
  paddingTop: '0 !important',
});

export const HeaderTitle = styled('div')({
  display: 'flex',
  alignItems: 'center',

  fontSize: '3rem',

  [`@media ${device.laptop}`]: {
    fontSize: '2rem',
  },
});

export const HeaderImg = styled('img')({
  cursor: 'pointer',

  [`@media ${device.laptop}`]: {
    width: '2.8rem',
    height: '2.8rem',
  },
});

export const NameContainer = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  marginRight: '1rem',

  color: theme.colors.base01,
}));

export const ValidatorImg = styled(ImgView)<IValidatorImgProps>(({ ...props }) => ({
  width: '5rem',
  maxHeight: '5rem',
  borderRadius: '1rem',
  marginRight: '1.4rem',

  filter: props['data-risk'] === 'true' ? 'brightness(0.2)' : 'none',

  [`@media ${device.laptop}`]: {
    width: '3.6rem',
    maxHeight: '3.6rem',
  },
}));

export const RiskBar = styled('div')(({ theme }) => ({
  position: 'absolute',
  left: '0',
  top: '35%',

  transform: 'rotate(-45deg)',

  color: theme.chainAccentColors.red,
  fontSize: '1.3rem',

  [`@media ${device.laptop}`]: {
    fontSize: '1rem',
  },
}));

export const StakingContainer = styled('div')({
  display: 'flex',
  flexDirection: 'column',
});

export const ValidatorNameBox = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  margin: '0 3rem 2rem',
  padding: '2rem',
  backgroundColor: theme.colors.base05,
  borderRadius: '1rem',

  color: theme.colors.base01,
  fontSize: '2.6rem',

  [`@media ${device.laptop}`]: {
    margin: '0 1.6rem 1.6rem',
    padding: '1.2rem',

    fontSize: '2rem',
  },
}));

export const NameWrapper = styled('div')({
  position: 'relative',

  display: 'flex',
  alignItems: 'center',
});

export const StakingInfo = styled('div')({
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: '1rem',

  width: '100%',
  marginBottom: '3rem',
  padding: '0 3rem',

  [`@media ${device.laptop}`]: {
    padding: '0 1.7rem',
  },
});

export const StakeContent = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  flexDirection: 'column',

  backgroundColor: theme.colors.base05,
  borderRadius: '1rem',
  padding: '2rem 0',

  fontSize: '1.8rem',
  color: theme.colors.base03,

  [`@media ${device.laptop}`]: {
    padding: '1.6rem 0',

    fontSize: '1.4rem',
  },
}));

export const StakeValue = styled('div')(({ theme }) => ({
  marginTop: '1.2rem',

  fontSize: '2.6rem',
  color: theme.colors.base01,

  [`@media ${device.laptop}`]: {
    marginTop: '1.1rem',

    fontSize: '1.8rem',
  },
}));

export const CurrentStakeInfo = styled('div')(({ theme }) => ({
  borderTop: `0.1rem solid ${theme.colors.base02}`,
  borderBottom: `0.1rem solid ${theme.colors.base02}`,
  padding: '2rem 3rem',

  [`@media ${device.laptop}`]: {
    padding: '1.6rem',
  },
}));

export const CurrentInfoWrapper = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  color: theme.colors.base03,

  '& + &': {
    marginTop: '1.8rem',

    [`@media ${device.laptop}`]: {
      marginTop: '1rem',
    },
  },
}));

export const CurrentInfoValue = styled('div')(({ theme }) => ({
  color: theme.colors.base01,
}));

export const ActionButton = styled(Button)<ActionButtonProps>(({ ...props }) => ({
  width: 'calc(100% - 6rem)',
  height: '6rem',
  margin: '3rem 3rem 0',

  textTransform: 'capitalize',

  filter: props['data-on'] === 'true' ? 'none' : 'brightness(0.5)',

  [`@media ${device.laptop}`]: {
    height: '5rem',
    margin: '1.6rem 1.6rem 0',
    width: 'calc(100% - 3.2rem)',
  },
}));
