import Button from 'src/components/common/Button';
import Input from 'src/components/common/Input';
import ModalContent from 'src/components/common/Modal/ModalContent';
import ModalHeader from 'src/components/common/Modal/ModalHeader';
import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';
import ImgView from 'src/components/common/Img';

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

export const HeaderTitle = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  fontSize: '3rem',
  color: theme.colors.base01,

  [`@media ${device.laptop}`]: {
    fontSize: '2rem',
  },
}));

export const ValidatorNameBox = styled('div')(({ theme }) => ({
  cursor: 'pointer',

  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  margin: '0 3rem 2rem',
  padding: '2rem',
  backgroundColor: theme.colors.base05,
  border: `0.1rem solid ${theme.colors.base02}`,
  borderRadius: '1rem',

  color: theme.colors.base01,
  fontSize: '2.6rem',

  '&:hover': {
    borderColor: theme.colors.base01,
  },

  [`@media ${device.laptop}`]: {
    margin: '0 1.6rem 1.6rem',
    padding: '1.2rem',

    fontSize: '2rem',
  },
}));

export const NameWrapper = styled('div')({
  display: 'flex',
  alignItems: 'center',
});

export const DropdownWrapper = styled('div')({
  maxHeight: '50rem',
  overflowY: 'auto',

  [`@media ${device.laptop}`]: {
    maxHeight: '40rem',
  },
});

export const HyperLinkButton = styled('div')(({ theme }) => ({
  cursor: 'pointer',

  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  padding: '2rem 3rem',
  backgroundColor: theme.colors.base06,

  fontSize: '2.6rem',
  color: theme.colors.base01,

  '&:hover': {
    backgroundColor: theme.colors.base04,
  },

  [`@media ${device.laptop}`]: {
    padding: '1.4rem 1.6rem',

    fontSize: '1.8rem',
  },
}));

export const ValidatorImg = styled(ImgView)({
  width: '5rem',
  maxHeight: '5rem',
  borderRadius: '1rem',
  marginRight: '1.4rem',

  [`@media ${device.laptop}`]: {
    width: '3.6rem',
    maxHeight: '3.6rem',
    marginRight: '1.2rem',
  },
});

export const HeaderImg = styled('img')({
  cursor: 'pointer',

  [`@media ${device.laptop}`]: {
    width: '2.8rem',
    height: '2.8rem',
  },
});

export const ValidatorName = styled('div')({
  marginLeft: '2rem',
});

export const StakingContainer = styled('div')({
  display: 'flex',
  flexDirection: 'column',
});

export const StakingInfo = styled('div')({
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: '1rem',

  width: '100%',
  marginBottom: '4rem',
  padding: '0 3rem',

  [`@media ${device.laptop}`]: {
    padding: '0 1.7rem',
    marginBottom: '3rem',
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
  marginTop: '1rem',

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

    fontSize: '1.4rem',
  },
}));

export const InputAmountWrapper = styled('div')({
  display: 'flex',
  flexDirection: 'column',

  padding: '0 3rem 3rem',

  [`@media ${device.laptop}`]: {
    padding: '0 1.6rem 2rem',
  },
});

export const AvailableWrapper = styled('div')({
  display: 'flex',
  alignItems: 'center',
});

export const AvailableAmount = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  marginLeft: '0.5rem',

  color: theme.colors.base03,
}));

export const EnterAmountWrapper = styled(Input)({
  position: 'relative',

  display: 'flex',

  marginTop: '2rem',

  '& > input': {
    borderRadius: '1rem',
    paddingRight: '13rem',
  },

  [`@media ${device.laptop}`]: {
    marginTop: '1.6rem',
  },
});

export const WarningComment = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',

  backgroundColor: theme.colors.base05,
  marginTop: '1.4rem',
  padding: '1.4rem 1.7rem',
  borderRadius: '1rem',

  fontSize: '1.8rem',
  color: theme.colors.base01,

  [`@media ${device.laptop}`]: {
    marginTop: '1rem',
    padding: '1rem',

    fontSize: '1.4rem',
  },
}));

export const ErrorIconImg = styled('img')({
  marginRight: '0.6rem',

  [`@media ${device.laptop}`]: {
    width: '1.8rem',
    height: '1.8rem',
  },
});

export const MaxButton = styled(Button)({
  position: 'absolute',
  top: '1.6rem',
  right: '3rem',

  width: '7rem',
  height: '3.6rem',
  borderRadius: '0.8rem',

  fontSize: '1.4rem',

  [`@media ${device.laptop}`]: {
    top: '1.4rem',
    right: '1.5rem',

    width: '6rem',
    height: '3rem',

    fontSize: '1.2rem',
  },
});

export const CurrentInfoWrapper = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',

  color: theme.colors.base03,

  '& + &': {
    marginTop: '1.4rem',

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

export const SelectBoxContaier = styled('div')({});

export const ValidatorStakingModalContent = styled(ModalContent)({
  paddingTop: '0 !important',
  height: '70rem',

  [`@media ${device.laptop}`]: {
    height: '50rem',
  },
});

export const ValidatorDataWrapper = styled('div')({
  display: 'flex',
  flexDirection: 'column',

  fontSize: '1.8rem',

  [`@media ${device.laptop}`]: {
    flexDirection: 'row',

    marginTop: '0.6rem',

    fontSize: '1.4rem',
  },
});

export const ValidatorDataRow = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'flex-end',

  color: theme.colors.base03,

  '& + &': {
    marginLeft: '1rem',
    paddingLeft: '1rem',
    borderLeft: `0.1rem solid ${theme.colors.base02}`,
  },
}));

export const Value = styled('div')(({ theme }) => ({
  marginLeft: '0.4rem',

  color: theme.colors.base01,
}));

export const ContentWrapper = styled('div')({});
