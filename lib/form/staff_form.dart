// ignore_for_file: use_build_context_synchronously

import 'package:attendance_rec/base_controller.dart';
import 'package:attendance_rec/model/model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

class StaffAdd extends StatefulWidget {
  final Staff? staff;
  const StaffAdd({super.key, this.staff});

  @override
  State<StatefulWidget> createState() => _StaffAddState();
}

class _StaffAddState extends State<StaffAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController __staffIdController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _departmentIdController = TextEditingController();
  final StaffController staffController = Get.put(StaffController());
  final DepartmentController departmentController =
      Get.put(DepartmentController());
  String selectedDepartment = "-- Choose Department";
  @override
  void initState() {
    _firstNameController.text = widget.staff?.first_name ?? '';
    _lastNameController.text = widget.staff?.last_name ?? '';
    _emailController.text = widget.staff?.email ?? '';
    __staffIdController.text = widget.staff?.staff_id ?? '';
    _departmentIdController.text = widget.staff?.departmentId.toString() ?? '0';
    _phoneNumberController.text = widget.staff?.phone_number ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _departmentIdController.dispose();
    _phoneNumberController.dispose();
    __staffIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First Name
            InfoLabel(
              label: "First Name",
              child: TextFormBox(
                controller: _firstNameController,
                placeholder: 'Enter Title & First name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // Last Name
            InfoLabel(
              label: "Last Name",
              child: TextFormBox(
                controller: _lastNameController,
                placeholder: 'Enter last name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // Email
            InfoLabel(
              label: "Email",
              child: TextFormBox(
                controller: _emailController,
                placeholder: 'Enter email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  // Add email validation if needed
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // Phone Number
            InfoLabel(
              label: "Phone Number",
              child: TextFormBox(
                controller: _phoneNumberController,
                placeholder: 'Enter phone number',
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(height: 16.0),
            InfoLabel(
              label: "Staff ID",
              child: TextFormBox(
                controller: __staffIdController,
                placeholder: 'Enter Staff ID',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the staff ID';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16.0),
            InfoLabel(
                label: "Department",
                child: Obx(
                  () => ComboBox<String>(
                    value: selectedDepartment,
                    items: departmentController.models.map((e) {
                      return ComboBoxItem(
                        value: e.id.toString(),
                        child: Text(e.name.toString()),
                      );
                    }).toList(),
                    onChanged: (department) {
                      _departmentIdController.text = department!;
                      setState(() => selectedDepartment = department);
                    },
                  ),
                )),
            const SizedBox(height: 16.0),
            // Submit Button
            FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitForm();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String staffID = __staffIdController.text;
    String phoneNumber = _phoneNumberController.text;
    int department = int.parse(_departmentIdController.text);
    // Check if update or create based on passed staff
    if (widget.staff != null) {
      Staff model = widget.staff!;
      model.first_name = firstName;
      model.last_name = lastName;
      model.email = email;
      model.staff_id = staffID;
      model.phone_number = phoneNumber;
      model.departmentId = department;
    await  staffController.updateModel(model);
    } else {
    await  staffController.addModel(
        Staff(
            first_name: firstName,
            last_name: lastName,
            email: email,
            staff_id: staffID,
            phone_number: phoneNumber,
            departmentId: department),
      );
    }

    // Clear form fields
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    __staffIdController.clear();
    _phoneNumberController.clear();
    Navigator.pop(context);
  }
}
