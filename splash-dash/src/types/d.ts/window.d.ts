/* eslint-disable @typescript-eslint/consistent-type-imports */

type Keplr = Omit<
  import('@keplr-wallet/types').Keplr,
  | 'enigmaEncrypt'
  | 'enigmaDecrypt'
  | 'getEnigmaTxEncryptionKey'
  | 'getEnigmaPubKey'
  | 'getEnigmaUtils'
  | 'getSecret20ViewingKey'
  | 'signEthereum'
  | 'suggestToken'
>;

interface Window {
  cosmostation: {
    version: string;
    common: Common;
    ethereum: Ethereum;
    cosmos: Cosmos;
    aptos: Aptos;
    sui: Sui;
    tendermint: {
      request: (message: import('src/types/message').CosmosRequestMessage) => Promise<T>;
      on: (eventName: import('src/types/message').CosmosListenerType, eventHandler: (event?: unknown) => void) => void;
      off: (handler: (event: MessageEvent<ListenerMessage>) => void) => void;
    };
    handlerInfos: {
      line: import('src/types/chain').LineType;
      eventName: string;
      originHandler: (data: unknown) => void;
      handler: (event: MessageEvent<ListenerMessage>) => void;
    }[];
    providers: {
      keplr: Keplr;
      metamask: MetaMask;
    };
  };
  cosmostationWallet?: Sui;
  keplr?: Keplr;
  getOfflineSigner?: unknown;
  getOfflineSignerOnlyAmino?: unknown;
  getOfflineSignerAuto?: unknown;

  ethereum?: MetaMask;
  aptos?: Aptos;
  suiWallet?: Sui;
}

type JsonRPCRequest = { id?: string; jsonrpc: '2.0'; method: string; params?: unknown };

type Common = {
  request: (message: import('src/types/message').CommonRequestMessage) => Promise<T>;
};

type Sui = {
  request: (message: import('src/types/message').SuiRequestMessage) => Promise<T>;
  connect: (permissions: import('src/types/chromeStorage').SuiPermissionType[]) => Promise<boolean>;
  disconnect: () => Promise<import('src/types/message/sui').SuiDisconnectResponse>;
  requestPermissions: (permissions?: import('src/types/chromeStorage').SuiPermissionType[]) => Promise<boolean>;
  hasPermissions: (permissions?: import('src/types/chromeStorage').SuiPermissionType[]) => Promise<boolean>;
  getAccounts: () => Promise<string[]>;
  getPublicKey: () => Promise<string>;
  getChain: () => Promise<string>;
  executeMoveCall: (
    data: import('src/types/message/sui').SuiExecuteMoveCall['params'][0],
  ) => Promise<import('src/types/message/sui').SuiExecuteMoveCallResponse>;
  executeSerializedMoveCall: (
    data: import('src/types/message/sui').SuiExecuteSerializedMoveCall['params'][0],
  ) => Promise<import('src/types/message/sui').SuiExecuteSerializedMoveCallResponse>;
  signAndExecuteTransaction: any;
  on: (eventName: import('src/types/message').SuiListenerType, eventHandler: (data: unknown) => void) => void;
  off: (eventName: import('src/types/message').SuiListenerType, eventHandler: (data: unknown) => void) => void;
};

type MetaMask = Ethereum;
