import { orderBy } from 'lodash';
import { plus } from 'src/util/big';
import { SuiEvent, type SuiSystemStateSummary } from '@mysten/sui.js';
import { calculateAPY } from './calculateAPY';
import { roundFloat } from 'src/util/utils';

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

export function apyValidatorCalData(latestSystemState?: SuiSystemStateSummary, validatorQueryData?: SuiEvent[]) {
  // TODO: validator apr calculate check
  if (!validatorQueryData || !latestSystemState) {
    return null;
  }

  const { stakeSubsidyStartEpoch, epoch, activeValidators } = latestSystemState || {};
  if (Number(epoch) < Number(stakeSubsidyStartEpoch)) {
    return activeValidators.reduce((acc, validator) => {
      acc[validator.suiAddress] = 0;
      return acc;
    }, {} as ApyByValidator);
  }

  const avgEpochNumberAfterSubsidy = Math.max(
    0,
    Math.min(ROLLING_AVERAGE, Number(epoch) - Number(stakeSubsidyStartEpoch)),
  );

  const apyGroups: ApyGroups = {};
  validatorQueryData?.forEach(({ parsedJson }) => {
    const { stake, pool_staking_reward, validator_address } = parsedJson as ParsedJson;

    if (!apyGroups[validator_address]) {
      apyGroups[validator_address] = [];
    }

    const apyFloat = calculateAPY(stake, pool_staking_reward);

    apyGroups[validator_address].push(Number.isNaN(apyFloat) || apyFloat > 10_000 ? 0 : apyFloat);
  });

  const apyByValidator: ApyByValidator = Object.entries(apyGroups).reduce((acc, [validatorAddr, apyArr]) => {
    const apys = apyArr.slice(0, avgEpochNumberAfterSubsidy).map((entry) => entry);

    const avgApy = apys.reduce((sum, apy) => Number(plus(sum, apy)), 0) / apys.length;
    acc[validatorAddr] = roundFloat(avgApy * 100, 4);
    return acc;
  }, {} as ApyByValidator);

  return apyByValidator;
}

export const parseValidatorsListData = (latestSystemState?: SuiSystemStateSummary, validatorQueryData?: SuiEvent[]) => {
  const apyValidatorGroup = apyValidatorCalData(latestSystemState, validatorQueryData);
  const sortValidators = orderBy(
    latestSystemState?.activeValidators,
    [
      (validator) => {
        return +validator.stakingPoolSuiBalance;
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

    return {
      name: {
        name: validatorName,
        logo: img,
      },
      stake: totalStake.toString(),
      nextEpochStake: nextTotalStake.toString(),
      apy: (apyValidatorGroup?.[validator.suiAddress] || '-').toString(),
      commission: (+validator.commissionRate / 100).toString(),
      address: validator.suiAddress,
      lastReward: event?.parsedJson?.pool_staking_reward || '0',
      atRisk: latestSystemState?.atRiskValidators.some(([address]) => address === validator.suiAddress),
      rank: idx + 1,
      epoch: event?.parsedJson?.epoch || '0',
    };
  });
};
