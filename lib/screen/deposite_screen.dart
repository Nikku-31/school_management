import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../ViewModel/FeeVM/fee_recevie_vm.dart';
import 'package:intl/intl.dart';
class DepositeScreen extends StatelessWidget {
  const DepositeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeeVM()..getFees(461),
      child: Scaffold(
        backgroundColor:Colors.white,

        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text("Deposite fees",
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)]),
            ),
          ),
        ),

        body: SafeArea(
          child: Consumer<FeeVM>(
            builder: (context, vm, child) {

              if (vm.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (vm.fees.isEmpty) {
                return const Center(
                  child: Text(
                    "No Data Found",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              // ===== TOTAL CALCULATIONS =====
              int totalFeeSum =
              vm.fees.fold(0, (sum, e) => sum + e.totalFee);

              int paidSum =
              vm.fees.fold(0, (sum, e) => sum + e.paidAmount);

              int balanceSum =
              vm.fees.fold(0, (sum, e) => sum + e.balance);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    // ================== LIST ==================
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.fees.length,
                        itemBuilder: (context, index) {

                          final f = vm.fees[index];

                          return Container(
                            margin:
                            const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  Colors.grey.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset:
                                  const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [

                                // ===== CONTENT =====
                                Expanded(
                                  child: Padding(
                                    padding:const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        // Month + Date
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(f.feeMonth,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              DateFormat(
                                                  "dd-MMM-yyyy").format(f.collectionDate),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        // Status Chip
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: f.balance == 0
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(f.balance == 0
                                                ? "Paid" : "Pending",
                                            style: TextStyle(
                                              color: f.balance == 0
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                            height: 14),

                                        // ===== AMOUNT ROW =====
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            _amountBox("Total", f.totalFee, Colors.black),

                                            _amountBox("Paid", f.paidAmount, Colors.green),

                                            _amountBox("Balance", f.balance, Colors.red),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // ================== SUMMARY CARD ==================
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _summaryRow("Total Fee", totalFeeSum),
                          const SizedBox(height: 6),
                          _summaryRow("Total Paid", paidSum),
                          const SizedBox(height: 6),
                          _summaryRow("Total Balance", balanceSum),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ===== Amount Box =====
  static Widget _amountBox(
      String title, int amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "₹ $amount",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ===== Summary Row =====
  static Widget _summaryRow(
      String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        Text(
          "₹ $value",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}