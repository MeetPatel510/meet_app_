import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meet_app/screens/SplashScreen/splashhome_page.dart';
import 'package:meet_app/screens/SplashScreen/splashlogin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meet_app/service/util.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'models/storyManager.dart';
import 'service/firstor_helper.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;


late FirebaseAuth auth;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseBgMsg(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupFlutterNotifications();

  showNotification(0, message.notification?.title ?? "", message.notification?.body ?? "");

  print("Remote bg Msg ${message.data}");
  print("Remote bg Msg ${message.notification}");
  print('Handling a background message ${message.messageId}');
}

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  ));

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

var uuid = Uuid();
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseBgMsg);
  await setupFlutterNotifications();
  await notificationIni();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Kolkata"));
  FirebaseMessaging.instance.onTokenRefresh.listen((event) {
    print("onTokenRefresh $event");
  });
  FirebaseMessaging.instance.getToken().then((value) {
    print("getToken $value");
  });
  auth = FirebaseAuth.instance;
  FireStoreHelper();


  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StoryManager()),
      ],
      child: const MyApp()));
}
Future<void> notificationIni() async {
  await flutterLocalNotificationsPlugin.initialize(InitializationSettings(
    android: AndroidInitializationSettings("noti_icon"),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp clone',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: AuthStateChanges(),
    );
  }
}

AuthStateChanges() {
  return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return SplashPageHome();
        } else {
          return SplashLoginPage();
        }
      });
}
