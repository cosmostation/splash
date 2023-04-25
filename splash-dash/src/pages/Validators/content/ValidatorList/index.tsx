import {
  CustomSection,
  CustomSectionContent,
  CustomSectionHeader,
  HeaderContainer,
  ValidatorsContainer,
  ValidatorsList,
} from './styled';

import Loading from 'src/components/Loading';
import ValidatorCard from './ValidatorCard';
import ValidatorRow from './ValidatorRow';
import { device } from 'src/constant/muiSize';
import { orderBy } from 'lodash';
import { useMakeValidatorListSwr } from 'src/requesters/swr/wave3/combine/useMakeValidatorListSwr';
import useMediaQuery from '@mui/material/useMediaQuery';

export default function ValidatorList() {
  const { data: validatorsData, loading } = useMakeValidatorListSwr();

  const isLaptop = useMediaQuery(device.laptop);

  const sortValidators = orderBy(validatorsData, [(validator) => validator.name.name === 'Cosmostation'], ['desc']);

  return (
    <CustomSection>
      <>
        <CustomSectionHeader typoVarient={isLaptop ? 'typoBase04' : 'typoBase03'} title="All Validators" />
        {loading && <Loading />}
        {!loading && (
          <CustomSectionContent>
            {isLaptop ? (
              <ValidatorsList>
                {sortValidators?.map((v, idx) => (
                  <ValidatorCard key={`${v.address}-${idx}`} validator={v} />
                ))}
              </ValidatorsList>
            ) : (
              <ValidatorsContainer>
                <HeaderContainer>
                  <li>Validators</li>
                  <li>Current staked</li>
                  <li>Next epoch stake</li>
                  <li>APY</li>
                  <li>Commission</li>
                  <li></li>
                </HeaderContainer>
                <ValidatorsList>
                  {sortValidators?.map((v, idx) => (
                    <ValidatorRow key={`${v.address}-${idx}`} validator={v} />
                  ))}
                </ValidatorsList>
              </ValidatorsContainer>
            )}
          </CustomSectionContent>
        )}
      </>
    </CustomSection>
  );
}
