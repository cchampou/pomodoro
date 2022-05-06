import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro/counter.dart';
import 'package:pomodoro/settings/settings_page.dart';
import 'package:pomodoro/utils.dart';
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

class _MyHomePageState extends State<MyHomePage> {
  Duration currentTime = initialDuration;

  Timer? timer;

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
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
        tooltip: 'Go to settings',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
