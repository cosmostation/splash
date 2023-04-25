import { AccentColors, ChainAccentColors, ChainFilters, Colors, ThemeStyle } from '../types/theme';

const lightThemeColors: Colors = {
  base01: '#FFFFFF',
  base02: '#4C5671',
  base03: '#A7B7E9',
  base04: '#304B7D',
  base05: '#031F54',
  base06: '#02163D',
  base07: '#101130',
};

const lightAccentColors: ChainAccentColors = {
  chainColor: '#00BB8B',
  chainSubColor: '#EEF8F4',
  clickColor: '#E6F9F4',
  blueColor: '#4472DE',
  gradientColor: 'linear-gradient(90deg, #A97FFF 0%, #0EE2FB 100%)',
  opacity: {
    blueColor: '#E6F8FF',
    greenColor: '#EFFBF4',
    yellowColor: '#FEF6EB',
    redColor: '#FEF0F0',
    base05: '#EDEEEF',
  },
  gradient01: 'linear-gradient(180deg, #037EED 0%, #0048D2 100%)',
  gradient02: 'linear-gradient(90deg, #3C7EFF 0%, #68B7FF 100%)',
  blue: '#037EED',
  red: '#CD1A1A',
};

const lightFilters: ChainFilters = {
  brightness: '4',
};

const darkThemeColors: Colors = {
  base01: '#FFFFFF',
  base02: '#4C5671',
  base03: '#A7B7E9',
  base04: '#304B7D',
  base05: '#031F54',
  base06: '#02163D',
  base07: '#101130',
};

const darkAccentColors: ChainAccentColors = {
  chainColor: '#2DAC79',
  chainSubColor: '#D8ECE4',
  clickColor: '#37443F',
  blueColor: '#6190FF',
  gradientColor: 'linear-gradient(90deg, #7546E8 0%, #0DC8DE 100%)',
  opacity: {
    blueColor: '#2A3C43',
    greenColor: '#333F38',
    yellowColor: '#423A2F',
    redColor: '#423434',
    base05: '#404040',
  },
  gradient01: 'linear-gradient(180deg, #037EED 0%, #0048D2 100%)',
  gradient02: 'linear-gradient(90deg, #3C7EFF 0%, #68B7FF 100%)',
  blue: '#037EED',
  red: '#CD1A1A',
};

const darkFilters: ChainFilters = {
  brightness: '0.7',
};

const accentColors: AccentColors = {
  yellow: '#F3A52F',
  red: '#ED6666',
  green: '#5FD68B',
  blue: '#00B1FD',
  white: '#FFFFFF',
};

const htmlFontSize = 10;

const typoBase01 = {
  fontFamily: 'Quicksand700',
  fontSize: '3.6rem',
};
const typoBase02 = {
  fontFamily: 'Quicksand700',
  fontSize: '3rem',
};
const typoBase03 = {
  fontFamily: 'Quicksand700',
  fontSize: '2.2rem',
};
const typoBase04 = {
  fontFamily: 'Quicksand700',
  fontSize: '2rem',
};
const typoBase05 = {
  fontFamily: 'Quicksand700',
  fontSize: '1.8rem',
};
const typoBase06 = {
  fontFamily: 'Quicksand700',
  fontSize: '1.6rem',
};
const typoBase07 = {
  fontFamily: 'Quicksand700',
  fontSize: '1.4rem',
};
const typoBase08 = {
  fontFamily: 'Quicksand700',
  fontSize: '1.2rem',
};

const fTypo = {
  typoBase01,
  typoBase02,
  typoBase03,
  typoBase04,
  typoBase05,
  typoBase06,
  typoBase07,
  typoBase08,
};

export const darkTheme: ThemeStyle = {
  mode: 'dark',
  colors: darkThemeColors,
  chainAccentColors: darkAccentColors,
  chainFilters: darkFilters,
  accentColors,
  typography: {
    htmlFontSize,
    ...fTypo,
  },
};

export const lightTheme: ThemeStyle = {
  mode: 'light',
  colors: lightThemeColors,
  chainAccentColors: lightAccentColors,
  chainFilters: lightFilters,
  accentColors,
  typography: {
    htmlFontSize,
    ...fTypo,
  },
};
