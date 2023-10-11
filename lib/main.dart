import 'package:flutter/material.dart';
import 'package:viacep/pages/cep_input.dart';
import 'package:viacep/pages/cep_list_view.dart';
import 'package:viacep/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ViaCEP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF023f6c),
          primary: const Color(0xFF023f6c),
          onPrimary: Colors.white,
          background: Colors.white,
          secondary: const Color(0xFFfedc01),
          onSecondary: const Color(0xFF023f6c),
          tertiary: const Color(0xFFa9bdcd),
          onTertiary: const Color(0xFF023f6c),
          primaryContainer: const Color(0xFFf0f3f6),
          onPrimaryContainer: const Color(0xFF023f6c),
        ),
        splashColor: const Color(0x80FFFFFF),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const HomePage(),
        '/cep_input': (BuildContext context) => const CEPInputPage(),
        '/cep_list_view': (BuildContext context) => const CEPListViewPage(),
      },
    );
  }
}
