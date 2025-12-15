import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(
    fileName: "assets/.env.local",
  ); // load des variables d'enironement custom avant de lancer mon app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forum',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
