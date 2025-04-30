import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:warninglight_scanner/screens/home_screen.dart';
import 'package:warninglight_scanner/screens/welcome_screen.dart';
import 'package:warninglight_scanner/screens/warning_light_detector.dart';
import 'package:warninglight_scanner/theme/theme.dart'; // <-- Import your theme

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warning Light Scanner',
      theme: lightMode, // <-- Use your custom light theme
      darkTheme: darkMode, // <-- Use your custom dark theme
      home: const WarningLightDetector(),
      debugShowCheckedModeBanner: false, // <-- Add this line to remove the debug badge
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
