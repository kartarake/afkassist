import 'dart:isolate';

import 'package:afkassist/widgets/titlebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      body:Column(
        children: [
          buildCustomTitleBar(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildActionMenu(),
            Container(height: 290,width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
            if (selectedAction == "Fishing") buildFishingScreen(),
            if (selectedAction == "Mob Farm") buildMobFarmScreen(),
          ],),
        ],
      )
    );
  }

  Widget buildActionMenu() {
    TextButton fishingOption = TextButton(
      style: TextButton.styleFrom(
        backgroundColor:("Fishing"== selectedAction)? Color(0xffDEDEDE) : Color.fromARGB(0, 0, 0, 0),
        fixedSize: Size(120, 35),
        textStyle: TextStyle(fontSize: 13.33, fontFamily: "Inter", color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
        foregroundColor: Colors.black,
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset("assets\\icons\\tabler--fish-hook.svg", height: 16, width: 16),
          SizedBox(width: 3),
          Text("AFK Fishing"),
        ],
      ),

      onPressed: () => setState(() {
        selectedAction = "Fishing";
      }),
    );

    TextButton mobFarmOption = TextButton(
      style: TextButton.styleFrom(
        backgroundColor:("Mob Farm"== selectedAction)? Color(0xffDEDEDE) : Color.fromARGB(0, 0, 0, 0),
        fixedSize: Size(120, 35),
        textStyle: TextStyle(fontSize: 13.33, fontFamily: "Inter", color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
        foregroundColor: Colors.black,
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset("assets\\icons\\tabler--sword.svg", height: 16, width: 16),
          SizedBox(width: 5),
          Text("Mob Farm"),
        ],
      ),

      onPressed: () => setState(() {
        selectedAction = "Mob Farm";
      }),
    );

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          fishingOption,
          SizedBox(height: 10),
          mobFarmOption
        ],
      ),
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
      style: TextButton.styleFrom(
        backgroundColor: Color(0xff000000),
        foregroundColor: Colors.white,
      ),
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
      style: TextButton.styleFrom(
        backgroundColor: Color(0xff000000),
        foregroundColor: Colors.white,
      ),

      onPressed: () {
        SetForegroundWindow(hwnd);
        stopAfkFishing();
        setState(() {
          isFishing = false;
        });
      },
      child: Text("Stop"),
    );

    return SizedBox(
      width: 329,
      height: 290,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets\\illustration\\Fishing Rod.svg", width: 150, height: 150),
            SizedBox(height: 20),
            (isFishing)? stopFishingButton : startFishingButton,
          ],
        ),
      ),
    );
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
      style: TextButton.styleFrom(
        backgroundColor: Color(0xff000000),
        foregroundColor: Colors.white,
      ),
      
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
      style: TextButton.styleFrom(
        backgroundColor: Color(0xff000000),
        foregroundColor: Colors.white,
      ),

      onPressed: () {
        SetForegroundWindow(hwnd);
        stopAfkMobFarming();
        setState(() {
          isMobFarming = false;
        });
      },
      child: Text("Stop"),
    );

    return SizedBox(
      width: 329,
      height: 290,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets\\illustration\\Sword Illustration Forest Theme.svg", height: 150, width: 150),
            SizedBox(height: 20),
            (isMobFarming)? stopMobFarmingButton : startMobFarmingButton,
          ],
        ),
      ),
    );
  }
}