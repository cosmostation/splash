import { parseValidatorsListData } from 'src/function/parseValidator';
import { useGetLatestSuiSystemStateSwr } from '../useGetLatestSuiSystemStateSwr';
import { useMemo } from 'react';
import { useQueryEventsSwr } from '../useQueryEventsSwr';

export const useMakeValidatorListSwr = () => {
  const { data: latestSystemState, loading: latestSystemStateLoading } = useGetLatestSuiSystemStateSwr();

  const numberOfValidators = useMemo(() => latestSystemState?.activeValidators.length || null, [latestSystemState]);

  const { data: validatorQueryData, loading: validatorsQueryLoading } = useQueryEventsSwr(
    // TODO: validator call number check
    // Number(multiply(numberOfValidators || 0, ROLLING_AVERAGE)),
    1000,
    true,
  );

  const validatorsData = useMemo(() => {
    return parseValidatorsListData(latestSystemState, validatorQueryData);
  }, [latestSystemState, validatorQueryData]);

  return {
    data: validatorsData,
    loading: latestSystemStateLoading && validatorsQueryLoading,
  };
};
