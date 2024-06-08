import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';

import '../base_controller.dart';

class AttendanceCalendarGrid extends StatefulWidget {
  final List<StaffAttendance> attendanceList;

  const AttendanceCalendarGrid({
    Key? key,
    required this.attendanceList,
  }) : super(key: key);

  @override
  _AttendanceCalendarGridState createState() => _AttendanceCalendarGridState();
}

class _AttendanceCalendarGridState extends State<AttendanceCalendarGrid> {
  final StaffController staffController = Get.put(StaffController());

  @override
  void initState() {
    super.initState();
  }

  String _getPositionSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text("Select a year and month: "),
                const SizedBox(
                  width: 10,
                ),
                DatePicker(
                  selected: staffController.selectedDate.value,
                  onChanged: (time) => setState(() {
                    staffController.selectedDate.value = time;
                    staffController.fetchByDate();
                  }),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            Text(
              'Attendance Summary: ${staffController.attendedDays.value} days of ${staffController.totalDays.value} (${staffController.selectedDate.value.month}/${staffController.selectedDate.value.year})',
              style: FluentTheme.of(context).typography.subtitle,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 500,
              height: 400,
              // width: MediaQuery.of(context).size.width *0.8,
              // height: MediaQuery.of(context).size.height *0.8,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: staffController.totalDays.value,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  // final date = DateTime(staffController.selectedDate.value.year,
                  //     staffController.selectedDate.value.month, day);
                  final isAttended = widget.attendanceList.any((attendance) =>
                      attendance.check_in.day == day &&
                      attendance.check_in.month ==
                          staffController.selectedDate.value.month &&
                      attendance.check_in.year ==
                          staffController.selectedDate.value.year);

                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: isAttended
                          ? material.Colors.green.withOpacity(0.5)
                          : material.Colors.red.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: material.Colors.white,
                          ),
                        ),
                        Text(
                          _getPositionSuffix(day),
                          style: const TextStyle(
                            color: material.Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class StaffAttendance {
  final String staff_name;
  final DateTime check_in;

  StaffAttendance({required this.staff_name, required this.check_in});
}
