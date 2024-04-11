import { EN_MSG_DISPLAY_TYPE, IMessageData, ITxMessage, ITxMessageBody } from 'src/types/payloads/common/ITxMessage';
import { isArray, isEmpty, last, omit, pick, replace, split, startCase, transform } from 'lodash';

export function payloadParser(message: ITxMessage, moduleValue?: string[]): any {
  switch (message?.function) {
    case '0x1::aptos_account::transfer': {
      return parseTransfer(message);
    }
    case '0x1::coin::transfer': {
      return parseTransfer(message);
    }
    case '0x1::aptos_account::create_account': {
      return parseCreateAccount(message);
    }
    default: {
      return parseDefaultMessage(message, moduleValue);
    }
  }
}

/**
 * @example aptos_account::transfer: 2476839
 * @example coin::transfer: 520792
 */
function parseTransfer(message: ITxMessage): IMessageData {
  const { type, type_arguments } = message;
  const splitFunction = message.function.split('::');
  const amount = {
    amount: message.arguments[1],
    denom: 'apt',
  };

  return {
    type: message.function,
    display: 'Transfer',
    body: [
      { label: 'Type', value: type },
      { label: 'Module', value: splitFunction[0] },
      { label: 'Name', value: splitFunction[1] },
      { label: 'Exposed Function Name', value: splitFunction[2] },
      { label: 'To', value: message.arguments[0], type: EN_MSG_DISPLAY_TYPE.ADDRESS },
      { label: 'Amount', value: amount, type: EN_MSG_DISPLAY_TYPE.AMOUNT },
      { label: 'Type Arguments', value: type_arguments, type: EN_MSG_DISPLAY_TYPE.ARRAY_STRING },
    ],
  };
}

/**
 * @example 17010457
 */
function parseCreateAccount(message: ITxMessage): IMessageData {
  const { type, type_arguments } = message;
  const splitFunction = message.function.split('::');

  return {
    type: message.function,
    display: 'Create Account',
    body: [
      { label: 'Type', value: type },
      { label: 'Module', value: splitFunction[0] },
      { label: 'Name', value: splitFunction[1] },
      { label: 'Exposed Function Name', value: splitFunction[2] },
      { label: 'To', value: message.arguments[0], type: EN_MSG_DISPLAY_TYPE.ADDRESS },
      { label: 'Type Arguments', value: type_arguments, type: EN_MSG_DISPLAY_TYPE.ARRAY_STRING },
    ],
  };
}

function buildBody(messages: { [key: string]: any } | ITxMessage, moduleValue?: string[]): ITxMessageBody[] {
  const typeMessage = pick(messages, 'type');
  const anotherMessage = omit(messages, 'type');
  const combineMessage = { ...typeMessage, ...anotherMessage };

  const bodyObj = transform(
    combineMessage,
    (result, value, key) => {
      const splitFunc = key === 'function' && value.split('::');

      if (splitFunc) {
        result['Module'] = splitFunc[0];
        result['Name'] = splitFunc[1];
        result['Exposed Function Name'] = splitFunc[2];
      } else if (!isEmpty(value) && isArray(value)) {
        result[key] = JSON.stringify(value);
      } else {
        result[key] = value;
      }

      return result;
    },
    {},
  );

  return transform(
    bodyObj,
    (arr: ITxMessageBody[], value: string, label: string) => {
      if (label === 'arguments') {
        arr.push({ label, value, moduleValue, type: EN_MSG_DISPLAY_TYPE.ARGUMENTS });
      } else {
        arr.push({ label, value });
      }
      return arr;
    },
    [],
  );
}

function buildType(type?: string): string {
  const splitType = last(split(type, '::')) || '';
  const replaceType = replace(splitType, /_/g, ' ');

  return startCase(replaceType);
}

const parseDefaultMessage = (message: ITxMessage, moduleValue?: string[]): IMessageData => {
  const type = buildType(message?.function);
  const body = buildBody(message, moduleValue);

  return {
    type,
    display: type,
    body,
  };
};
