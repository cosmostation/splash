export interface IDelegateObject {
  stakingPool: string;
  validatorAddress: string;
  name: string;
  img: string | null;
  status: 'Active' | 'Pending' | 'Unstaked';
  stakedSuiId: string;
  stakeRequestEpoch: string;
  stakeActiveEpoch: string;
  principal: string;
  estimatedReward?: number | undefined;
}
