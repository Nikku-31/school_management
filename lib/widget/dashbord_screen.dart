import 'package:app/widget/fees_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AppManager/Services/NotificationS/notification_service.dart';
import '../Model/AccountM/send_login_model.dart';
import '../ViewModel/AccountVM/send_login_viewModel.dart';
import '../ViewModel/AccountVM/student_details_view_model.dart';
import '../screen/attendance_screen.dart';
import '../screen/change_password.dart';
import '../screen/complaint_screen.dart';
import '../screen/deposite_screen.dart';
import '../screen/home_work.dart';
import '../screen/language.dart';
import '../screen/news_page.dart';
import '../screen/notification_screen.dart';
import '../screen/pending_screen.dart';
import '../screen/suggestion_screen.dart';
import '../screen/syllabus_screen.dart';
import '../screen/time_table.dart';
import 'edit_profile.dart';
import 'login_screen.dart';
import 'package:shimmer/shimmer.dart';


class DashboardScreen extends StatefulWidget {
  final Student? student;
  const DashboardScreen({super.key, this.student});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool isMenuOpen = false;

  int notificationCount = 0;
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    final notificationService = NotificationService();

    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);

    // App opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // handle if needed
    });

    // Background notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
    // We use microtask or addPostFrameCallback to ensure the context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Replace 'fetchStudentDetails' with whatever your actual method name is
      Provider.of<StudentDetailViewModel>(context, listen: false).getStudentDetails();
    });
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Your UI is driven by bloc's state.currentIndex, so drive the bloc:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0
          ? AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Amar Shiksha Sadan Sr. Sec. School",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
        ),
        //MENU ICON
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            setState(() {
              isMenuOpen = !isMenuOpen;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFAB47BC), Color(0xFF42A5F5)],
            ),
          ),
        ),
      )
          : null,
      body: SizedBox.expand(
        child: Stack(
          children: [
            _getBody(),
            if (_selectedIndex == 0) _slideMenu(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(CupertinoIcons.home, 'Home', 0),
            _navItem(CupertinoIcons.creditcard, 'Fees', 1),
            _navItem(CupertinoIcons.person, 'Profile', 2),
          ],
        ),
      ),
    );
  }
  //HOME BODY
  Widget _homeBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: [
              _HomeCard(
                title: "Attendance",
                icon: Icons.event_available,
                bgColor: Colors.pinkAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceScreen(),
                    ),
                  );
                },
              ),_HomeCard(
                title: "Deposite Fees",
                icon: Icons.hourglass_empty,
                bgColor: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DepositeScreen(),
                    ),
                  );
                },
              ),
              _HomeCard(
                title: "Pending Fees",
                icon: Icons.payments,
                bgColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PendingScreen(),
                    ),
                  );
                },
              ),
              _HomeCard(
                title: "Syllabus",
                icon: Icons.library_books,
                bgColor: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SyllabusScreen(),
                    ),
                  );
                },
              ),
              _HomeCard(
                title: "Homework",
                icon: Icons.menu_book,
                bgColor: Colors.teal,
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(
                      builder:(context)=> const HomeWork()));
                },
              ),
              _HomeCard(
                title: "TimeTable",
                icon: Icons.access_time,
                bgColor: Colors.red.shade400,
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder:
                          (context)=> const TimeTable()));
                },
              ),
              _HomeCard(
                title: 'Complaint',
                icon: Icons.feedback,
                bgColor: Colors.blueGrey,
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder:
                          (context)=> const ComplaintScreen()));
                },
              ),
              _HomeCard(
                title: 'Suggestion',
                icon: Icons.tips_and_updates,
                bgColor: Colors.green,
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder:
                          (context)=> const SuggestionScreen()));
                },),
              _HomeCard(
                title: "Result",
                icon: Icons.bar_chart,
                bgColor: Colors.deepPurpleAccent.shade100,
                // onTap: (){
                //   Navigator.push(context, MaterialPageRoute(builder:
                //       (context)=> const ResultScreen()));
                // },
              ),_HomeCard(
                title: "News",
                icon: Icons.bar_chart,
                bgColor: Colors.red.shade400,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context)=> const NewsPage()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  // SLIDE MENU
  Widget _slideMenu() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: isMenuOpen ? 0 : -225,
      top: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          width: 225,
          color: Colors.grey.shade200,
          child: Column(
            children: [
              const SizedBox(height: 20),
              // PROFILE IMAGE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Stack(
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFAB47BC), Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                            child: const Icon(Icons.person,
                              size: 36, color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Consumer<StudentDetailViewModel>(
                          builder: (context, vm, _) {
                            final student = vm.student;

                            // Check if the VM is currently fetching data
                            if (vm.isLoading) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Shimmer for Name
                                    Container(
                                      width: 150,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 8), // Match your layout spacing
                                    // Shimmer for Class/Section
                                    Container(
                                      width: 100,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            // Actual UI when data is ready
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student?.studentName ?? "Unknown Student",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${student?.className ?? ''} ${student?.sectionName ?? ''}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],
                            );
                          },
                        )
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 20),
              // MENU ITEMS
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  "Student Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() => isMenuOpen = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(
                  "Language",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() => isMenuOpen = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Language(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.password),
                title: Text(
                  "Change Password",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() => isMenuOpen = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePassword(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text("Setting",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text("Logout",
                  style: GoogleFonts.poppins(fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        "Logout",
                        style: GoogleFonts.poppins(color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                      content: Text(
                        "Are you sure you want to logout?",
                        style: GoogleFonts.poppins(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // 1. Get the ViewModel and trigger the logout logic
                            final loginVM = Provider.of<SendLoginViewModel>(context, listen: false);

                            // ✅ This removes user_id and student_data from SharedPreferences
                            await loginVM.logout();

                            // 2. Close the dialog (Check if mounted to avoid context errors)
                            if (context.mounted) {
                              Navigator.pop(context);
                            }

                            // 3. Navigate to Login and clear all previous routes
                            // This prevents the user from pressing 'Back' to return to the dashboard
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                    (route) => false, // This removes the entire navigation stack
                              );
                            }
                          },
                          child: Text(
                            "Logout",
                            style: GoogleFonts.poppins(
                              color: Colors.red, // Changed to red as a standard UI pattern for 'Logout'
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(),
              // FOOTER
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  "Powerd by ASL Computers",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          isMenuOpen = false;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
            color: isSelected ? Colors.black : Colors.grey,
          ),
          Text(label, style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.black : Colors.grey,
          ),
          ),
        ],
      ),
    );
  }
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _homeBody();
      case 1:
      // return const FeesScreen();
        return FeesScreen(student: widget.student);
      case 2:
        return const EditProfile();
      default:
        return _homeBody();
    }
  }
}
//HOME CARD WIDGET
class _HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final VoidCallback? onTap;
  const _HomeCard({
    required this.title,
    required this.icon,
    required this.bgColor,
    this.onTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: bgColor.withOpacity(0.7),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 36, color: Colors.white),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}