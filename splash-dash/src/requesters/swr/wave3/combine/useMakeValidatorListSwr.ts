import { parseValidatorsListData } from 'src/function/parseValidator';
import { useGetLatestSuiSystemStateSwr } from '../useGetLatestSuiSystemStateSwr';
import { useMemo } from 'react';
import { useQueryEventsSwr } from '../useQueryEventsSwr';
import { useGetValidatorsApySwr } from '../useGetValidatorsApySwr';

export const useMakeValidatorListSwr = () => {
  const { data: latestSystemState, loading: latestSystemStateLoading } = useGetLatestSuiSystemStateSwr();

  const numberOfValidators = useMemo(() => latestSystemState?.activeValidators.length || null, [latestSystemState]);

  const { data: validatorQueryData, loading: validatorsQueryLoading } = useQueryEventsSwr(
    Number(numberOfValidators || 0),
    true,
  );

  const { data: validatorsApy, loading: validatorsApyLoading } = useGetValidatorsApySwr();

  const validatorsData = useMemo(() => {
    return parseValidatorsListData(latestSystemState, validatorQueryData, validatorsApy);
  }, [latestSystemState, validatorQueryData, validatorsApy]);

  return {
    data: validatorsData,
    loading: latestSystemStateLoading && validatorsQueryLoading && validatorsApyLoading,
  };
};
