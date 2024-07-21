import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'components/button.dart';
import 'counter.dart';
import 'local_notifications.dart';
import 'settings/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'settings_provider.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(ChangeNotifierProvider(
    create: (context) => Settings(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, _) {
      return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blueGrey, brightness: Brightness.light)),
        darkTheme: ThemeData(
            primaryColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blueGrey, brightness: Brightness.dark)),
        home: const MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum TimerType {
  sessionType,
  breakType,
}

class _MyHomePageState extends State<MyHomePage> {
  Duration currentTime = defaultSessionTime;
  bool isRunning = false;
  Timer? timer;
  TimerType currentTimerType = TimerType.sessionType;
  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('session', 'Current activity',
          channelDescription: 'Are you working or taking a break?',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          ticker: 'ticker');
  final NotificationDetails platformChannelSpecifics =
      const NotificationDetails(android: androidPlatformChannelSpecifics);

  @override
  initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    await Provider.of<Settings>(context, listen: false).getFromStorage();
    setState(() {
      currentTime =
          Provider.of<Settings>(context, listen: false).sessionDuration;
    });
  }

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
        flutterLocalNotificationsPlugin.show(
            0,
            'Pomodoro',
            currentTimerType == TimerType.sessionType
                ? 'Break time ✨'
                : 'Focus 🤓',
            platformChannelSpecifics);
        setState(() {
          if (currentTimerType == TimerType.sessionType) {
            currentTimerType = TimerType.breakType;
            currentTime =
                Provider.of<Settings>(context, listen: false).breakDuration +
                    const Duration(seconds: 3);
          } else {
            currentTimerType = TimerType.sessionType;
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

  playPause() async {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      setState(() {
        isRunning = false;
      });
    } else {
      await flutterLocalNotificationsPlugin.show(
          0,
          'Pomodoro',
          currentTimerType == TimerType.sessionType
              ? 'Focus 🤓'
              : 'Break time ✨',
          platformChannelSpecifics);
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
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              }),
        ],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text(
                currentTimerType == TimerType.sessionType
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Reset'),
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ],
                )),
            Container(
              height: 8,
            ),
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
    );
  }
}
