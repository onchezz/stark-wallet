import 'package:counter/contract_service.dart';
import 'package:counter/counter_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Starknet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _totalBalance = 0;
  int _relayerBal = 0;
  int counter = 0;

  _increaseCount() async {
    await increaseCounter();
    setState(() {
      _getCounter();
    });
  }

  _decreaseCount() async {
    await decreaseCounter();
    setState(() {
      _getCounter();
    });
  }

  _getCounter() async {
    int balcounter = await getCurrentCount();
    setState(() {
      counter = balcounter;
    });
  }

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text("Counter is  : $counter"),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _increaseCount, child: const Text('increment')),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: (() => _getCounter()),
                    child: const Text('get count')),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: _decreaseCount, child: const Text('decrement')),
              ],
            ),
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
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _increaseCount,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // void _incrementCounter() async {
  //   await increaseCounter();
  //   setState(() {});
  // }

  // _decrementingCounter() {}
}
