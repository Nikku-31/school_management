import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../ViewModel/AccountVM/student_details_view_model.dart';
import '../screen/widgets/edit_profile_shimmer.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  @override
  void initState() {
    super.initState();

    // Trigger API Call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentDetailViewModel>().getStudentDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Student Profile",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)],
            ),
          ),
        ),
      ),
      body: Consumer<StudentDetailViewModel>(
        builder: (context, vm, child) {

          if (vm.isLoading) {
            return const EditProfileShimmer();
          }

          if (vm.student == null) {
            return const Center(child: Text("No Profile Data Found"));
          }

          final student = vm.student!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                _profileHeader(),

                const SizedBox(height: 20),

                textField("Student Name", student.studentName),
                textField("Academic Year", student.sessionName),
                textField("Campus", student.schoolName),
                textField(
                    "Class", "${student.className} ${student.sectionName}"),

                Row(
                  children: [
                    Expanded(
                        child: textField("Pickup", student.pickupTime)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: textField("Drop", student.dropTime)),
                  ],
                ),

                textField(
                    "Admission No.", student.admissionNo.toString()),

                textField("Address", student.address, maxLines: 2),

                _parentInfo(student),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- PROFILE HEADER ----------------

  Widget _profileHeader() {
    return Container(
      height: 90,
      width: 90,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)],
        ),
      ),
      child: const Icon(Icons.person, size: 40, color: Colors.white),
    );
  }

  // ---------------- PARENT INFO ----------------

  Widget _parentInfo(student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Parent Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        textField("Father Name", student.fatherName),
        textField("Contact", student.mobile),
        textField("Mother Name", student.motherName),
      ],
    );
  }

  // ---------------- COMMON TEXT FIELD ----------------

  Widget textField(String label, String? value,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            (value == null || value.isEmpty) ? "-" : value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            maxLines: maxLines,
          ),

          const Divider(thickness: 0.5),
        ],
      ),
    );
  }
}