import 'package:app/ViewModel/AccountVM/change_password_view_model.dart';
import 'package:app/widget/dashbord_screen.dart';
import 'package:app/widget/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppManager/Services/NotificationS/notification_service.dart';
import 'ViewModel/AttendanceVM/attendance_vm.dart';
import 'ViewModel/AttendanceVM/student_attendance_vm.dart';
import 'ViewModel/HomeWorkVM/hw_viewm.dart';
import 'ViewModel/AccountVM/send_login_viewModel.dart';
import 'ViewModel/AccountVM/student_details_view_model.dart';
import 'ViewModel/ComplaintVM/complaint_vm.dart';
import 'ViewModel/FeeVM/get_student_fee_view_model.dart';
import 'ViewModel/FeeVM/save_fee_view_model.dart';
import 'ViewModel/NewsVM/news_view_model.dart';
import 'widget/login_screen.dart';
 // ✅ Make sure path correct

/// 🔥 Background Handler (Required)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 BACKGROUND MESSAGE RECEIVED");
  print("DATA: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 Initialize Firebase
  await Firebase.initializeApp();

  /// 🔥 Register background handler
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  final prefs = await SharedPreferences.getInstance();
  int isFirstTime = prefs.getInt('isFirstTime') ?? 1;
  int? userId = prefs.getInt('user_id');

  runApp(MyApp(isFirstTime: isFirstTime, userId: userId));
}

class MyApp extends StatefulWidget {
  final int isFirstTime;
  final int? userId;

  const MyApp({
    super.key,
    required this.isFirstTime,
    required this.userId,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

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
        ChangeNotifierProvider(create: (_) => StudentAttendanceStatusViewModel()),
        ChangeNotifierProvider(create: (_) => HwViewModel()),
        ChangeNotifierProvider(create: (_) => ComplaintVM()),
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
    if (widget.userId != null && widget.userId != 0) {
      return const DashboardScreen();
    }

    if (widget.isFirstTime == 1) {
      return const SplashScreen();
    }

    return const LoginScreen();
  }
}