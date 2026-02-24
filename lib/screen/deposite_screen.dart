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
        backgroundColor: const Color(0xFFF2F4F8),

        /// ===== APPBAR =====
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "Deposited Fees",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)],
              ),
            ),
          ),
        ),

        /// ===== BODY =====
        body: Consumer<FeeVM>(
          builder: (context, vm, child) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.fees.isEmpty) {
              return const Center(child: Text("No Data Found"));
            }

            /// ===== TOTAL CALCULATIONS =====
            int totalFeeSum =
            vm.fees.fold(0, (sum, e) => sum + e.totalFee);

            int paidSum =
            vm.fees.fold(0, (sum, e) => sum + e.paidAmount);

            int balanceSum =
            vm.fees.fold(0, (sum, e) => sum + e.balance);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  Colors.white,
                ),
                border: TableBorder.all(color: Colors.black),
                columns: const [
                  DataColumn(label: Text("Sr. No")),
                  DataColumn(label: Text("Fee Month")),
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Total Fee")),
                  DataColumn(label:  Text("Received fee")),
                  DataColumn(label: Text("Balance")),
                ],
                rows: [

                  ...List.generate(vm.fees.length, (i) {
                    final f = vm.fees[i];
                    int balance = f.balance;
                    return DataRow(
                      cells: [
                        DataCell(Text("${i + 1}")),
                        DataCell(Text(f.feeMonth)),
                        DataCell(Text(
                          DateFormat("dd-MMM-yyyy").format(f.collectionDate)
                          ,
                        ),
                        ),
                        DataCell(Text("${f.totalFee}")),
                        DataCell(Text("${f.paidAmount}")),
                        DataCell(Text("$balance")),
                      ],
                    );
                  }),

                  DataRow(
                    color: MaterialStateProperty.all(
                      Colors.white
                    ),
                    cells: [
                      const DataCell(Text("")),
                      const DataCell(Text("Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      const DataCell(Text("")),
                      DataCell(Text("$totalFeeSum",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )),
                      DataCell(Text("$paidSum",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )),
                      DataCell(Text("$balanceSum",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}