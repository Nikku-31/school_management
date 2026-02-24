import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../ViewModel/FeeVM/fee_pending_vm.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PendingVM()..getPending(461),

      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F8),

        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text("Pending Fees",
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

        body: Consumer<PendingVM>(
          builder: (context, vm, child) {

            print("UI LENGTH: ${vm.pendingList.length}");

            if (vm.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!vm.loading && vm.pendingList.isEmpty) {
              return const Center(
                child: Text("No Pending Fees"),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: DataTable(
                            columnSpacing: 0,
                            horizontalMargin: 0,
                            border: TableBorder(
                              horizontalInside:
                              BorderSide(color: Colors.grey, width: 1),
                              verticalInside:
                              BorderSide(color: Colors.grey, width: 1),
                            ),
                            headingRowColor:
                            MaterialStateProperty.all(Colors.white),

                            columns: [
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: const Center(
                                    child: Text(
                                      "Sr No",
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 150,
                                  child: const Center(
                                    child: Text(
                                      "Month",
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(label: SizedBox(
                                  width: 120,
                                  child: const Center(
                                    child: Text(
                                      "Fees",
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            rows: [
                              ...List.generate(
                                vm.pendingList.length,
                                    (i) {
                                  final p = vm.pendingList[i];
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text("${i + 1}"))),
                                      DataCell(Center(child: Text(p.monthName))),
                                      DataCell(
                                          Center(child: Text("₹ ${p.monthlyFee}"))),
                                    ],
                                  );
                                },
                              ),

                              DataRow(
                                cells: [
                                  const DataCell(Text("")),
                                  const DataCell(
                                    Center(
                                      child: Text(
                                        "Total",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "₹ ${vm.totalMonthlyFee}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}