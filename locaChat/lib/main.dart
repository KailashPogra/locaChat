import 'package:locachat/constants/globle_variable.dart';
import 'package:locachat/features/notification/notification_services.dart';
import 'package:locachat/features/splash/splash_screen.dart';
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
          theme: ThemeData(
              useMaterial3: false,
              scaffoldBackgroundColor: GlobleVariable.backgroundColor,
              colorScheme:
                  ColorScheme.light(primary: GlobleVariable.secondaryColor),
              appBarTheme: const AppBarTheme(
                  elevation: 0, iconTheme: IconThemeData(color: Colors.black))),
          home: SplashScreen()),
    );
  }
}
