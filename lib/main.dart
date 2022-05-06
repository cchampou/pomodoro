import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/counter.dart';
import 'package:pomodoro/settings/settings_page.dart';
import 'package:provider/provider.dart';

import 'settings_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Settings(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF52FFB8),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum timerType {
  sessionType,
  breakType,
}

class _MyHomePageState extends State<MyHomePage> {
  Duration currentTime = defaultSessionTime;
  bool isRunning = false;
  Timer? timer;
  final player = AudioCache();
  timerType currentTimerType = timerType.sessionType;

  reset() {
    if (timer != null) {
      timer!.cancel();
      setState(() {
        isRunning = false;
      });
    }
    setState(() {
      currentTime =
          Provider.of<Settings>(context, listen: false).sessionDuration;
    });
  }

  count() {
    setState(() {
      final newTime = currentTime - const Duration(seconds: 1);
      if (newTime.inSeconds < 0) {
        player.play('alarm.mp3');
        setState(() {
          if (currentTimerType == timerType.sessionType) {
            currentTimerType = timerType.breakType;
            currentTime =
                Provider.of<Settings>(context, listen: false).breakDuration +
                    const Duration(seconds: 3);
          } else {
            currentTimerType = timerType.sessionType;
            currentTime =
                Provider.of<Settings>(context, listen: false).sessionDuration +
                    const Duration(seconds: 3);
          }
        });
      } else {
        currentTime = newTime;
      }
    });
  }

  playPause() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      setState(() {
        isRunning = false;
      });
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (_) => count());
      setState(() {
        isRunning = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro timer'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text(currentTimerType == timerType.sessionType
                ? 'Work time 🤓'
                : 'Break time ✨'),
            Counter(count: currentTime),
            ElevatedButton(
              onPressed: playPause,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isRunning ? 'Pause' : 'Start'),
                  Icon(isRunning ? Icons.pause : Icons.play_arrow),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: reset,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Reset'),
                    Icon(Icons.refresh),
                  ],
                ))
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
        tooltip: 'Go to settings',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
