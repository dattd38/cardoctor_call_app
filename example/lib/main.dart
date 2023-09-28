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
          onSpeaker: (){
            updateSpeaker();
          },
          onEndCall: (){
            print('endcall');
          },
          onMessage: (){
            print('message');
          },
          onRefuse: (){
            print('refuse');
          },
          avatarImage: const Icon(Icons.ac_unit_outlined),
          isIncomingCall: true,
          userName: 'Duc Dat',
          userType: 'Dev test goi',
          isAccept: isAcceptCall,
          isOffSpeaker: onSpeaker,
        ),
      ),
    );
  }
}
