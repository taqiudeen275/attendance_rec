import 'package:attendance_rec/base_controller.dart';
import 'package:attendance_rec/model/model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

class DepartmentAdd extends StatefulWidget {
  const DepartmentAdd({super.key});

  @override
  State<DepartmentAdd> createState() => _DepartmentAddState();
}

class _DepartmentAddState extends State<DepartmentAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hODController = TextEditingController();
  final DepartmentController departmentController =
      Get.put(DepartmentController());

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _hODController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Add Department'),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InfoLabel(
                  label: "Name",
                  child: TextFormBox(
                    controller: _nameController,
                    placeholder: 'Enter department name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name of department';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                InfoLabel(
                  label: "Head Of Department",
                  child: TextFormBox(
                    controller: _hODController,
                    placeholder: 'HOD',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the HOD name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            )),
      ),
      actions: [
        Button(
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Future<void> _submitForm() async {
    String name = _nameController.text;
    String hod = _hODController.text;

    // Check if update or create based on passed staff

    departmentController
        .addModel(Department(name: name, head_of_department: hod));

    // Clear form fields
    _nameController.clear();
    _hODController.clear();

    Navigator.pop(context);
  }
}
