import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:win32/win32.dart';

const WM_RBUTTONDOWN = 0x0204;
const WM_RBUTTONUP = 0x0205;


class AfkActions extends StatefulWidget {
  final int hwnd;
  const AfkActions({super.key, required this.hwnd});

  @override
  State<AfkActions> createState() => _AfkActionsState();
}

class _AfkActionsState extends State<AfkActions> {
  String selectedAction = "Fishing";

  bool isFishing = false;
  Isolate? fishingIsolate;

  bool isMobFarming = false;
  Isolate? mobFarmingIsolate;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Row(children: [
        buildActionMenu(),
        if (selectedAction == "Fishing") buildFishingScreen(),
        if (selectedAction == "Mob Farm") buildMobFarmScreen(),
      ],)
    );
  }

  Widget buildActionMenu() {
    Text appTitle = Text("AFK Assist");

    GestureDetector fishingOption = GestureDetector(
      child: Text("Fishing"),
      onTap: () => setState(() {
        selectedAction = "Fishing";
      }),
    );

    GestureDetector mobFarmOption = GestureDetector(
      child: Text("Mob Farm"),
      onTap: () => setState(() {
        selectedAction = "Mob Farm";
      }),
    );

    return Column(
      children: [
        appTitle,
        fishingOption,
        mobFarmOption
      ],
    );
  }

  Widget buildFishingScreen() {
    int hwnd = widget.hwnd;

    void fishingLoop(List<dynamic> args) {
      final int hwnd = args[1];

      while (true) {
        PostMessage(hwnd, WM_RBUTTONDOWN, 0, 0);
        Sleep(50);
        PostMessage(hwnd, WM_RBUTTONUP, 0, 0);
        Sleep(300);
      }
    }

    void startAfkFishing(int hwnd) async {
      final receivePort = ReceivePort();
      fishingIsolate = await Isolate.spawn(fishingLoop, [receivePort.sendPort, hwnd]);
    }

    void stopAfkFishing() {
      fishingIsolate?.kill(priority: Isolate.immediate);
      fishingIsolate = null;
    }

    TextButton startFishingButton = TextButton(
      onPressed: () {
        SetForegroundWindow(hwnd);
        startAfkFishing(hwnd);
        setState(() {
          isFishing = true;
        });
      },
      child: Text("Start"),
    );

    TextButton stopFishingButton = TextButton(
      onPressed: () {
        SetForegroundWindow(hwnd);
        stopAfkFishing();
        setState(() {
          isFishing = false;
        });
      },
      child: Text("Stop"),
    );

    return (isFishing)? stopFishingButton : startFishingButton;
  }

  Widget buildMobFarmScreen() {
    int hwnd = widget.hwnd;

    void mobFarmLoop(List<dynamic> args) {
      final int hwnd = args[1];

      while (true) {
        PostMessage(hwnd, WM_LBUTTONDOWN, 0, 0);
        Sleep(50);
        PostMessage(hwnd, WM_LBUTTONUP, 0, 0);
        Sleep(1000);
      }
    }

    void startAfkMobFarming(int hwnd) async {
      final receivePort = ReceivePort();
      mobFarmingIsolate = await Isolate.spawn(mobFarmLoop, [receivePort.sendPort, hwnd]);
    }

    void stopAfkMobFarming() {
      mobFarmingIsolate?.kill(priority: Isolate.immediate);
      mobFarmingIsolate = null;
    }

    TextButton startMobFarmingButton = TextButton(
      onPressed: () {
        SetForegroundWindow(hwnd);
        startAfkMobFarming(hwnd);
        setState(() {
          isMobFarming = true;
        });
      },
      child: Text("Start"),
    );

    TextButton stopMobFarmingButton = TextButton(
      onPressed: () {
        SetForegroundWindow(hwnd);
        stopAfkMobFarming();
        setState(() {
          isMobFarming = false;
        });
      },
      child: Text("Stop"),
    );

    return (isMobFarming)? stopMobFarmingButton : startMobFarmingButton;
  }
}