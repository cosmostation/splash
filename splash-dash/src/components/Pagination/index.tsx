import DefaultPagination from './DefaultPagination';

export interface IPaginationProps {
  current: number;
  lastPage: number;
  goToPage: (page: number) => void;
}

export default function Pagination({ goToPage, current, lastPage }: IPaginationProps) {
  return <DefaultPagination goToPage={goToPage} current={current} lastPage={lastPage} />;
}
