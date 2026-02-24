import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../ViewModel/AccountVM/send_login_viewModel.dart';
import '../screen/forgot_password.dart';
import 'app_button.dart';
import 'dashbord_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Soft professional grey-white
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              // 1. Header with Gradient Background
              Container(
                width: double.infinity,
                height: size.height * 0.45,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school, size: 70, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Welcome",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      "Login to your student account",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),

              // 2. Login Form Card
              Positioned(
                top: size.height * 0.35,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Consumer<SendLoginViewModel>(
                      builder: (context, vm, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 25),
                            _buildTextField(
                              controller: userIdController,
                              label: "User ID",
                              icon: Icons.person_outline,
                              validator: (v) => v!.isEmpty ? "Enter User ID" : null,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: passwordController,
                              label: "Password",
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscurePassword,
                              toggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                              validator: (v) => v!.length < 6 ? "Minimum 6 chars" : null,
                            ),
                            const SizedBox(height: 30),
                            vm.isLoading
                                ? Center(child: const CircularProgressIndicator(color: Colors.amber))
                                : AppButton(
                              title2: "LOGIN",
                              onPress1: () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await vm.login(
                                    username: userIdController.text,
                                    password: passwordController.text,
                                  );

                                  if (mounted) {
                                    // Clear any existing snackbars before showing a new one
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                    if (success) {
                                      // ✅ Show Success Message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Welcome back, ${vm.student?.studentName ?? 'Student'}!", style: GoogleFonts.poppins(),),
                                          backgroundColor: Color(0xFFAB47BC),
                                          behavior: SnackBarBehavior.floating, // Makes it look more modern
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                      if (mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DashboardScreen(student: vm.student),
                                          ),
                                        );
                                      }
                                    } else {
                                      // ❌ Show Error Message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(Icons.error_outline, color: Colors.white),
                                              const SizedBox(width: 10),
                                              Expanded(child: Text(vm.errorMessage ?? "Login failed. Please check your credentials.", style: GoogleFonts.poppins(),)),
                                            ],
                                          ),
                                          backgroundColor: Colors.redAccent,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          margin: const EdgeInsets.all(15), // Adds spacing from edges
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPassword())),
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.poppins(color: Colors.blueAccent, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for clean text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.poppins(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: toggleVisibility,
        )
            : null,
        filled: true,
        fillColor: const Color(0xFFF0F4F8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
      validator: validator,
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent));
  }
}