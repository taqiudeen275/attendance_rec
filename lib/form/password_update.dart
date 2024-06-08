// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:attendance_rec/base_controller.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

class PasswordUpdate extends StatefulWidget {
  const PasswordUpdate({super.key});

  @override
  _PasswordUpdateState createState() => _PasswordUpdateState();
}

class _PasswordUpdateState extends State<PasswordUpdate> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  UtilityController utilityController = UtilityController();

  final _formKey = GlobalKey<FormState>();

  void _updatePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform password update logic here
      final currentPassword = _currentPasswordController.text;
      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Example: You might want to call an API to update the password
      if (currentPassword == utilityController.getAdminPass) {
        if (newPassword == confirmPassword) {
          utilityController.setAdminPass(newPassword);
          showDialog(
            context: context,
            builder: (context) {
              return ContentDialog(
                title: const Text('Success'),
                content: const Text('Password updated successfully.'),
                actions: [
                  Button(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
           showDialog(
            context: context,
            builder: (context) {
              return ContentDialog(
                title: const Text('Password do not match'),
                content: const Text('Password update not successfully.'),
                actions: [
                  Button(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }else{
            showDialog(
            context: context,
            builder: (context) {
              return ContentDialog(
                title: const Text('Wrong password'),
                content: const Text('You have entered a wrong Passwod'),
                actions: [
                  Button(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
      }

      // Clear the text fields after successful update
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Update Admin Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormBox(
                    controller: _currentPasswordController,
                    obscureText: true,
                    placeholder: 'Enter your current password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormBox(
                    controller: _newPasswordController,
                    obscureText: true,
                    placeholder: 'Enter your new password',
                  ),
                  const SizedBox(height: 16.0),
                  TextFormBox(
                    placeholder: 'Confirm New Password',
                    controller: _confirmPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  FilledButton(
                    onPressed: _updatePassword,
                    child: const Text('Update Password'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class PassWordChecker extends StatefulWidget {
  const PassWordChecker({super.key});

  @override
  State<PassWordChecker> createState() => _PassWordCheckerState();
}

class _PassWordCheckerState extends State<PassWordChecker> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  UtilityController utilityController = Get.put(UtilityController());

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormBox(
            obscureText: true,
            placeholder: 'Enter your Admin Password to access this page',
            controller: _nameController,
            autofocus: true,
            
          ),
          const SizedBox(height: 8.0),
          const SizedBox(height: 16.0),
          // Submit Button
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                bool isTrue =
                    utilityController.authenticate(_nameController.text);
                      Navigator.pop(context);
                    
                if (!isTrue) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ContentDialog(
                        title: const Text('Wrong Password'),
                        content:
                            const Text('Please enter a correct Password.'),
                        actions: [
                          Button(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            child: const Text('Login'),
          )
        ],
      ),
    );
  }
}
