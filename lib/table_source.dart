import 'package:attendance_rec/base_controller.dart';
import 'package:attendance_rec/base_table.dart';
import 'package:attendance_rec/form/staff_form.dart';
import 'package:attendance_rec/model/model.dart';
import 'package:attendance_rec/screen/modal.dart';
import 'package:get/get.dart';

import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:fluent_ui/fluent_ui.dart';

class StaffDataData extends SqfEntityDBTableDataSource {
  StaffController staffController = Get.put(StaffController());

  StaffDataData({required super.context});

  @override
  void onSelectAction(value, int index, int id) {
    super.onSelectAction(value, index, id);
    value
        ? staffController.selectedID.add(id)
        : staffController.selectedID.remove(id);
    selectedRow.value > 0
        ? staffController.isSelected.value = true
        : staffController.isSelected.value = false;
  }

  @override
  List<TableBase> get data => staffController.models;

  @override
  List<Map> get dataRow => staffController.models
      .map((staff) => {
            'id': staff.id,
            'firstName': staff.first_name,
            'lastName': staff.last_name,
            'email': staff.email,
            'phoneNumber': staff.phone_number,
            'staffID': staff.staff_id,
            'department': staff.plDepartment?.name,
          })
      .toList();

  Future<Staff?> getById(int id) async {
    return await Staff().getById(id);
  }

  @override
  Future<void> onDeletePressed(index, context) async {
    Staff? itemToDelete = await getById(index);
    actionModal(
      context,
      const Text("Delete Staff"),
      Text("Are you sure you want to delete ${itemToDelete!.first_name}"),
      [
        FilledButton(
          onPressed: () async {
            await staffController.deleteModel(itemToDelete);
            Navigator.pop(context);
          },
          child: const Text("Yes"),
        ),
        Button(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No"),
        ),
      ],
    );
    super.onDeletePressed(index, context);
  }

  @override
  Future<void> onEditPressed(index, context) async {
    actionModal(
      context,
      const Text("Update Staff"),
      StaffAdd(staff: await getById(index)),
      [
        Button(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        )
      ],
    );
    super.onEditPressed(index, context);
  }

  @override
  Future<void> onViewPressed(index, context) async {
    Staff? staff = await getById(index);
    // Add any additional data or components to display staff details
    bigActionModal(
      context,
      const Text("Staff Details"),
      Text("Staff Name: ${staff!.first_name}"),
      [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        )
      ],
    );
    super.onEditPressed(index, context);
  }
}