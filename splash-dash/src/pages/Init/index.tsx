import NotFound from '../NotFound';
import { PATH } from 'src/constant/route';
import { isUndefined } from 'lodash';
import { useEffect } from 'react';
import { useNavigate } from 'src/hooks/useNavigate';
import { useParams } from 'react-router-dom';

export default function Init() {
  const { navigate } = useNavigate();
  const { chainName } = useParams();

  useEffect(() => {
    if (isUndefined(chainName)) {
      navigate(`/testnet${PATH.HOME}`);
    }
  }, [chainName]);

  return <NotFound />;
}
