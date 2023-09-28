import 'dart:async';

import 'package:cardoctor_call_app/widget/pulse_widget.dart';
import 'package:cardoctor_call_app/widget/slide_call_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'constant.dart';

class CallApp extends StatefulWidget {
  final bool isIncomingCall;
  final TextStyle? titleStyle;
  final Widget avatarImage;
  final TextStyle? subIconTitleStyle;
  final TextStyle? timeStyle;
  final VoidCallback? onSubmit;
  final VoidCallback? onMic;
  final VoidCallback? onSpeaker;
  final VoidCallback? onEndCall;
  final VoidCallback? onRefuse;
  final VoidCallback? onMessage;
  final String userName;
  final String userType;
  final TextStyle? textStyleIcon;
  final bool isOffMic;
  final bool isOffSpeaker;
  final bool isAccept;

  const CallApp(
      {super.key,
      this.titleStyle,
      required this.avatarImage,
      this.subIconTitleStyle,
      this.timeStyle,
      this.onSubmit,
      this.onMic,
      this.onSpeaker,
      this.onEndCall,
      this.onRefuse,
      required this.isIncomingCall,
      required this.userName,
      required this.userType,
      this.textStyleIcon,
      required this.isOffMic,
      required this.isOffSpeaker,
      required this.isAccept,
      this.onMessage});

  @override
  State<CallApp> createState() => _CallAppState();
}

class _CallAppState extends State<CallApp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller
      ..stop()
      ..reset()
      ..repeat(period: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isIncomingCall ? 'Cuộc gọi đến' : 'Cuộc gọi đi',
                  style: widget.titleStyle ??
                      TextStyle(
                        color: widget.isIncomingCall
                            ? const Color(0xFF25B3E8)
                            : const Color(0xFF15AA2C),
                        fontSize: 20,
                      ),
                ),
                const SizedBox(height: 24),
                Stack(
                  children: [
                    CustomPaint(
                      painter: PulseWidget(_controller,
                          color: widget.isIncomingCall
                              ? const Color(0xFF25B3E8)
                              : const Color(0xFF15AA2C),
                          wave: 4),
                      child: const SizedBox(
                        width: 240,
                        height: 240,
                      ),
                    ),
                    Positioned(
                      left: 40,
                      right: 40,
                      bottom: 40,
                      top: 40,
                      child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: widget.avatarImage),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Text(
                  widget.userName,
                  style: widget.titleStyle?.copyWith(color: Colors.black) ??
                      const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                ),
                Text(
                  widget.userType,
                  style: widget.subIconTitleStyle ??
                      const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 24),
                Visibility(visible: widget.isAccept, child: _buildTimer()),
                Visibility(visible: !widget.isAccept, child: _incomingCall()),
              ],
            ),
          ),
        ),
        bottomNavigationBar: !widget.isAccept
            ? Container(
                height: 120,
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: SlideCallWidget(
                  height: 80,
                  animationDuration: const Duration(milliseconds: 50),
                  innerColor: Colors.green,
                  outerColor: Colors.white,
                  sliderButtonIcon: SvgPicture.asset(
                    'assets/ic_call.svg',
                    package: packageName,
                  ),
                  text: '        Trượt để trả lời cuộc gọi',
                  textStyle: widget.titleStyle?.copyWith(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 22 / 16) ??
                      const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                  onSubmit: () {
                    widget.onSubmit!();
                    startTimer();
                  },
                ))
            : _acceptCall());
  }

  Widget _buildTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);

    final minutes = twoDigits(duration.inMinutes.remainder(60));

    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$hours:$minutes:$seconds',
      style: widget.timeStyle ??
          const TextStyle(
            color: Colors.black,
            fontSize: 32,
          ),
    );
  }

  Widget _acceptCall() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  widget.onMic!();
                },
                child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/ic_microphone.svg',
                      package: packageName,
                      width: 24,
                      height: 24,
                      color: widget.isOffMic
                          ? const Color(0xFF25B3E8)
                          : Colors.black,
                    )),
              ),
              const SizedBox(height: 8),
              Text(
                'Tắt mic',
                style: widget.textStyleIcon ??
                    const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onEndCall!();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Container(
                  padding: const EdgeInsets.all(18.0),
                  child: Transform.rotate(
                      angle: 2.34,
                      child: SvgPicture.asset(
                        'assets/ic_call.svg',
                        package: packageName,
                        width: 12,
                        height: 12,
                      )),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  widget.onSpeaker!();
                },
                child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/ic_speaker.svg',
                      package: packageName,
                      width: 24,
                      height: 24,
                      color: widget.isOffSpeaker
                          ? const Color(0xFF25B3E8)
                          : Colors.black,
                    )),
              ),
              const SizedBox(height: 8),
              Text(
                'Tắt loa',
                style: widget.textStyleIcon ??
                    const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _incomingCall() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 44),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  widget.onMessage!();
                },
                child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/ic_messages.svg',
                      package: packageName,
                      width: 24,
                      height: 24,
                    )),
              ),
              const SizedBox(height: 8),
              Text(
                'Nhắn tin',
                style: widget.textStyleIcon ??
                    const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
              )
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  widget.onEndCall!();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Transform.rotate(
                        angle: 2.34,
                        child: SvgPicture.asset(
                          'assets/ic_call.svg',
                          package: packageName,
                          width: 16,
                          height: 16,
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Từ chối',
                style: widget.textStyleIcon ??
                    const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
