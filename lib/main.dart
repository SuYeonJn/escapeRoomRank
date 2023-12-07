import 'package:flutter/material.dart';

import 'pages/navigator.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//필터, 리팩토링
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "../.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'room_escape_ranking',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromRGBO(0, 40, 126, 1),
          onPrimary: Color.fromRGBO(255, 255, 255, 1),
          secondary: Color.fromRGBO(255, 255, 255, 1),
          onSecondary: Color.fromRGBO(99, 99, 99, 1),
          error: Color.fromRGBO(171, 45, 45, 1),
          onError: Color.fromRGBO(171, 45, 45, 1),
          background: Color.fromRGBO(255, 255, 255, 1),
          onBackground: Color.fromRGBO(255, 255, 255, 1),
          surface: Color.fromRGBO(255, 255, 255, 1),
          onSurface: Color.fromRGBO(0, 0, 0, 1),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '방탈출 카페 랭킹'),
      debugShowCheckedModeBanner: false,
    );
  }
}
