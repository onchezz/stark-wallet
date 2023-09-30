// ignore_for_file: prefer_const_declarations

import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

final provider = JsonRpcProvider(
    nodeUri: Uri.parse(
        'https://starknet-goerli.infura.io/v3/9fe2088d204c4289bd9ed7e457cbbd67'));
final contractAddress =
    '0x076b4f19561a3c48f13aa3cb912ad92c0e702270466668ec9d77513ba6c5b0e2';
final secretAccountAddress =
    "0x00ce7b8175e1aed7e087f44e63051c053cda012d5f63fdd1e95e82489925ff41";
final secretAccountPrivateKey =
    "0x06a1b5d41b7e5fee4310fda61d7c1b11e039f4681424cc89e1e8bfffe1ed9926";
final signeraccount = getAccount(
  accountAddress: Felt.fromHexString(secretAccountAddress),
  privateKey: Felt.fromHexString(secretAccountPrivateKey),
  nodeUri: Uri.parse(
      'https://starknet-goerli.infura.io/v3/9fe2088d204c4289bd9ed7e457cbbd67'),
);

// final mySignerAccount = Account(
//   supportedTxVersion: AccountSupportedTxVersion.v1,
//   accountAddress: Felt.fromHexString(secretAccountAddress),
//   chainId: Felt.fromString('SN_GOERLI'),
//   provider: provider,
//   signer: Signer(
//     privateKey: Felt.fromHexString(secretAccountPrivateKey),
//   ),
// );

Future<int> getCurrentCount() async {
  final result = await provider.call(
    request: FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName("curr"),
        calldata: []),
    blockId: BlockId.latest,
  );
  return result.when(
    result: (result) => result[0].toInt(),
    error: (error) => throw Exception("Failed to get counter value"),
  );
}

increaseCounter() async {
  print('print increment');
  final response = await signeraccount.execute(functionCalls: [
    FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName("incr"),
      calldata: [],
    ),
  ]);

  final txHash = response.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );

  print('$txHash');
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}

decreaseCounter() async {
  print('decrementing.....');
  final response = await signeraccount.execute(functionCalls: [
    FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName("decr"),
      calldata: [],
    ),
  ]);

  final txHash = response.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );

  print('$txHash');
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}
