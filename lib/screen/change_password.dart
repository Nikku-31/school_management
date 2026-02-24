import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ViewModel/AccountVM/change_password_view_model.dart';
import '../widget/app_button.dart';
import 'widgets/custom_text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  // Local instance of ViewModel
  final ChangePasswordViewModel _viewModel = ChangePasswordViewModel();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool oldObscure = true;
  bool newObscure = true;
  bool confirmObscure = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Helper method to handle the API call
  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator or update button state via ViewModel
      setState(() {});

      try {
        final message = await _viewModel.updatePassword(
          oldPasswordController.text.trim(),
          newPasswordController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message ?? "Password changed successfully", style: GoogleFonts.poppins(),),
              backgroundColor: Color(0xFFAB47BC),
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Optional: Clear fields or navigate back
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll("Exception: ", ""), style: GoogleFonts.poppins()),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) setState(() {}); // Refresh UI state (loading)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Change Password",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Top Illustration
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.lock_open_rounded,
                        size: 140,
                        color: const Color(0xFFAB47BC).withOpacity(0.1)),
                    const Icon(Icons.vpn_key_rounded,
                        size: 50,
                        color: Color(0xFF42A5F5)),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // OLD PASSWORD FIELD
              CustomTextField(
                controller: oldPasswordController,
                hintText: "Old Password",
                obscureText: oldObscure,
                suffixIcon: IconButton(
                  icon: Icon(oldObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: () => setState(() => oldObscure = !oldObscure),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your old password";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // NEW PASSWORD FIELD
              CustomTextField(
                controller: newPasswordController,
                hintText: "New Password",
                obscureText: newObscure,
                suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                validator: (value) {
                  if (value == null || value.length < 6) return "Password must be at least 6 characters";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // CONFIRM PASSWORD FIELD
              CustomTextField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: confirmObscure,
                validator: (value) {
                  if (value != newPasswordController.text) return "Passwords do not match";
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // ACTION BUTTON with Loading check
              _viewModel.isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF42A5F5))
                  : AppButton(
                title2: "Confirm Change",
                onPress1: _handleChangePassword,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}