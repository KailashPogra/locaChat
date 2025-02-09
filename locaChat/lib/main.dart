import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:locachat/screens/notification/notification_services.dart';
import 'package:locachat/screens/splash/splash_screen.dart';
import 'package:locachat/provider/chat_screen_provider.dart';
import 'package:locachat/provider/chat_users_provider.dart';
import 'package:locachat/provider/home_screen_provider.dart';
import 'package:locachat/provider/save_chat_provider.dart';
import 'package:locachat/provider/sign_in_provider.dart';
import 'package:locachat/provider/sign_up_provider.dart';
import 'package:locachat/provider/update_profile_provider.dart';
import 'package:locachat/repository/post_fcm.dart';
import 'package:locachat/routs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('apiCache');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

NotificationService notificationService = NotificationService();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp();

  notificationService.showNotification(message);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PostFcmRepository postFcmRepository = PostFcmRepository();
  @override
  void initState() {
    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    notificationService.getDiviceToken().then((value) {
      Map<String, String> data = {
        "fcmToken": value.toString(),
      };
      postFcmRepository.postFcmApi(data);
    });
    notificationService.forgroundMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatScreenProvider()),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => SignInProvider()),
        ChangeNotifierProvider(create: (context) => UpdateProfileProvider()),
        ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (context) => SaveChatProvider()),
        ChangeNotifierProvider(create: (context) => ChatUsersScreenProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.generateRoutes,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: const SplashScreen()),
    );
  }
}
