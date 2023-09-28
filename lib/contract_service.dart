// ignore_for_file: prefer_const_declarations

import 'package:starknet/starknet.dart';

final provider = JsonRpcProvider.infuraGoerliTestnet;
final contractAddress = '0x076b4f19561a3c48f13aa3cb912ad92c0e702270466668ec9d77513ba6c5b0e2';
final secretAccountAddress = "0x00ce7b8175e1aed7e087f44e63051c053cda012d5f63fdd1e95e82489925ff41";
final secretAccountPrivateKey = "0x06a1b5d41b7e5fee4310fda61d7c1b11e039f4681424cc89e1e8bfffe1ed9926";
   final signeraccount = getAccount(
  accountAddress:Felt.fromHexString(secretAccountAddress) ,
  privateKey: Felt.fromHexString(secretAccountPrivateKey) ,
  nodeUri: infuraGoerliTestnetUri,
);

Future<int> getBalance() async {
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