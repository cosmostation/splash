/* eslint-disable @typescript-eslint/no-empty-interface */
import '@mui/system';

import type { ThemeStyle } from '../theme';

declare module '@mui/material/styles' {
  interface Theme extends ThemeStyle {}
  interface ThemeOptions extends ThemeStyle {}

  interface TypographyVariants {
    typoBase01: React.CSSProperties;
    typoBase02: React.CSSProperties;
    typoBase03: React.CSSProperties;
    typoBase04: React.CSSProperties;
    typoBase05: React.CSSProperties;
    typoBase06: React.CSSProperties;
    typoBase07: React.CSSProperties;
    typoBase08: React.CSSProperties;
  }

  // allow configuration using `createTheme`
  interface TypographyVariantsOptions {
    typoBase01: React.CSSProperties;
    typoBase02: React.CSSProperties;
    typoBase03: React.CSSProperties;
    typoBase04: React.CSSProperties;
    typoBase05: React.CSSProperties;
    typoBase06: React.CSSProperties;
    typoBase07: React.CSSProperties;
    typoBase08: React.CSSProperties;
  }
}

// Update the Typography's variant prop options
declare module '@mui/material/Typography' {
  interface TypographyPropsVariantOverrides {
    typoBase01: true;
    typoBase02: true;
    typoBase03: true;
    typoBase04: true;
    typoBase05: true;
    typoBase06: true;
    typoBase07: true;
    typoBase08: true;
  }
}
