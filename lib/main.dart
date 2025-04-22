import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {print("clicked");},
            child: const Text("Auto click start")),
        ),
      ),
    );
  }
}
