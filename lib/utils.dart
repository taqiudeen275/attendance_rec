import 'package:attendance_rec/model/model.dart';

List<Staff> findStaffContainingValue(String input, List<Staff> data) {
  List<Staff> resultStaff = [];
  for (var record in data) {
    record.first_name!.toLowerCase().contains(input.toLowerCase()) |
            record.last_name!.toLowerCase().contains(input.toLowerCase()) |
            record.email!.toLowerCase().contains(input.toLowerCase())
        ? resultStaff.add(record)
        : resultStaff;
  }
  return resultStaff;
}

List<Attendance> findAttendanceContainingValue(
    String input, List<Attendance> data) {
  List<Attendance> resultAttendance = [];
  for (var record in data) {
    record.attendance_status!.toLowerCase().contains(input.toLowerCase()) |
            record.notes!.toLowerCase().contains(input.toLowerCase())
        ? resultAttendance.add(record)
        : resultAttendance;
  }
  return resultAttendance;
}


List<Department> findDepartmentContainingValue(String input, List<Department> data) {
  List<Department> resultDepartment = [];
  for (var record in data) {
    record.name!.toLowerCase().contains(input.toLowerCase()) |
    record.description!.toLowerCase().contains(input.toLowerCase())
      ? resultDepartment.add(record)
      : resultDepartment;
  }
  return resultDepartment;
}

List<User> findUserContainingValue(String input, List<User> data) {
  List<User> resultUser = [];
  for (var record in data) {
    record.username!.toLowerCase().contains(input.toLowerCase())
      ? resultUser.add(record)
      : resultUser;
  }
  return resultUser;
}

String formatDateTime(DateTime dateTime, {bool dateOnly = false}) {
  String formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

  if (dateOnly) {
    return formattedDate;
  } else {
    String formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$formattedDate $formattedTime';
  }
}
