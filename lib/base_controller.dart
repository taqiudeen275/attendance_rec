import 'package:attendance_rec/model/model.dart';
import 'package:attendance_rec/screen/attendance_grid.dart';
import 'package:attendance_rec/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class BaseSqfEntityController<T extends TableBase> extends GetxController {
  RxList<T> models = <T>[].obs;
  RxString searchQuery = "".obs;
  RxList<T> selectedItems = <T>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchModels();
  }

  // Fetch models
  Future<void> fetchModels() async {
    // print('================================================================');
    // print(models.toList());
    // print(models.toList().length);
    // print('================================================================');
  }

  // Add model
  Future<void> addModel(T model) async {
    await model.save();
    fetchModels();
  }

  Future<int> addGetModel(T model) async {
    int saved = await model.save();
    fetchModels();
    return saved;
  }

  // Update model
  Future<void> updateModel(T model) async {
    await model.save();
    await fetchModels();
  }

  // Delete model
  Future<void> deleteModel(T model) async {
    await model.delete();
    await fetchModels();
  }

  // Delete bulk models
  Future<void> deleteBulkModels(List<T> modelsToDelete) async {
    for (final model in modelsToDelete) {
      await deleteModel(model);
    }
    await fetchModels();
  }
}

class StaffController extends BaseSqfEntityController<Staff> {
  RxBool isSelected = false.obs;
  RxList selectedID = [].obs;
  RxList<StaffAttendance> staffAttendacesByDate = <StaffAttendance>[].obs;
  RxInt selectedStaffID = 0.obs;
  Rx<Staff> selectedStaff = Staff().obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxInt totalDays = 0.obs;
  RxInt attendedDays = 0.obs;
  RxInt startingDayIndex = 0.obs;

  List<Staff> onSearched() {
    if (searchQuery.value.isNotEmpty) {
      return findStaffContainingValue(searchQuery.value, models);
    }
    return [];
  }

  void _calculateAttendance() {
    final startOfMonth =
        DateTime(selectedDate.value.year, selectedDate.value.month, 1);
    final endOfMonth =
        DateTime(selectedDate.value.year, selectedDate.value.month + 1, 0);
    totalDays.value = endOfMonth.day;
  startingDayIndex.value = startOfMonth.weekday - DateTime.monday;
    attendedDays.value = staffAttendacesByDate
        .where((attendance) =>
            attendance.check_in.isAfter(startOfMonth) &&
            attendance.check_in
                .isBefore(endOfMonth.add(const Duration(days: 1))))
        .length;
  }

  Future<void> fetchByDate() async {
    isLoading.value = true;
    var res = await Attendance().select().toList(preload: true);
    List<StaffAttendance> filtered = [];
    for (Attendance attendance in res) {
      if (isSameMonth(attendance.date!, selectedDate.value)) {
        if (attendance.plStaff?.id == selectedStaff.value.id) {
          filtered.add(StaffAttendance(
              check_in: attendance.check_in_time!,
              staff_name: attendance.plStaff!.first_name!));
        }
      }
      staffAttendacesByDate.value = filtered;
      _calculateAttendance();
    }
    isLoading.value = false;
  }

  @override
  Future<void> fetchModels() async {
    isLoading.value = true;
    models.value = await Staff().select().toList(preload: true);
    resetSelected();
    isLoading.value = false;
    fetchByDate();
    return super.fetchModels();
  }

  Staff getById(int id) {
    return models.singleWhere((element) => element.id == id);
  }

  Future<void> deleteById(int id) async {
    await Staff().select().id.equals(id).delete();
    await fetchModels();
  }

  void resetSelected() {
    isSelected.value = false;
    selectedID.value = [];
  }

  Future<void> deleteBulkByID(List modelsToDelete) async {
    for (final model in modelsToDelete) {
      await deleteById(model);
    }
    await fetchModels();
  }
}

class AttendanceController extends BaseSqfEntityController<Attendance> {
  RxBool isSelected = false.obs;
  RxList selectedID = [].obs;
  RxList<Attendance> attendacesByDate = <Attendance>[].obs;

  List<Attendance> onSearched() {
    if (searchQuery.value.isNotEmpty) {
      return findAttendanceContainingValue(searchQuery.value, models);
    }
    return [];
  }

  Future<void> fetchByDate(DateTime date) async {
    isLoading.value = true;
    var res = await Attendance().select().toList(preload: true);
    List<Attendance> filtered = [];
    for (Attendance attendance in res) {
      if (isSameDate(attendance.date!, date)) {
        filtered.add(attendance);
      }
      attendacesByDate.value = filtered;
    }
    isLoading.value = false;
  }

  @override
  Future<void> fetchModels() async {
    isLoading.value = true;
    models.value = await Attendance().select().toList(preload: true);
    resetSelected();
    isLoading.value = false;
    return super.fetchModels();
  }

