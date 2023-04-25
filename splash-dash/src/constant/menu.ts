import { PATH } from './route';

interface IMenu {
  display: string;
  route: string;
  default: boolean;
  primary?: boolean;
}

export const menus: IMenu[] = [
  {
    display: 'Dashboard',
    route: PATH.HOME,
    primary: true,
    default: true,
  },
  {
    display: 'All validators',
    route: PATH.VALIDATORS,
    default: true,
  },
];
