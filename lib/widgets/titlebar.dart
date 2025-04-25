import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF000000),
    mouseOver: const Color(0xFFE0E0E0),
    mouseDown: const Color(0xFFC0C0C0),
    iconMouseOver: const Color(0xFF000000),
    iconMouseDown: const Color(0xFF404040));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF000000),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        // MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

WindowTitleBarBox buildCustomTitleBar() {
  return WindowTitleBarBox(
    child: Row(
      children: [
        SizedBox(width: 8, child: MoveWindow()),
        Image.asset("assets/logo.png", height: 20, width: 20),
        Expanded(child: MoveWindow()),
        WindowButtons(),
      ],
    ),
  );
}