import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

// Local Pages
import 'package:afkassist/pages/window_selection.dart';
import 'package:afkassist/pages/afk_actions.dart';


// Main
void main() {
  runApp(const MainApp());

  doWhenWindowReady(() {
    const initialSize = Size(480,320);
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.title = "AfkAssist";
    appWindow.show();
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AfkAssist",
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

      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffffffff)
      ),
      
    );
  }
}