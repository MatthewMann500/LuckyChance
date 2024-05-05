import 'package:flutter/material.dart';
import 'package:luckychance/icon_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'dart:async';
import 'dart:math';

class RockPaperScissorsGame extends StatefulWidget {
  const RockPaperScissorsGame({super.key});

  @override
  _RockPaperScissorsGameState createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame>
    with WidgetsBindingObserver {
  final Random _random = Random();
  int choice = 0;
  bool chosen = false;
  int round = 1;
  DateTime? lastPlayTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getLastPlayTime();
    startTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      saveLastPlayTime();
    } else if (state == AppLifecycleState.resumed) {
      getLastPlayTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark overlay to cover the entire screen
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: chosen ? 0.5 : 0.0, // Adjust opacity as needed
            child: Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Positioned(
            right: 145,
            bottom: 500,
            child: TextAnimator('Round: $round',
                initialDelay: const Duration(milliseconds: 500),
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -2,
                    fontSize: 28),
                incomingEffect: WidgetTransitionEffects.incomingScaleDown(
                    duration: const Duration(milliseconds: 600))),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  height: 500,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        right: (choice == 1 || choice == -1 || choice == 4) ? 160 : 250,
                        bottom: (choice == 1 || choice == -1 || choice == 4) ? 50 : 125,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          transform: Matrix4.identity()
                            ..scale((choice == 1 || choice == -1 || choice == 4) ? 1.5 : 1.0),
                          child: AnimatedOpacity(
                            duration: chosen ? const Duration(milliseconds: 200) :  const Duration(milliseconds: 1400),
                            opacity: (choice != 1 && choice != -1 && choice != 4 && chosen) ? 0.0 : 1.0,
                            curve: chosen ? Curves.linear: Curves.easeInExpo,
                            child: WidgetAnimator(
                              incomingEffect: WidgetTransitionEffects
                                  .incomingSlideInFromBottom(
                                delay: const Duration(milliseconds: 600),
                                duration: const Duration(milliseconds: 1000),
                              ),
                              atRestEffect: WidgetRestingEffects.wave(
                                effectStrength: 0.3,
                                duration: const Duration(milliseconds: 5000),
                              ),
                              child: rockIconButton(
                                () {
                                  if (choice == -4) {
                                  } else {
                                    choice = 1;
                                    playRound();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        right: (choice == 2 || choice == -2 || choice == 5) ? 168 : 128,
                        bottom: (choice == 2 || choice == -2 || choice == 5) ? 50 : 128,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          transform: Matrix4.identity()
                            ..scale((choice == 2 || choice == -2 || choice == 5) ? 1.6 : 1.0),
                          child: AnimatedOpacity(
                            duration:  chosen ? const Duration(milliseconds: 200) :  const Duration(milliseconds: 1400),
                            opacity: choice != 2  && choice != -2 && choice != 5 && chosen ? 0.0 : 1.0,
                            curve: chosen ? Curves.linear: Curves.easeInExpo,
                            child: WidgetAnimator(
                              incomingEffect: WidgetTransitionEffects
                                  .incomingSlideInFromBottom(
                                delay: const Duration(milliseconds: 700),
                                duration: const Duration(milliseconds: 1000),
                              ),
                              atRestEffect: WidgetRestingEffects.wave(
                                effectStrength: 0.4,
                                duration: const Duration(milliseconds: 4000),
                              ),
                              child: paperIconButton(
                                () {
                                  if (choice == -4) {
                                  } else {
                                    choice = 2;
                                    playRound();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        bottom: (choice == 3 || choice == -3 ||choice == 6) ? 50 : 123,
                        left: (choice == 3 || choice == -3 || choice == 6) ? 95 : 250,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          transform: Matrix4.identity()
                            ..scale((choice == 3 || choice == -3 || choice == 6) ? 1.5 : 1.0),
                          child: AnimatedOpacity(
                            duration: chosen ? const Duration(milliseconds: 200) :  const Duration(milliseconds: 1400),
                            opacity: choice != 3 && choice != -3 && choice != 6 && chosen ? 0.0 : 1.0,
                            curve: chosen ? Curves.easeIn: Curves.easeInExpo,
                            child: WidgetAnimator(
                              incomingEffect: WidgetTransitionEffects
                                  .incomingSlideInFromBottom(
                                delay: const Duration(milliseconds: 800),
                                duration: const Duration(milliseconds: 1000),
                              ),
                              atRestEffect: WidgetRestingEffects.wave(
                                effectStrength: 0.2,
                                duration: const Duration(milliseconds: 3000),
                              ),
                              child: scissorsIconButton(
                                () {
                                  if (choice == -4) {
                                  } else {
                                    choice = 3;
                                    playRound();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (lastPlayTime != null &&
                    DateTime.now().difference(lastPlayTime!) <
                        const Duration(hours: 24) &&
                    choice == -4)
                  Text(
                    'Time left: ${formatDuration(const Duration(hours: 24) - DateTime.now().difference(lastPlayTime!))}',
                  ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: -10,
            top: (choice == 5 || choice == -3) ? -90 : -500,
            child: Transform.rotate(
              angle: pi,
              child: Image.asset(
                'images/Rock.png',
                width: 400, // Adjust image size as needed
                height: 500,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: -10,
            top: (choice == 6 || choice == -1) ? -90 : -500,
            child: Transform.rotate(
              angle: pi,
              child: Image.asset(
                'images/Paper.png',
                width: 400, // Adjust image size as needed
                height: 500,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: -10,
            top: (choice == 4 || choice == -2) ? -90 : -500,
            child: Transform.rotate(
              angle: pi,
              child: Image.asset(
                'images/Scissors.png',
                width: 400, // Adjust image size as needed
                height: 500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  void playRound() async {
    if (choice == -4) {
      return;
    }

    // Start animations
    setState(() {
      chosen = true;
    });

    lastPlayTime = DateTime.now();
    await Future.delayed(const Duration(seconds: 5));

    // Determine the outcome
    int random = _random.nextInt(3) + 1;
    int randomNumber = 1;
    if (randomNumber == choice) {
      setState(() {
        choice = choice + 3;
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        round++;
        chosen = false;
        choice = 0;
      });
    } else {
      setState(() {
        choice = -choice;
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        round = 1;
        chosen = false;
        choice = -4;
      });
    }
  }

  void getLastPlayTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('lastPlayTime')) {
      setState(() {
        lastPlayTime = DateTime.parse(prefs.getString('lastPlayTime')!);
      });
    }
  }

  void saveLastPlayTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastPlayTime', lastPlayTime!.toIso8601String());
  }
}
