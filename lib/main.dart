import 'package:attendance_rec/screen/main_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_storage/get_storage.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  await GetStorage.init();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1200, 850),
    center: true,
    skipTaskbar: false,
    title: "Attendance E-book",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      title: "Attendace E-Boook",
      home: MainPage(),
    );
  }
}
