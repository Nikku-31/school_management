import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../ViewModel/SyllabusVM/syllabus_vm.dart';

class SyllabusScreen extends StatelessWidget {
  const SyllabusScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => SyllabusVM()..fetchSyllabus(1),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text("Syllabus",
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),

        body: Consumer<SyllabusVM>(
          builder: (context, vm, child) {

            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.syllabusList.isEmpty) {
              return const Center(child: Text("No Data Found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vm.syllabusList.length,
              itemBuilder: (context, index) {

                final item = vm.syllabusList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SUBJECT NAME
                        Text(
                          item.subjectName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // CLASS
                        Row(
                          children: [
                            const Icon(Icons.class_, size: 18, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              "Class: ${item.className}",
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),
                        // TITLE
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.title, size: 18, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Title: ${item.title}",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.notes, size: 18, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text("Remarks: ${item.remarks}",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        if (item.attachmentFile.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "https://login.amarshikshasadan.com${item.attachmentFile}",
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
