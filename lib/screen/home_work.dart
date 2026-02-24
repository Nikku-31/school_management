import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../ViewModel/HomeWorkVM/hw_viewm.dart';

class HomeWork extends StatefulWidget {
  const HomeWork({super.key});

  @override
  State<HomeWork> createState() => _HomeWorkState();
}

class _HomeWorkState extends State<HomeWork> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HwViewModel>(context, listen: false).getHomework();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HwViewModel>(
      builder: (context, vm, child) {

        final filteredHomework =
        vm.filterByDate(_selectedDay);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              "Home Work",
              style: GoogleFonts.poppins(
                fontSize: 20,
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
          body: Column(
            children: [
              // Calendar
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  color: Colors.white,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2001),
                    lastDay: DateTime.utc(2030),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      //api call
                      Provider.of<HwViewModel>(context,listen: false).getHomework();
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFF42A5F5),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color(0xFFAB47BC),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(color: Colors.white),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Homework List
              Expanded(
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredHomework.isEmpty
                    ? const Center(
                  child: Text(
                    "No Homework this Date",
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredHomework.length,
                  itemBuilder: (context, index) {
                    final hw = filteredHomework[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${hw.subjectName} - ${hw.title}",
                                style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text("Remarks: ${hw.remarks}"),
                              const SizedBox(height: 6),
                              Text(
                                "Class: ${hw.className} | Section: ${hw.sectionName}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
