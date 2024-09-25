import 'dart:convert';

import 'package:book_stash/auth/ui/login_screen.dart';
import 'package:book_stash/auth/ui/signup_screen.dart';
import 'package:book_stash/firebase_options.dart';
import 'package:book_stash/notification_service.dart';
import 'package:book_stash/pages/home.dart';
import 'package:book_stash/pages/message_screen.dart';
import 'package:book_stash/service/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _fireBackgroudMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("A notification Found in backGround");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //initializing firebase Messaging
  await PushNotificationHelper.init();
  //initializing Local local notifications
  await PushNotificationHelper.localNotoficationInitialization();

  FirebaseMessaging.onBackgroundMessage(_fireBackgroudMessage);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background notification tapped");
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    }
  });
  //foregorund
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadContent = jsonEncode(message.data);
    print("message found in backgrounf");
    if (message.notification != null) {
      PushNotificationHelper.showLocalNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadContent);
    }
  });
  // for handling terminated state
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print("terminated state");
    Future.delayed(Duration(seconds: 3), () {
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      navigatorKey: navigatorKey,
      //home: const LoginScreen(),
      routes: {
        "/": (context) => const CheckUserBookStash(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const Home(),
        "/signup": (context) => const SignupScreen(),
        "/message": (context) => const MessageScreen(),
      },
    );
  }
}

class CheckUserBookStash extends StatefulWidget {
  const CheckUserBookStash({super.key});

  @override
  State<CheckUserBookStash> createState() => _CheckUserBookStashState();
}

class _CheckUserBookStashState extends State<CheckUserBookStash> {
  @override
  void initState() {
    AuthServiceHelper.isUserLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
