import 'package:attendance_rec/base_controller.dart';
import 'package:attendance_rec/form/password_update.dart';
import 'package:attendance_rec/screen/attendance_grid.dart';
import 'package:attendance_rec/screen/modal.dart';
import 'package:attendance_rec/utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController _attendanceController =
      Get.put(AttendanceController());
  final StaffController staffController = Get.put(StaffController());

  RxBool isCredit = false.obs;
  DateTime? selectedDate;
  DateTime? selectedStaffDate;
  RxDouble revenue = 0.0.obs;
  UtilityController utilController = Get.put(UtilityController());

  @override
  void initState() {
    _attendanceController.fetchByDate(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (utilController.isAuthenticated.value) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          const Text("View Attendance By Date: "),
                          const SizedBox(width: 10),
                          DatePicker(
                            selected: selectedDate,
                            onChanged: (time) => setState(() {
                              selectedDate = time;
                              _attendanceController.fetchByDate(selectedDate!);
                            }),
                          ),
                          const SizedBox(width: 10),
                          FilledButton(
                              child: const Text("Today"),
                              onPressed: () {
                                setState(() {
                                  selectedDate = DateTime.now();
                                  _attendanceController
                                      .fetchByDate(selectedDate!);
                                });
                              }),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("View Attendance Staff: "),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 300,
                            child: AutoSuggestBox<String>(
                              items: staffController.models.map((staff) {
                                return AutoSuggestBoxItem<String>(
                                    value: staff.id!.toString(),
                                    label:
                                        "${staff.first_name!} ${staff.last_name!}",
                                    onFocusChange: (focused) {
                                      if (focused) {
                                        debugPrint('Focused $staff.first_name');
                                      }
                                    });
                              }).toList(),
                              onSelected: (selectedST) {
                                staffController.selectedStaff.value =
                                    staffController
                                        .getById(int.parse(selectedST.value!));

                                mediumActionModal(
                                    context,
                                    Text(
                                        "${staffController.selectedStaff.value.first_name} Attendance"),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 30, horizontal: 20),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.9,
                                            child: AttendanceCalendarGrid(
                                                attendanceList: staffController
                                                    .staffAttendacesByDate),
                                          ),
                                        )
                                      ],
                                    ),
                                    [
                                      FilledButton(
                                          child: const Text("Close"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          })
                                    ]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? "${formatDateTime(selectedDate!, dateOnly: true) == formatDateTime(DateTime.now(), dateOnly: true) ? 'TODAY\'S' : formatDateTime(selectedDate!, dateOnly: true)} ATTENDANCE"
                            : "TODAY'S ATTENDANCE",
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(),
                            1: FixedColumnWidth(210.0),
                            2: FixedColumnWidth(210.0),
                            3: FixedColumnWidth(180.0),
                          },
                          children: [
                            TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey[50]),
                                children: const [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Full Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Check In Time',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                            ..._attendanceController.attendacesByDate
                                .map((staff_att) => TableRow(children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              '${staff_att.plStaff?.first_name} ${staff_att.plStaff?.last_name}'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(formatDateTime(
                                              staff_att.check_in_time!)),
                                        ),
                                      ),
                                    ]))
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        );
      }else{
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "You are not authenticated. Please log in.",
              style: TextStyle(fontSize: 24),
            ),
            FilledButton(
                child: const Text("Login"),
                onPressed: () {
                  actionModal(
                      context, const Text("Login"), const PassWordChecker(), [
                    Button(
                        child: const Text("Close"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]);
                })
          ],
        );
      }
    });
  }
}

// class StaffAttendance extends StatefulWidget {
//   final List<Attendance> staffAttendance;
//   const StaffAttendance({super.key, required this.staffAttendance});

//   @override
//   State<StaffAttendance> createState() => _StaffAttendanceState();
// }

// class _StaffAttendanceState extends State<StaffAttendance> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Table(
//           columnWidths: const {
//             0: FlexColumnWidth(),
//             1: FixedColumnWidth(210.0),
//             2: FixedColumnWidth(210.0),
//             3: FixedColumnWidth(180.0),
//           },
//           children: [
//             TableRow(
//                 decoration: BoxDecoration(color: Colors.grey[50]),
//                 children: const [
//                   TableCell(
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         'Full Name',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   TableCell(
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         'Check In Time',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]),
//             ...widget.staffAttendance.map((staff_att) => TableRow(children: [
//                   TableCell(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                           '${staff_att.plStaff?.first_name} ${staff_att.plStaff?.last_name}'),
//                     ),
//                   ),
//                   TableCell(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(formatDateTime(staff_att.check_in_time!)),
//                     ),
//                   ),
//                 ]))
//           ],
//         )
//       ],
//     );
//   }
// }
