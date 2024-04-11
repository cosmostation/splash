import { orderBy } from 'lodash';
import { SuiEvent, ValidatorsApy, type SuiSystemStateSummary } from '@mysten/sui.js';
import { multiply } from 'src/util/big';

interface IParsingValidatorsData {
  name: {
    name: string;
    logo: string | null;
  };
  stake: string;
  nextEpochStake: string;
  apy: string;
  commission: string;
  address: string;
  lastReward: any;
  rank: number;
  atRisk?: boolean;
}

export type IValidatorParseProps = {
  validator: IParsingValidatorsData;
};

export const ROLLING_AVERAGE = 30;

export type ParsedJson = {
  commission_rate: string;
  epoch: string;
  pool_staking_reward: string;
  pool_token_exchange_rate: {
    pool_token_amount: string;
    sui_amount: string;
  };
  reference_gas_survey_quote: string;
  stake: string;
  storage_fund_staking_reward: string;
  tallying_rule_global_score: string;
  tallying_rule_reporters: string[];
  validator_address: string;
};

export interface ApyGroups {
  [validatorAddress: string]: number[];
}

export interface ApyByValidator {
  [validatorAddress: string]: number;
}

export function getValidatorAvgData(validatorAddress: string, validatorQueryData?: SuiEvent[]) {
  const event = validatorQueryData?.find(({ parsedJson }) => {
    return parsedJson?.validator_address === validatorAddress;
  });

  return event;
}

export const parseValidatorsListData = (
  latestSystemState?: SuiSystemStateSummary,
  validatorQueryData?: SuiEvent[],
  validatorsApy?: ValidatorsApy,
) => {
  const sortValidators = orderBy(
    latestSystemState?.activeValidators,
    [
      (validator) => {
        return Number(validator.stakingPoolSuiBalance);
      },
    ],
    ['desc'],
  );

  return sortValidators.map((validator, idx) => {
    const validatorName = validator.name;
    const totalStake = validator.stakingPoolSuiBalance;
    const nextTotalStake = validator.nextEpochStake;
    const img = validator.imageUrl || null;

    const event = getValidatorAvgData(validator.suiAddress, validatorQueryData);

    const getValidatorApy = validatorsApy?.apys.find((a) => a.address === validator.suiAddress);

    return {
      name: {
        name: validatorName,
        logo: img,
      },
      stake: totalStake.toString(),
      nextEpochStake: nextTotalStake.toString(),
      apy: multiply(getValidatorApy?.apy || 0, 100),
      commission: (Number(validator.commissionRate) / 100).toString(),
      address: validator.suiAddress,
      lastReward: event?.parsedJson?.pool_staking_reward || '0',
      atRisk: latestSystemState?.atRiskValidators.some(([address]) => address === validator.suiAddress),
      rank: idx + 1,
      epoch: event?.parsedJson?.epoch || '0',
    };
  });
};
