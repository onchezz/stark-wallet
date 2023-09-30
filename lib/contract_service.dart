// ignore_for_file: prefer_const_declarations

import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

final provider = JsonRpcProvider(nodeUri: Uri.parse('https://starknet-goerli.infura.io/v3/9fe2088d204c4289bd9ed7e457cbbd67'));
final contractAddress =
    '0x05f37f5cd15bd9a956dda9f9f40aeac2c31e6dbc9942e85b811d783e4a6558f0';
final secretAccountAddress =
    "0x00ce7b8175e1aed7e087f44e63051c053cda012d5f63fdd1e95e82489925ff41";
final secretAccountPrivateKey =
    "0x06a1b5d41b7e5fee4310fda61d7c1b11e039f4681424cc89e1e8bfffe1ed9926";
final signerAccount = getAccount(
  accountAddress: Felt.fromHexString(secretAccountAddress),
  privateKey: Felt.fromHexString(secretAccountPrivateKey),
  nodeUri: infuraGoerliTestnetUri,
);

getTotalBalance() async {
  final result = await provider.call(
    request: FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName("view_total_balance"),
        calldata: []),
    blockId: BlockId.latest,
  );
  return result.when(
    result: (result) => result[0].toInt(),
    error: (error) => throw Exception("Failed to get counter value"),
  );
}

 getRelayerBalance() async {
  final result = await provider.call(
    request: FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName("view_relayer_balance"),
        calldata: [Felt.fromHexString(secretAccountAddress)]),
    blockId: BlockId.latest,
  );
  return result.when(
    result: (result) => result[0].toInt(),
    error: (error) => throw Exception("Failed to get counter value"),
  );
}

 getSignerBal() async {
  Uint256 signerBal = await signerAccount.balance();

  return signerBal;
}

 regesteringUser(String amount) async {
  // Account signerAccount() {
  //   return Account(
  //     supportedTxVersion: AccountSupportedTxVersion.v1,
  //     accountAddress: Felt.fromHexString(
  //         '0x01C5C8f8bA12AC2B24F45C6cFCdc7965e01cA8684dd2d02FcBd1B4F8A09aC857'),
  //     chainId: Felt.fromString('SN_GOERLI'),
  //     provider: provider,
  //     signer: Signer(
  //       privateKey: Felt.fromHexString(
  //           '0x01e37d9210176d9c8a8c027240e7cc661ccf90a7c64c1527fa0120da27b844f9'),
  //     ),
  //   );
  // }

  // final account = signerAccount();
  // final balance = signerAccount().balance();

  final res = await signerAccount.execute(functionCalls: [
    FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName(''),
      calldata: [Felt.fromIntString(amount)],
    )
  ]);

  print(res.when(
    result: (result) => result,
    error: (error) => throw Exception(error),
  ));
  // }

  print('regstering');
  // final response = await signerAccount.execute(functionCalls: [
  //   FunctionCall(
  //     contractAddress: Felt.fromHexString(contractAddress),
  //     entryPointSelector: getSelectorByName("register"),
  //     calldata: [Felt.fromInt(amount)],
  //   ),
  // ]);

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  return waitForAcceptance(transactionHash: txHash, provider: provider);
}
