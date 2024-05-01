import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

class RockPaperScissorsGame extends StatefulWidget {
  const RockPaperScissorsGame({super.key});

  @override
  _RockPaperScissorsGameState createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame>  with WidgetsBindingObserver {
  int round = 1;
  final Random _random = Random();
  int choice = 0;
  DateTime? lastPlayTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getLastPlayTime();
    startTimer();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    WidgetsBinding.instance?.removeObserver(this);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Round: $round'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    choice = 1;
                    playRound();
                  },
                  child: Text('Rock'),
                ),
                TextButton(
                  onPressed: () {
                    choice = 2;
                    playRound();
                  },
                  child: Text('Paper'),
                ),
                TextButton(
                  onPressed: () {
                    choice = 3;
                    playRound();
                  },
                  child: Text('Scissors'),
                ),
              ],
            ),
            if (lastPlayTime != null &&
                DateTime.now().difference(lastPlayTime!) < Duration(hours: 24))
              Text(
                'Time left: ${formatDuration(Duration(hours: 24) - DateTime.now().difference(lastPlayTime!))}',
              ),
          ],
        ),
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
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  void playRound() async{
    setState(() {

      if (lastPlayTime != null &&
          DateTime.now().difference(lastPlayTime!) < Duration(hours: 24)) {

        return;
      }
      int randomNumber = _random.nextInt(3) + 1;
      lastPlayTime = DateTime.now();
      if(randomNumber == choice){
        round++;
        choice = 0;
        print("congrats");
      }
      else{
        round = 1;
        print("good luck next time");
      }
    });
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
