import { EN_MSG_DISPLAY_TYPE, IMessageData, ITxMessage, ITxMessageBody } from 'src/types/payloads/common/ITxMessage';
import { isArray, isObject, last, omit, pick, replace, split, startCase, transform } from 'lodash';

export function changesParser(message: ITxMessage): any {
  switch (message?.type) {
    default: {
      return parseDefaultMessage(message);
    }
  }
}

function buildBody(messages: { [key: string]: any } | ITxMessage, body = {}): ITxMessageBody[] {
  const typeMessage = pick(messages, 'type');
  const anotherMessage = omit(messages, 'type');
  const combineMessage = { ...typeMessage, ...anotherMessage };

  const bodyObj = transform(
    combineMessage,
    (result, value, key) => {
      if (isArray(value) || isObject(value)) {
        result[key] = JSON.stringify(value);
      } else {
        result[key] = value;
      }

      return result;
    },
    body,
  );

  return transform(
    bodyObj,
    (arr: ITxMessageBody[], value: string, label: string) => {
      if (label === 'data' || label === 'guid') {
        arr.push({ label, value, type: EN_MSG_DISPLAY_TYPE.JSON_PARSER });
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

function parseDefaultMessage(message: ITxMessage): IMessageData {
  const type = buildType(message?.type);
  const body = buildBody(message);

  return {
    type,
    display: type,
    body,
  };
}
