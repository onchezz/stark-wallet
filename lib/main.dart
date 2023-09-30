import 'package:counter/services/counter_service.dart';
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
      title: 'Flutter Startnet Counter',
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
  int counter = 0;
  TextEditingController amount = TextEditingController();
  _increaseCount() async {
    await increaseCounter();
    setState(() {
      _getCounter();
    });
  }
_increaseCountBy() async {
    await increaseCounterBy(amount.text.trim());
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
            SizedBox(
              width: 500,
              child: TextField(
                controller: amount,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Amount',
                ),
              ),
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
                    onPressed: _increaseCountBy, child: const Text('incrementBy')),
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
          ],
        ),
      ),
    );
  }
}