  Future<void> deleteById(int id) async {
    await Attendance().select().id.equals(id).delete();
    await fetchModels();
  }

  void resetSelected() {
    isSelected.value = false;
    selectedID.value = [];
  }

  Future<void> deleteBulkByID(List modelsToDelete) async {
    for (final model in modelsToDelete) {
      await deleteById(model);
    }
    await fetchModels();
  }
}

class DepartmentController extends BaseSqfEntityController<Department> {
  RxBool isSelected = false.obs;
  RxList selectedID = [].obs;

  List<Department> onSearched() {
    if (searchQuery.value.isNotEmpty) {
      return findDepartmentContainingValue(searchQuery.value, models);
    }
    return [];
  }

  @override
  Future<void> fetchModels() async {
    isLoading.value = true;
    models.value = await Department().select().toList(preload: true);
    resetSelected();
    isLoading.value = false;
    return super.fetchModels();
  }

  Future<void> deleteById(int id) async {
    await Department().select().id.equals(id).delete();
    await fetchModels();
  }

  void resetSelected() {
    isSelected.value = false;
    selectedID.value = [];
  }

  Future<void> deleteBulkByID(List modelsToDelete) async {
    for (final model in modelsToDelete) {
      await deleteById(model);
    }
    await fetchModels();
  }
}

class UserController extends BaseSqfEntityController<User> {
  RxBool isSelected = false.obs;
  RxList selectedID = [].obs;

  List<User> onSearched() {
    if (searchQuery.value.isNotEmpty) {
      return findUserContainingValue(searchQuery.value, models);
    }
    return [];
  }

  @override
  Future<void> fetchModels() async {
    isLoading.value = true;
    models.value = await User().select().toList(preload: true);
    resetSelected();
    isLoading.value = false;
    return super.fetchModels();
  }

  Future<void> deleteById(int id) async {
    await User().select().id.equals(id).delete();
    await fetchModels();
  }

  void resetSelected() {
    isSelected.value = false;
    selectedID.value = [];
  }

  Future<void> deleteBulkByID(List modelsToDelete) async {
    for (final model in modelsToDelete) {
      await deleteById(model);
    }
    await fetchModels();
  }
}

class StaffLessionNoteController extends BaseSqfEntityController<Staff_lesson_note> {
  RxBool isSelected = false.obs;
  RxList selectedID = [].obs;

  // List<Staff_lesson_note> onSearched() {
  //   if (searchQuery.value.isNotEmpty) {
  //     return findUserContainingValue(searchQuery.value, models);
  //   }
  //   return [];
  // }

  @override
  Future<void> fetchModels() async {
    isLoading.value = true;
    models.value = await Staff_lesson_note().select().toList(preload: true);
    resetSelected();
    isLoading.value = false;
    return super.fetchModels();
  }

  Future<void> deleteById(int id) async {
    await Staff_lesson_note().select().id.equals(id).delete();
    await fetchModels();
  }

  void resetSelected() {
    isSelected.value = false;
    selectedID.value = [];
  }

  Future<void> deleteBulkByID(List modelsToDelete) async {
    for (final model in modelsToDelete) {
      await deleteById(model);
    }
    await fetchModels();
  }
}



class PLCController extends BaseSqfEntityController<Plc> {
  RxBool isSelected = false.obs;
  RxList selectedID = [].obs;

  // List<Staff_lesson_note> onSearched() {
  //   if (searchQuery.value.isNotEmpty) {
  //     return findUserContainingValue(searchQuery.value, models);
  //   }
  //   return [];
  // }

  @override
  Future<void> fetchModels() async {
    isLoading.value = true;
    models.value = await Plc().select().toList(preload: true);
    resetSelected();
    isLoading.value = false;
    return super.fetchModels();
  }

  Future<void> deleteById(int id) async {
    await Plc().select().id.equals(id).delete();
    await fetchModels();
  }

  void resetSelected() {
    isSelected.value = false;
    selectedID.value = [];
  }

  Future<void> deleteBulkByID(List modelsToDelete) async {
    for (final model in modelsToDelete) {
      await deleteById(model);
    }
    await fetchModels();
  }
}

class UtilityController extends GetxController {
  final box = GetStorage();
  RxBool isAuthenticated = false.obs;
  String get getAdminPass => box.read('adminpass') ?? "1234";
  String get addDefaultProduct => box.read('addDefaultProduct') ?? "yes";
  void setAdminPass(String val) => box.write('adminpass', val);
  void setaddDefaultProduct(String val) => box.write('addDefaultProduct', val);
  bool authenticate(String pass) {
    if (getAdminPass == pass) {
      isAuthenticated.value = true;
      return isAuthenticated.value;
    } else {
      return false;
    }
  }
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

bool isSameMonth(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month;
}
