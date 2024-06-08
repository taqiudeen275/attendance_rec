import 'package:attendance_rec/base_controller.dart';
import 'package:attendance_rec/form/department.dart';
import 'package:attendance_rec/form/password_update.dart';
import 'package:attendance_rec/form/staff_form.dart';
import 'package:attendance_rec/model/model.dart';
import 'package:attendance_rec/screen/modal.dart';
import 'package:attendance_rec/staff_table.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  StaffController staffController = Get.put(StaffController());
  UtilityController utilController = Get.put(UtilityController());

  final TextEditingController _staffSearchController =
      TextEditingController();

  @override
  void initState() {
    _staffSearchController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    _staffSearchController.dispose();
    staffController.searchQuery.value = "";
    super.dispose();
  }

  Future<Staff?> getById(int id) async {
    return await Staff().getById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (utilController.isAuthenticated.value) {
        return SingleChildScrollView(
          child: Column(
            children: [
             
              Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextBox(
                        controller: _staffSearchController,
                        prefix: IconButton(
                          icon: const Icon(Iconsax.close_circle),
                          onPressed: () {
                            _staffSearchController.text = "";
                            staffController.searchQuery.value = "";
                          },
                        ),
                        placeholder: "Staff Search",
                        onChanged: (value) {
                          staffController.searchQuery.value = value;
                        },
                      ),
                     const SizedBox(height: 12,),
                      FilledButton(
                        child: const Text("Add Department"),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                const DepartmentAdd(),
                          );
                        })
                    ],
                  )),
              Obx(() {
                if (staffController.isLoading.value) {
                  return const ProgressRing();
                } else {
                  if (staffController.searchQuery.value.isEmpty) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.83,
                        child: const SingleChildScrollView(
                            child: StaffTableView()));
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.865,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Staff Search Results",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 24,
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Table(
                              columnWidths: const {
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
                                            'First Name',
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
                                            'Last Name',
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
                                            'Phone Number',
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
                                            'Email Address',
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
                                            'Department',
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
                                            'Action',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                ...staffController.onSearched().map((staff) =>
                                    TableRow(children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('${staff.first_name}'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('${staff.last_name}'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('${staff.phone_number}'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('${staff.email}'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('${staff.plDepartment?.name}'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: [
                                         
                                            IconButton(
                                                onPressed: () async {
                                                  actionModal(
                                                    context,
                                                    const Text("Update Staff"),
                                                    StaffAdd(
                                                        staff: (staff)),
                                                    [
                                                      Button(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text("No"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                icon: const Icon(Iconsax.edit)),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  actionModal(
                                                    context,
                                                    const Text("Delete Staff"),
                                                    Text(
                                                        "Are you sure you want to delete ${staff.first_name.toString()}"),
                                                    [
                                                      FilledButton(
                                                        onPressed: () async {
                                                          await staffController
                                                              .deleteModel(
                                                                  staff);
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
                                                },
                                                icon: const Icon(Iconsax.trash)),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]))
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              }),
            ],
          ),
        );
      } else {
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
