import 'package:ecalibre/firebase_options.dart';
import 'package:ecalibre/pages/homePage.dart';
import 'package:ecalibre/pages/loginPage.dart';
import 'package:ecalibre/provider/calculatorProvider.dart';
import 'package:ecalibre/provider/pageProvider.dart';
import 'package:ecalibre/provider/productProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PageProvider()),
      ChangeNotifierProvider(
        create: (_) => CalculatorProvider(),
      ),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data != null) {
              return HomePage();
            }
            return Loginpage();
          }),
    );
  }
}
