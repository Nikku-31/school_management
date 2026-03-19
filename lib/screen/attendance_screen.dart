import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../ViewModel/AttendanceVM/attendance_vm.dart';
import '../ViewModel/AttendanceVM/student_attendance_vm.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    /// 👇 Default load current date attendance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceViewModel>(context, listen: false)
          .fetchAttendance(1, _selectedDay!);

      Provider.of<StudentAttendanceStatusViewModel>(context, listen: false)
          .fetchRangeAttendance(
        1,
        DateTime(_focusedDay.year, _focusedDay.month, 1),
        DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
      );
    });
  }
  String getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AttendanceViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Attendance",
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
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${_focusedDay.month == 1 ? "January" :
                  _focusedDay.month == 2 ? "February" :
                  _focusedDay.month == 3 ? "March" :
                  _focusedDay.month == 4 ? "April" :
                  _focusedDay.month == 5 ? "May" :
                  _focusedDay.month == 6 ? "June" :
                  _focusedDay.month == 7 ? "July" :
                  _focusedDay.month == 8 ? "August" :
                  _focusedDay.month == 9 ? "September" :
                  _focusedDay.month == 10 ? "October" :
                  _focusedDay.month == 11 ? "November" :
                  "December"} ${_focusedDay.year}",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(width: 6),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _calendarFormat =
                      _calendarFormat == CalendarFormat.week
                          ? CalendarFormat.month
                          : CalendarFormat.week;
                    });
                  },
                  child: Icon(
                    _calendarFormat == CalendarFormat.week
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime.now(),
              focusedDay: _focusedDay,
              headerVisible: false,
              calendarFormat: _calendarFormat,

              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });

                Provider.of<StudentAttendanceStatusViewModel>(context, listen: false)
                    .fetchRangeAttendance(
                  1,
                  DateTime(focusedDay.year, focusedDay.month, 1),
                  DateTime(focusedDay.year, focusedDay.month + 1, 0),
                );
              },

              selectedDayPredicate: (day) =>
                  isSameDay(_selectedDay, day),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                vm.fetchAttendance(1, selectedDay);
              },

              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {

                  final rangeVm =
                  Provider.of<StudentAttendanceStatusViewModel>(context);

                  final status = rangeVm.getStatusForDate(day);

                  if (status == "A") {
                    return Positioned(
                      bottom: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }

                  if (status == "L") {
                    return Positioned(
                      bottom: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }

                  if (status == "P") {
                    return Positioned(
                      bottom: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),

              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_selectedDay != null)
              Text(
                "Selected Date : "
                    "${_selectedDay!.day}-${_selectedDay!.month}-${_selectedDay!.year}",
              ),

            const SizedBox(height: 20),

            if (vm.isLoading)
              const CircularProgressIndicator(),

            Consumer<StudentAttendanceStatusViewModel>(
              builder: (context, rangeVm, child) {

                if (_selectedDay == null) return const SizedBox();

                final status = rangeVm.getStatusForDate(_selectedDay!);

                String displayText = "";
                Color textColor = Colors.black;

                if (_selectedDay!.weekday == DateTime.sunday) {
                  displayText = "Holiday";
                  textColor = Colors.blue;
                }
                else if (status == "P") {
                  displayText = "Present";
                  textColor = Colors.green;
                }
                else if (status == "A") {
                  displayText = "Absent";
                  textColor = Colors.red;
                }
                else if (status == "L") {
                  displayText = "Leave";
                  textColor = Colors.orange;
                }
                else {
                  displayText = "No Record";
                  textColor = Colors.grey;
                }

                return Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      displayText,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
