import 'package:attendance_rec/base_controller.dart';
import 'package:attendance_rec/form/password_update.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UtilityController utilityController = UtilityController();

  RxBool isDark = false.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(32.0),
            child: const PasswordUpdate()
            ),
      ],
    );
  }
}
