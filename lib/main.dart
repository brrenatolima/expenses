import 'package:expenses/pages/create_account_screen.dart';
import 'package:expenses/pages/home.dart';
import 'package:expenses/pages/login_screen.dart';
import 'package:expenses/providers/transactions_provider.dart';
import 'package:expenses/routes/routes_paths.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionProvider()
        )
      ],
      builder: (context, child) {
        return MainApp();
      },
    )
   
    );
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = ThemeData(
      //primarySwatch: Colors.purple,
      fontFamily: 'Quicksand',
      appBarTheme: AppBarTheme(titleTextStyle: TextStyle(fontWeight: FontWeight.bold)),
      buttonTheme: ButtonThemeData(colorScheme: ColorScheme.dark()),
      iconButtonTheme: IconButtonThemeData(style: ButtonStyle(iconColor: MaterialStatePropertyAll(Color.fromRGBO(205, 67, 17, 0.848))))
      );

    return MaterialApp( 
      title: 'Despesas Pessoais',    
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.amber,
          ),
        ),
        themeMode: ThemeMode.system,
      // home: const Home(),
      routes: {
        RoutesPaths.HOME: (context) => Home(),
        RoutesPaths.LOGIN_SCREEN: (context) => LogInScreen(),
         RoutesPaths.CREATE_ACCOUNT_SCREEN: (context) => CreateAccountScreen(),
      },
    );
  }
}
