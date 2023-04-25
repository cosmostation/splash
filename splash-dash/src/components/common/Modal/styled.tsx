import { device } from 'src/constant/muiSize';
import { styled } from '@mui/material/styles';

export const Overlay = styled('div')({
  position: 'fixed',
  left: '0',
  right: '0',
  top: '0',
  bottom: '0',

  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  zIndex: '1399',
  overflowY: 'auto',

  backgroundColor: 'rgba(0, 0, 0, 0.6)',

  [`@media ${device.laptop}`]: {
    alignItems: 'flex-end',
  },
});

export const ModalContent = styled('div')(({ theme }) => ({
  overflow: 'hidden',

  backgroundColor: theme.colors.base06,
  width: '63rem',
  borderRadius: '1.6rem',
  border: `0.1rem solid ${theme.colors.base02}`,

  [`@media ${device.laptop}`]: {
    width: '100%',
    borderRadius: '1.6rem 1.6rem 0px 0px',
  },
}));
