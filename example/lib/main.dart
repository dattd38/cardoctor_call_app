import 'dart:async';

import 'package:cardoctor_call_app/call_app.dart';
import 'package:flutter/material.dart';
import 'package:cardoctor_call_app/cardoctor_call_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool onMic = false;
  bool onSpeaker = false;
  bool isAcceptCall = false;

  void updateMic() {
    setState(() {
      onMic = !onMic;
    });
  }

  void updateStateCall() {
    setState(() {
      isAcceptCall = true;
    });
  }

  void updateSpeaker() {
    setState(() {
      onSpeaker = !onSpeaker;
    });
  }

  Duration duration = const Duration();
  Timer? timer;

  void addTime() {
    const int addSeconds = 1;
    setState(() {
      final sencond = duration.inSeconds + addSeconds;
      duration = Duration(seconds: sencond);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  Widget _buildTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);

    final minutes = twoDigits(duration.inMinutes.remainder(60));

    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$hours:$minutes:$seconds',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test'),
        ),
        body: CallApp(
          isOffMic: onMic,
          onMic: () {
            updateMic();
          },
          onSubmit: () {
            updateStateCall();
          },
          onSpeaker: () {
            updateSpeaker();
          },
          onEndCall: () {
            print('endcall');
            updateStateCall();
            startTimer();
          },
          onMessage: () {
            print('message');
          },
          onRefuse: () {
            print('refuse');
          },
          avatarImage: const Icon(Icons.ac_unit_outlined),
          isIncomingCall: false,
          userName: 'Duc Dat',
          userType: 'Dev test goi',
          isAccept: isAcceptCall,
          isOffSpeaker: onSpeaker,
          startTimer: _buildTimer(),
        ),
      ),
    );
  }
}
