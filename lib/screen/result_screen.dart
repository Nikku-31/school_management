import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}
class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Result",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            resultCard(
              session: "Session - 2024-25",
              status: "Passed",
              statusColor: Colors.green,
            ),
            const SizedBox(height: 10),
            resultCard(
              session: "Session - 2023-24",
              status: "Passed",
              statusColor: Colors.green,
            ),
            const SizedBox(height: 10),
            resultCard(
              session: "Session - 2022-23",
              status: "Passed",
              statusColor: Colors.green,
            ),
            const SizedBox(height: 10),
            resultCard(
              session: "Session - 2021-22",
              status: "Failed",
              statusColor: Colors.red,
            ),
          ],
        ),
      ),

    );
  }
}
Widget resultCard({
  required String session,
  required String status,
  required Color statusColor,
}) {
  return SizedBox(
    width: double.infinity,
    child: Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Status : $status",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // button
            Positioned(
              top: 15,
              right: 16,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "View",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}