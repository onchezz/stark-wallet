import 'package:counter/services/relayer_service.dart';
import 'package:flutter/material.dart';

class Relayer extends StatefulWidget {
  const Relayer({super.key});

  @override
  State<Relayer> createState() => _RelayerState();
}

class _RelayerState extends State<Relayer> {
  int _totalBalance = 0;
  int _relayerBal = 0;
  _getTotalBalance() async {
    int bal = await getTotalBalance();

    await getSignerBal();
    setState(() {
      _totalBalance = bal;
    });
  }

  _getPersonalBal() async {
    int bal = await getRelayerBalance();
    setState(() {
      _relayerBal = bal;
    });
  }

  _regesterUser() async {
    String amount = '100';
    bool res = await regesteringUser(amount);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Available Total liquidity balance is : $_totalBalance"),
                const SizedBox(
                  width: 20,
                ),
                Text("relayer balance is : $_relayerBal"),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (() => _getTotalBalance()),
                  child: const Text('get all bal')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: (() => _regesterUser()),
                  child: const Text('regester user')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: (() => _getPersonalBal()),
                  child: const Text('get relayer bal')),
            ],
          ),
        ],
      ),
    ));
  }
}
