import { isNil } from 'lodash';
import ReactJson from 'react-json-view';
import { useRecoilValue } from 'recoil';
import { THEME_TYPE } from 'src/constant/theme';
import { localStorageState } from 'src/store/recoil/localStorage';
import { Container } from './styled';

export default function RawData(rawData: any) {
  const localStorageInfo = useRecoilValue(localStorageState);

  const isDarkMode = localStorageInfo.theme === THEME_TYPE.DARK;

  return (
    <Container>
      {isNil(rawData) ? (
        <ReactJson src={{}} />
      ) : (
        <ReactJson
          src={rawData}
          groupArraysAfterLength={1}
          name={false}
          theme={isDarkMode ? 'eighties' : 'bright:inverted'}
          iconStyle="circle"
        />
      )}
    </Container>
  );
}
