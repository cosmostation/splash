import Decimal from 'decimal.js';

export const calculateAPY = (stake: string, poolStakingReward: string) => {
  const poolStakingRewardBigNumber = new Decimal(poolStakingReward);
  const stakeBigNumber = new Decimal(stake);
  const ratio = poolStakingRewardBigNumber.div(stakeBigNumber);

  const apy = ratio.plus(1).pow(365).minus(1);
  return apy.toNumber();
};
