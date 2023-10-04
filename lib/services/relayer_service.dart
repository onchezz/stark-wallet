
// ignore_for_file: prefer_const_declarations

import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

final provider = JsonRpcProvider(
    nodeUri: Uri.parse(
        'https://starknet-goerli.infura.io/v3/9fe2088d204c4289bd9ed7e457cbbd67'));
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
 Future<String> regesteringUser(String amount) async {
  print('regstering.....');
  
  final res = await signerAccount.execute(functionCalls: [
    FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName('register'),
      calldata: [Felt.fromIntString(amount)],
    )
  ]);

 
  print( 
      res.when(
        result: (result) => result.toString(),
        error: (error) => throw Exception(error),
      ));

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  print('regester user transaction result:$txHash');
  return txHash;
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}


Future<String> depositTokens(String amount) async {
  print('deposit Tokens.....');
  
  final res = await signerAccount.execute(functionCalls: [
    FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName('withdraw'),
      calldata: [Felt.fromIntString(amount)],
    )
  ]);

 
  print( 
      res.when(
        result: (result) => result.toString(),
        error: (error) => throw Exception(error),
      ));

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  print('Withdrawing Tokens transaction result:$txHash');
  return txHash;
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}

Future<String> transferTokens(String amount, String senderAddress, String receiverAddress) async {
  print('Trasfering  Tokens.....');
  
  final res = await signerAccount.execute(functionCalls: [
    FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName('withdraw'),
      calldata: [Felt.fromIntString(amount),Felt.fromHexString(senderAddress),Felt.fromHexString(receiverAddress)],
    )
  ]);

 
  print( 
      res.when(
        result: (result) => result.toString(),
        error: (error) => throw Exception(error),
      ));

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  print('Transfer Tokens transaction result:$txHash');
  return txHash;
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}
Future<String> withdrawTokens(String amount) async {
  print('withdrawing Tokens.....');
  
  final res = await signerAccount.execute(functionCalls: [
    FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName('withdraw'),
      calldata: [Felt.fromIntString(amount)],
    )
  ]);

 
  print( 
      res.when(
        result: (result) => result.toString(),
        error: (error) => throw Exception(error),
      ));

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  print('withdrawing Tokens transaction result:$txHash');
  return txHash;
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}