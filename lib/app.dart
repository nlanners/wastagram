import 'package:flutter/material.dart';
import 'screens/list_screen.dart';
import 'styles.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wastagram',
      theme: Styles.darkTheme,
      home: const ListScreen(),
    );
  }
}