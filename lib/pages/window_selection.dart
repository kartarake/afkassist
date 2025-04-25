import 'dart:ffi';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

import 'package:afkassist/widgets/titlebar.dart';

typedef EnumWindowsProcNative = Int32 Function(IntPtr hWnd, IntPtr lParam);
typedef EnumWindowsProcDart = int Function(int hWnd, int lParam);

class WindowSelection extends StatefulWidget {
  const WindowSelection({super.key});

  @override
  State<WindowSelection> createState() => _WindowSelectionState();
}

class _WindowSelectionState extends State<WindowSelection> {
  int? selectedWindow;
  List<dynamic> windows = [];

  @override
  void initState() {
    super.initState();
    loadWindows();
  }


  void loadWindows() {
    setState(() {
      windows = getListOfWindows();
      if (windows.isNotEmpty) {selectedWindow = windows.first[1];}
    });
  }

  @override
  Widget build(BuildContext context) {

    var dropdownButton = DropdownButton<dynamic>(
      value: selectedWindow,
      items: [for (var window in windows) DropdownMenuItem(value: window[1], child: Text(window[0]))],
      onChanged: (value) => setState(() {
        selectedWindow = value;
        Navigator.pushNamed(context, "/afk_actions", arguments: selectedWindow);
      }),

      autofocus: true,

      borderRadius: BorderRadius.circular(15),
      padding: EdgeInsets.symmetric(horizontal: 20),
      menuWidth: 430,
      underline: SizedBox(),
      style: TextStyle(fontSize: 16, color: Colors.black),

      icon: SvgPicture.asset("assets\\icons\\tabler--chevron-down.svg"),
    );

    Widget dropdowntext = Text(
      "Choose your minecraft window",
      style: TextStyle(fontSize: 16, fontFamily: "Inter"),
    );

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCustomTitleBar(),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: dropdowntext,
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: dropdownButton,
        ),
        Expanded(child: Container()),
      ],
    );

    return Scaffold(
      body: column,
    );
  }
}

List<dynamic> list = [];

int enumFunc(int hWnd, int lParam) {
    if (IsWindowVisible(hWnd) == 0) return 1;

    final buffer = wsalloc(MAX_PATH);
    final length = GetWindowText(hWnd, buffer, MAX_PATH);

    final windowText = buffer.toDartString();
    free(buffer);

    if (length > 0 && windowText.isNotEmpty) {list.add([windowText, hWnd]);}

    return 1;
  }


List<dynamic> getListOfWindows() {
  void listVisibleWindows() {
    list.clear();
    final callback = Pointer.fromFunction<WNDENUMPROC>(enumFunc,0);
    EnumWindows(callback, 0);
  }

  listVisibleWindows();
  return list;
}