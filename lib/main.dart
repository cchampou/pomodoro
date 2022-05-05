import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro/counter.dart';
import 'package:pomodoro/settings/settings_page.dart';
import 'package:pomodoro/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const initialDuration = Duration(minutes: 10);

class _MyHomePageState extends State<MyHomePage> {
  Duration sessionTime = initialDuration;
  Duration currentTime = initialDuration;

  Timer? timer;

  addSessionTime() {
    setState(() {
      sessionTime += const Duration(minutes: 1);
    });
  }

  removeSessionTime() {
    setState(() {
      sessionTime -= const Duration(minutes: 1);
    });
  }

  reset() {
    setState(() {
      currentTime = initialDuration;
    });
  }

  count() {
    setState(() {
      final newTime = currentTime - const Duration(seconds: 1);
      if (newTime.inSeconds < 0) {
        timer?.cancel();
      } else {
        currentTime = newTime;
        print(currentTime);
      }
    });
  }

  start() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => count());
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
            Counter(count: currentTime),
            ElevatedButton(
                onPressed: start,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Start'),
                    Icon(Icons.play_arrow),
                  ],
                ))
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SettingsPage(
                      sessionTime: twoDigits(currentTime.inMinutes),
                      addSessionTime: addSessionTime,
                      removeSessionTime: removeSessionTime,
                    )),
          );
        },
        tooltip: 'Go to settings',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
