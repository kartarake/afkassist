import 'package:flutter/material.dart';

// Local Pages
import 'package:afkassist/pages/window_selection.dart';
import 'package:afkassist/pages/afk_actions.dart';


// Main
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => WindowSelection(),
      },
      initialRoute: "/",

      onGenerateRoute: (settings) {
        if (settings.name == '/afk_actions') {
          final hwnd = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => AfkActions(hwnd: hwnd),
          );
        }
        return null;
      },
    );
  }
}