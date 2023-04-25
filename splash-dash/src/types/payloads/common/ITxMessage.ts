import { IAmount } from './IAmount';

export type CustomType = 'ResourceDisplay';

export enum EN_TAG_PICK_TYPE {
  REGEX = 'REGEX',
  REGEX_SINGLE = 'REGEX_SINGLE',
}

//  for events
export enum EN_PICK_TYPE {
  RECURSIVE = 'RECURSIVE', //  searches recursively through entire object for property
  DIRECT = 'DIRECT', //  checks property directly -> Don't think I'll ever use this -> need for automatic reward get on delegate
  VALUE = 'VALUE', //  searches recursively through entire object for value(${NUMBER}${DENOM})
  FIND_FIRST = 'FIND_FIRST', //  returns first occurance sifting through all events
}

export enum EN_MSG_DISPLAY_TYPE {
  ADDRESS = 'ADDRESS',
  AMOUNT = 'AMOUNT',
  BOOLEAN = 'BOOLEAN',
  ARRAY_STRING = 'ARRAY_STRING',
  ARGUMENTS = 'ARGUMENTS',
  JSON_PARSER = 'JSON_PARSER',
}

interface IInput {
  address: string;
  coins: IAmount[];
}

interface IOutput {
  address: string;
  coins: IAmount[];
}

export type ITxMessage = { [key: string]: any } & {
  type: string;
  value: { [key: string]: any };
  amount?: IAmount;
  inputs?: IInput[];
  outputs?: IOutput[];
  delegator_address?: string;
  validator_address?: string;
};

export interface ITxMessageBody {
  label: string;
  value?: string | number | boolean | IAmount | IInput[] | IOutput[] | { [key: string]: any };
  type?: EN_MSG_DISPLAY_TYPE;
  moduleValue?: string[];
  custom?: CustomType;
}

export interface IMessageData {
  type: string;
  display: string;
  amount?: string;
  inputs?: IInput[];
  outputs?: IOutput[];
  body: ITxMessageBody[];
}
