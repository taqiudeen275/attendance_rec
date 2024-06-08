// ignore_for_file: use_build_context_synchronously

import 'package:attendance_rec/model/model.dart';
import 'package:attendance_rec/screen/modal.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

import '../base_controller.dart';

class AttendanceAdd extends StatefulWidget {
  final Attendance? attendance;
  const AttendanceAdd({super.key, this.attendance});

  @override
  State<StatefulWidget> createState() => _AttendanceAddState();
}

class _AttendanceAddState extends State<AttendanceAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _staffController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final AttendanceController attendanceController =
      Get.put(AttendanceController());
  final StaffController staffController = Get.put(StaffController());
  late final Staff selectedStaff;

  @override
  void initState() {
    _staffController.text = widget.attendance?.date?.toString() ?? '';
    _staffIdController.text =
        widget.attendance?.check_in_time?.toString() ?? '';

    super.initState();
  }

  @override
  void dispose() {
    _staffController.dispose();
    _staffIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "ATTENDANCE EBOOK",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Enter your Name and staff id to record your attendance",
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16.0),
            InfoLabel(
                label: "Staff: ",
                child: Obx(
                  () => AutoSuggestBox<String>(
                    items: staffController.models.map((staff) {
                      return AutoSuggestBoxItem<String>(
                          value: staff.id!.toString(),
                          label: "${staff.first_name!} ${staff.last_name!}",
                          onFocusChange: (focused) {
                            if (focused) {
                              debugPrint('Focused $staff.first_name');
                            }
                          });
                    }).toList(),
                    onSelected: (item) {
                      selectedStaff =
                          staffController.getById(int.parse(item.value!));
                      setState(() => _staffController.text = item.value!);
                    },
                  ),
                )),
            const SizedBox(height: 16.0),
            // Check-In Time
            InfoLabel(
              label: "Staff ID",
              child: TextFormBox(
                controller: _staffIdController,
                placeholder: 'Enter a Staff ID',
                validator: (val) {
                  if (val != selectedStaff.staff_id!) {
                    return 'Invalid Staff ID';
                  }
                  if (val == null || val.isEmpty) {
                    return 'Please enter a Staff ID name';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 16.0),
            // Submit Button
            FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitForm();
                }
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
   await attendanceController.fetchByDate(DateTime.now());

    if (attendanceController.attendacesByDate
        .any((att) => att.staffId == selectedStaff.id)) {
      actionModal(context, const Text("Recorded Already"),
          const Text("Attendance Recorded Already"), [
        FilledButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            })
      ]);
    } else {
      attendanceController.addModel(
        Attendance(
          staffId: selectedStaff.id,
          date: DateTime.now(),
          check_in_time: DateTime.now(),
        ),
      );
      actionModal(context, const Text("Successfully"),
          const Text("Attendance Recorded Successfully"), [
        FilledButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            })
      ]);
    }

    // Clear form fields
    _staffController.clear();
    _staffIdController.clear();
  }
}
