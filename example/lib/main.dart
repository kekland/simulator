import 'package:flutter/material.dart';
import 'package:simulator/simulator.dart';

void main() {
  runSimulatorApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 64.0),
            Text(
              'Current locale is ${Localizations.localeOf(context)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 64.0),
            InteractiveViewer(
              panEnabled: true,
              child: Container(
                width: 2000.0,
                height: 200.0,
                color: Colors.black,
                child: const GridPaper(),
              ),
            ),
            ..._testContainers,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

List<Container> get _testContainers => List.generate(
      100,
      (v) {
        if (v % 2 == 0) {
          return Container(
            height: 200.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter some text',
              ),
            ),
          );
        }

        return Container(
          height: 100,
          color: Colors.primaries[v % Colors.primaries.length],
        );
      },
    );
