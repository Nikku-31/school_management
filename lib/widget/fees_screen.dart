import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../Model/AccountM/send_login_model.dart';
import '../Model/FeeM/save_fee_model.dart';
import '../ViewModel/AccountVM/student_details_view_model.dart';
import '../ViewModel/FeeVM/get_student_fee_view_model.dart';
import '../ViewModel/FeeVM/save_fee_view_model.dart';
import '../screen/payment_web_view.dart';
import '../screen/widgets/pending_shimmer.dart';
import '../screen/widgets/pending_widgets.dart';

class FeesScreen extends StatefulWidget {
  final Student? student;
  const FeesScreen({super.key, this.student});
  @override
  State<FeesScreen> createState() => _FeesScreenState();
}
class _FeesScreenState extends State<FeesScreen> {  // ---------------- CONTROLLERS ----------------
  late TextEditingController admissionNoController;
  late TextEditingController nameController;
  late TextEditingController fatherNameController;
  late TextEditingController classController;
  late TextEditingController sectionController;
  late TextEditingController dateController;
  late TextEditingController feePayableController;
  late TextEditingController feePaidController;
  late TextEditingController balanceController;

  String? selectedMonth;
  List<int> pendingMonthsToPay = [];
  List<String> availableMonths = [];

  final List<String> fullMonthsList = [
    "Upto April 2025", "Upto May 2025", "Upto June 2025", "Upto July 2025",
    "Upto August 2025", "Upto September 2025", "Upto October 2025", "Upto November 2025",
    "Upto December 2025", "Upto January 2026", "Upto February 2026", "Upto March 2026",
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final detailVM = context.read<StudentDetailViewModel>();
      await detailVM.getStudentDetails();

      if (detailVM.student != null) {
        _updateUI(detailVM.student!);
        _refreshAvailableMonths();
      }
    });
  }

  void _initControllers() {
    admissionNoController = TextEditingController();
    nameController = TextEditingController();
    fatherNameController = TextEditingController();
    classController = TextEditingController();
    sectionController = TextEditingController();
    dateController = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
    feePayableController = TextEditingController();
    feePaidController = TextEditingController(text: "0");
    balanceController = TextEditingController();
  }

  void _updateUI(dynamic student) {
    setState(() {
      admissionNoController.text = student.admissionNo.toString();
      nameController.text = student.studentName;
      fatherNameController.text = student.fatherName;
      classController.text = student.className;
      sectionController.text = student.sectionName;
    });
  }

  /// Filters months: only shows months from the first unpaid one onwards
  Future<void> _refreshAvailableMonths() async {
    final feeVM = context.read<StudentFeeViewModel>();
    final detailVM = context.read<StudentDetailViewModel>();

    List<int> academicCycle = [4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3];
    List<String> tempAvailable = [];

    setState(() => feeVM.isLoading = true);

    try {
      for (int i = 0; i < academicCycle.length; i++) {
        int monthNum = academicCycle[i];
        await feeVM.getFees(detailVM.student!.admissionNo, monthNum);

        if (!feeVM.isAlreadyPaid) {
          for (int j = i; j < fullMonthsList.length; j++) {
            tempAvailable.add(fullMonthsList[j]);
          }
          break;
        }
      }

      setState(() {
        availableMonths = tempAvailable;
        if (availableMonths.isNotEmpty) {
          selectedMonth = availableMonths.first;
          _calculatePendingRange(selectedMonth!);
        }
      });
    } catch (e) {
      debugPrint("Error filtering months: $e");
    } finally {
      setState(() => feeVM.isLoading = false);
    }
  }

  /// Calculates total payable based on number of months in range
  void _calculatePendingRange(String selection) {
    final feeVM = context.read<StudentFeeViewModel>();

    int targetMonthNum = _getMonthNumber(selection);
    List<int> academicCycle = [4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3];
    int startMonthNum = _getMonthNumber(availableMonths.first);

    int startIndex = academicCycle.indexOf(startMonthNum);
    int endIndex = academicCycle.indexOf(targetMonthNum);

    pendingMonthsToPay = academicCycle.sublist(startIndex, endIndex + 1);

    // Total = Per Month Total * Number of Selected Months
    double total = feeVM.totalPayable * pendingMonthsToPay.length;

    setState(() {
      feePayableController.text = total.toStringAsFixed(2);
      feePaidController.text = total.toStringAsFixed(2);
      balanceController.text = "0.00";
    });
  }

  int _getMonthNumber(String monthStr) {
    Map<String, int> monthMap = {
      "April": 4, "May": 5, "June": 6, "July": 7, "August": 8, "September": 9,
      "October": 10, "November": 11, "December": 12, "January": 1, "February": 2, "March": 3,
    };
    for (var month in monthMap.keys) {
      if (monthStr.contains(month)) return monthMap[month]!;
    }
    return 4;
  }

  String _getMonthName(int n) {
    return ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][n];
  }

  void _handleSave() async {
    final feeVM = context.read<StudentFeeViewModel>();
    final detailVM = context.read<StudentDetailViewModel>();
    final saveVM = context.read<SaveFeeViewModel>();

    if (detailVM.student == null || pendingMonthsToPay.isEmpty) return;

    // --- Prepare Request ---
    int baseYear = feeVM.baseFeeYear;
    List<SelectedMonthItem> selectedMonthsRange = pendingMonthsToPay.map((m) {
      int yearForThisMonth = (m >= 1 && m <= 3) ? baseYear : baseYear - 1;
      return SelectedMonthItem(feeMonth: m, feeYear: yearForThisMonth);
    }).toList();

    List<FeeDetailItem> details = feeVM.feeList.map((f) {
      return FeeDetailItem(
        feeHeadId: f.feeHeadId,
        originalFee: f.feeAmount,
        actualFee: f.feeAmount,
      );
    }).toList();

    SaveFeeRequest request = SaveFeeRequest(
      studentId: detailVM.student!.studentId,
      feePaid: double.tryParse(feePayableController.text) ?? 0.0,
      balance: 0.0,
      feePayable: double.tryParse(feePayableController.text) ?? 0.0,
      feeDetails: details,
      selectedMonths: selectedMonthsRange,
    );

    // --- Call API ---
    String? initialUrl = await saveVM.postFee(request);

    if (initialUrl != null && initialUrl.isNotEmpty) {
      if (!mounted) return;

      // --- Open WebView and wait for the String Message ---
      final dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebView(paymentUrl: initialUrl),
        ),
      );

      // --- Show SnackBar and Refresh ---
      if (result != null && result is String && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result), // Displays: "Fee collected successfully0000"
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
        _refreshAvailableMonths();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to initiate payment"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final feeVM = context.watch<StudentFeeViewModel>();
    final detailVM = context.watch<StudentDetailViewModel>();

    int monthCount = pendingMonthsToPay.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("Fees Collection",
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)]),
          ),
        ),
      ),
      body: (detailVM.isLoading)
          ? const PendingShimmer()
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- DROPDOWN WITH SHIMMER LOGIC ---
                  feeVM.isLoading
                      ? _buildDropdownShimmer()
                      : (availableMonths.isEmpty
                      ? _buildPaidStatus()
                      : _buildDropdown()),

                  const SizedBox(height: 12),
                  PendingWidgets.inputRow("Admission No", "Admission No", controller: admissionNoController, readOnly: true),
                  PendingWidgets.inputRow("Date", "Date", controller: dateController, readOnly: true),
                  const SizedBox(height: 20),
                  _sectionLabel("Student Name"),
                  PendingWidgets.textField("Student Name", controller: nameController, readOnly: true),
                  const SizedBox(height: 14),
                  _sectionLabel("Father's Name"),
                  PendingWidgets.textField("Father's Name", controller: fatherNameController, readOnly: true),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _buildInfoColumn("Class", classController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoColumn("Section", sectionController)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (!feeVM.isLoading && pendingMonthsToPay.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Paying for $monthCount months: ${pendingMonthsToPay.map((m) => _getMonthName(m)).join(', ')}",
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                      ),
                    ),

                  Text("Fee Details (Total for $monthCount months)", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  _buildTableHeader(),

                  if (feeVM.isLoading)
                    _buildShimmerLoading()
                  else if (feeVM.feeList.isEmpty && availableMonths.isNotEmpty)
                    const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No fee details found.")))
                  else
                  // Showing Total for each head based on month multiplier
                    ...feeVM.feeList.map((fee) {
                      double totalHeadFee = fee.feeAmount * monthCount;
                      return PendingWidgets.feeRow(
                        fee.feeName,
                        totalHeadFee.toStringAsFixed(2),
                        totalHeadFee.toStringAsFixed(2),
                      );
                    }),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(child: PendingWidgets.inputField("Total Payable", "", filled: true, controller: feePayableController, readOnly: true)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _payButton(feeVM),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- COMPONENT WIDGETS ---

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text("Select Month Range", style: GoogleFonts.poppins(fontSize: 14)),
        value: selectedMonth,
        items: availableMonths.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item, style: GoogleFonts.poppins(fontSize: 14)),
        )).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => selectedMonth = value);
            _calculatePendingRange(value);
          }
        },
      ),
    );
  }

  Widget _buildDropdownShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildPaidStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text("All fees paid for this session.",
              style: GoogleFonts.poppins(color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _payButton(StudentFeeViewModel feeVM) {
    return Align(
      alignment: Alignment.centerRight,
      child: Consumer<SaveFeeViewModel>(
        builder: (context, saveVM, _) {
          bool isDisabled = saveVM.isSaving || availableMonths.isEmpty || feeVM.isLoading;
          return SizedBox(
            height: 42,
            width: 100,
            child: ElevatedButton(
              onPressed: isDisabled ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: saveVM.isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text("Pay", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoColumn(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(label),
        const SizedBox(height: 6),
        PendingWidgets.textField(label, controller: controller, readOnly: true),
      ],
    );
  }

  Widget _sectionLabel(String text) => Text(text, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500));

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: Colors.grey.shade300,
      child: Row(
        children: [
          Expanded(flex: 3, child: _headerText("Fees Head")),
          Expanded(flex: 2, child: _headerText("Total Fees")),
          Expanded(flex: 2, child: _headerText("Total Actual")),
        ],
      ),
    );
  }

  Widget _headerText(String text) => Text(text, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600));

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(3, (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              Expanded(flex: 3, child: Container(height: 14, color: Colors.white)),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: Container(height: 14, color: Colors.white)),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: Container(height: 14, color: Colors.white)),
            ],
          ),
        )),
      ),
    );
  }

  @override
  void dispose() {
    admissionNoController.dispose();
    nameController.dispose();
    fatherNameController.dispose();
    classController.dispose();
    sectionController.dispose();
    dateController.dispose();
    feePayableController.dispose();
    feePaidController.dispose();
    balanceController.dispose();
    super.dispose();
  }
}