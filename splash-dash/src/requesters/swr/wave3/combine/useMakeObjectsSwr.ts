import { useMemo } from 'react';
import { useGetOwnedObjectsSwr } from '../useGetOwnedObjectsSwr';
import { useMultiGetObjectsSwr } from '../useMultiGetObjectsSwr';
import { SUI_COIN } from 'src/constant/coin';
import { getChainInstanceState } from 'src/store/recoil/chainInstance';
import { useRecoilValue } from 'recoil';
import { plus } from 'src/util/big';

export const useMakeObjectsSwr = (address: string) => {
  const chain = useRecoilValue(getChainInstanceState);
  const { data: ownedObjectsData, loading: ownedObjectsLoading } = useGetOwnedObjectsSwr(address);

  const objectAddresses = useMemo(() => {
    if (!ownedObjectsData) {
      return [];
    }

    return ownedObjectsData?.map((v) => v.data?.objectId);
  }, [ownedObjectsData]);

  const { data: objects, loading: objectsLoading } = useMultiGetObjectsSwr(objectAddresses);

  const makeSuiAmount = useMemo(() => {
    const suiTokenAmount =
      objects?.reduce((result, object) => {
        const suiObject = object.data?.type === SUI_COIN;

        if (suiObject && object.data?.content?.dataType === 'moveObject') {
          return Number(plus(result, object.data.content.fields.balance));
        }

        return result;
      }, 0) || 0;

    return {
      amount: suiTokenAmount,
      denom: chain.denom,
    };
  }, [objects]);

  return {
    suiAmount: makeSuiAmount,
    loading: objectsLoading && ownedObjectsLoading,
  };
};
