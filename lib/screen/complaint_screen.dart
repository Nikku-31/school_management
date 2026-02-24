import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../ViewModel/ComplaintVM/complaint_vm.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<ComplaintVM>(context, listen: false)
          .fetchComplaints(1);
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<ComplaintVM>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Complaint",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)],
            ),
          ),
        ),
      ),

      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.complaintList.isEmpty
          ? const Center(child: Text("No Complaint Found"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vm.complaintList.length,
        itemBuilder: (context, index) {

          final complaint = vm.complaintList[index];

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    complaint.complaintText ?? "",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        complaint.complaintDate ?? "",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: Text(
                          complaint.status ?? "",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}