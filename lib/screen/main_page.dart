// ignore: file_names
import 'package:attendance_rec/form/attendance.dart';
import 'package:attendance_rec/screen/attendance.dart';
import 'package:attendance_rec/screen/setting.dart';
import 'package:attendance_rec/screen/staff.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:iconsax/iconsax.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<NavigationPaneItem> items = [
    PaneItem(
      icon: const Icon(Iconsax.home),
      title: const Text('Home'),
      body: const Center(
        child: AttendanceAdd(),
      ),
    ),
    PaneItemSeparator(),
    PaneItem(
        title: const Text('Staff'),
        icon: const Icon(Iconsax.user),
        body: const StaffScreen()),
    PaneItem(
        title: const Text('Time and Attendance'),
        icon: const Icon(Iconsax.calendar),
        body: const AttendanceScreen()),
  ];

  int topIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: topIndex,
        onChanged: (index) => setState(() => topIndex = index),
        displayMode: PaneDisplayMode.compact,
        items: items,
        footerItems: [
          PaneItem(
            icon: const Icon(Iconsax.setting_4),
            title: const Text('Settings'),
            body: const SettingsScreen(),
          ),
        ],
      ),
    );
  }
}
