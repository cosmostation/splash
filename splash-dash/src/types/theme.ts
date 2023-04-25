import { THEME_TYPE } from '../constant/theme';

export type ThemeType = ValueOf<typeof THEME_TYPE>;

export type ThemeStyle = {
  mode: 'light' | 'dark';
  colors: Colors;
  chainAccentColors: ChainAccentColors;
  chainFilters: ChainFilters;
  accentColors: AccentColors;
  typography: TextTypos & {
    htmlFontSize: number;
  };
};

export type TextTypos = {
  typoBase01: Record<string, unknown>;
  typoBase02: Record<string, unknown>;
  typoBase03: Record<string, unknown>;
  typoBase04: Record<string, unknown>;
  typoBase05: Record<string, unknown>;
  typoBase06: Record<string, unknown>;
  typoBase07: Record<string, unknown>;
  typoBase08: Record<string, unknown>;
};

export type Colors = {
  base01: string;
  base02: string;
  base03: string;
  base04: string;
  base05: string;
  base06: string;
  base07: string;
};

export type ChainAccentColors = {
  chainColor: string;
  chainSubColor: string;
  clickColor: string;
  blueColor: string;
  gradientColor: string;
  opacity: {
    blueColor: string;
    greenColor: string;
    yellowColor: string;
    redColor: string;
    base05: string;
  };
  gradient01: string;
  gradient02: string;
  blue: string;
  red: string;
};

export type ChainFilters = {
  brightness: string;
};

export type AccentColors = {
  yellow: string;
  green: string;
  red: string;
  blue: string;
  white: string;
};
