import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'components/button.dart';
import 'counter.dart';
import 'settings/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          primaryColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)),
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
    Provider.of<Settings>(context, listen: false).settingsApplied();
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text(
                currentTimerType == timerType.sessionType
                    ? 'Work time 🤓'
                    : 'Break time ✨',
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.w100)),
            const SizedBox(height: 40),
            Counter(count: currentTime),
            Button(
              onPressed: playPause,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isRunning ? 'Pause' : 'Start'),
                  Icon(isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white),
                ],
              ),
            ),
            Button(
                onPressed: reset,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Reset'),
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ],
                )),
            Consumer<Settings>(builder: (context, settings, _) {
              if (settings.settingsChanged) {
                return const Text('You change the settings, reset to apply',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600));
              }
              return Container();
            }),
          ])),
      floatingActionButton: Button(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
        child: const Icon(Icons.settings, color: Colors.white),
      ),
    );
  }
}
