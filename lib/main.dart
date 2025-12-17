import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:api_forum/widgets/login_form.dart';
import 'package:api_forum/InscriptionPage.dart';
import 'package:api_forum/ListeUsersPage.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

Future<void> main() async {
  await dotenv.load(
    fileName: "assets/.env.local",
  ); // load des variables d'enironement custom avant de lancer mon app
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          title: 'Forum',
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
          debugShowCheckedModeBanner: false,
          initialRoute: authProvider.isAuthenticated ? '/' : '/login',
          routes: {
            '/': (context) => const MyHomePage(),
            '/login': (context) => LoginForm(),
            '/inscription': (context) => const InscriptionPage(),
            '/users': (context) => const ListeUsersPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name != '/login' && !authProvider.isAuthenticated) {
              return MaterialPageRoute(builder: (context) => LoginForm());
            }
            return null; // Let routes handle it.
          },
        );
      },
    );
  }
}
