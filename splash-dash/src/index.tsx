import './styles/normalize.css';

import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { RecoilRoot, useRecoilValue } from 'recoil';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import { darkTheme, lightTheme } from './styles/theme';

import Dashboard from './pages/Dashboard';
import { HelmetProvider } from 'react-helmet-async';
import Init from './pages/Init';
import NotFound from './pages/NotFound';
import { PATH } from './constant/route';
import ReactDOM from 'react-dom/client';
import Snackbar from './components/Snackbar';
import { SnackbarProvider } from 'notistack';
import { StrictMode } from 'react';
import { THEME_TYPE } from './constant/theme';
import Validators from './pages/Validators';
import { WalletKitProvider } from '@mysten/wallet-kit';
import Wrapper from './components/Wrapper';
import { localStorageState } from './store/recoil/localStorage';

declare module 'notistack' {
  interface VariantOverrides {
    txError: true;
  }
}

function App() {
  const localStorageInfo = useRecoilValue(localStorageState);

  const theme = createTheme({
    ...(localStorageInfo.theme === THEME_TYPE.LIGHT ? lightTheme : darkTheme),
  });

  return (
    <ThemeProvider theme={theme}>
      <BrowserRouter>
        <SnackbarProvider
          Components={{
            success: Snackbar,
            error: Snackbar,
          }}
          autoHideDuration={20000}
          anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
          variant="success"
        >
          <WalletKitProvider>
            <Wrapper>
              <Routes>
                <Route path={`/:chainName${PATH.HOME}`} element={<Dashboard />} />

                <Route path={`/:chainName${PATH.VALIDATORS}`} element={<Validators />} />

                <Route path="*" element={<Init />} />
                <Route path="/404" element={<NotFound />} />
              </Routes>
            </Wrapper>
          </WalletKitProvider>
        </SnackbarProvider>
      </BrowserRouter>
    </ThemeProvider>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root')!);

root.render(
  <StrictMode>
    <RecoilRoot>
      <HelmetProvider>
        <App />
      </HelmetProvider>
    </RecoilRoot>
  </StrictMode>,
);
