  import 'package:attendance_rec/base_controller.dart';
import 'package:attendance_rec/form/staff_form.dart';
import 'package:attendance_rec/screen/modal.dart';
import 'package:attendance_rec/table.dart';
import 'package:attendance_rec/table_source.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material_ui;
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class StaffTableView extends StatefulWidget {
  const StaffTableView({super.key});

  @override
  State<StaffTableView> createState() => _StaffTableViewState();
}

class _StaffTableViewState extends State<StaffTableView> {
  StaffController staffController = Get.put(StaffController());

  RxInt sortColumnIndex = 0.obs;
  RxBool sortAscending = true.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (staffController.models.isNotEmpty) {
        return SqfEntityDBTable(
          addTitle: const Text('Add Staff'),
          addContent:
              const StaffAdd(),
          header: "Staffs",
          headerSize: 24,
          rowsPerPage: 10,
          columns: const [
            material_ui.DataColumn(
              label: Text("ID"),
              numeric: true,
              tooltip: "ID",
            ),
            material_ui.DataColumn(
              label: Text("First Name"),
              tooltip: "First Name",
              numeric: true,
            ),
            material_ui.DataColumn(
              label: Text("Last Name"),
              tooltip: "Last Name",
            ),
            material_ui.DataColumn(
              label: Text("Email"),
              numeric: true,
              tooltip: "Email",
            ),
            material_ui.DataColumn(
              label: Text("Phone Number"),
              numeric: true,
              tooltip: "Phone Number",
            ),
               material_ui.DataColumn(
              label: Text("Staff ID"),
              numeric: true,
              tooltip: "Staff ID",
            ),
            material_ui.DataColumn(
              label: Text("Department"),
              numeric: true,
              tooltip: "Department",
            ),
            material_ui.DataColumn(
              label: Text("Action"),
              numeric: true,
              tooltip: "Action",
            ),
          ],
          source: StaffDataData(context: context),
          extra_action: [
            Obx(() => staffController.isSelected.value
                ? Button(
                    child: const Row(
                      children: [
                        Icon(Iconsax.trash),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Selected'),
                      ],
                    ),
                    onPressed: () async {
                      actionModal(
                          context,
                          const Text("Delete Selected"),
                          Text(
                              "Are you sure you want to delete the ${staffController.selectedID.length} selected Staffs?"),
                          [
                            FilledButton(
                              child: const Text('Yes'),
                              onPressed: () async {
                                await staffController.deleteBulkByID(
                                    staffController.selectedID);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                            ),
                            Button(
                              child: const Text('No'),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                          ]);
                    })
                : const SizedBox()),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('No Staff available'),
            const SizedBox(
              height: 10,
            ),
            material_ui.FilledButton.tonal(
              child: const Text("Add Staff"),
              onPressed: () {
                actionModal(
                  context,
                  const Text('Add Staff'),
                  const StaffAdd(),
                  [
                    FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"))
                  ],
                ); // Replace with your product form widget
              },
            ),
          ],
        );
      }
    });
  }
}
