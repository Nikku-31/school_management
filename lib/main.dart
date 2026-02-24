import 'package:app/ViewModel/AccountVM/change_password_view_model.dart';
import 'package:app/widget/dashbord_screen.dart';
import 'package:app/widget/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ViewModel/AttendanceVM/attendance_vm.dart';
import 'ViewModel/HomeWorkVM/hw_viewm.dart';
import 'ViewModel/AccountVM/send_login_viewModel.dart';
import 'ViewModel/AccountVM/student_details_view_model.dart';
import 'ViewModel/ComplaintVM/complaint_vm.dart';
import 'ViewModel/FeeVM/get_student_fee_view_model.dart';
import 'ViewModel/FeeVM/save_fee_view_model.dart';
import 'ViewModel/NewsVM/news_view_model.dart';
import 'core/services/navigation_service.dart';
import 'widget/login_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase
  await Firebase.initializeApp();

  // 3. Set background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final prefs = await SharedPreferences.getInstance();
  int isFirstTime = prefs.getInt('isFirstTime') ?? 1;
  int? userId = prefs.getInt('user_id');

  runApp(MyApp(isFirstTime: isFirstTime, userId: userId));
}

class MyApp extends StatefulWidget { // Changed to StatefulWidget to use initState
  final int isFirstTime;
  final int? userId;
  const MyApp({super.key, required this.isFirstTime, required this.userId});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  void _setupNotifications() {
    _notificationService.requestNotificationPermission();
    _notificationService.firebaseInit(context);
    _notificationService.setupInteractMessage(context);

    // If user is already logged in, update token to backend
    if (widget.userId != null && widget.userId != 0) {
      _notificationService.updateTokenToBackend(widget.userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SendLoginViewModel()),
        ChangeNotifierProvider(create: (_) => StudentFeeViewModel()),
        ChangeNotifierProvider(create: (_) => SaveFeeViewModel()),
        ChangeNotifierProvider(create: (_) => NewsViewModel()),
        ChangeNotifierProvider(create: (_) => StudentDetailViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => AttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => HwViewModel(),),
        ChangeNotifierProvider(create: (_) => ComplaintVM(),),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'School Management',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: _getHome(),
      ),
    );
  }

  Widget _getHome() {
    // Use 'widget.' prefix to access variables from the MyApp class

    // 1. If user is logged in, ALWAYS go to Dashboard
    if (widget.userId != null && widget.userId != 0) {
      return const DashboardScreen();
    }

    // 2. If not logged in and it's the first time, show Splash/Onboarding
    if (widget.isFirstTime == 1) {
      return const SplashScreen();
    }

    // 3. Otherwise, go to Login
    return const LoginScreen();
  }
}