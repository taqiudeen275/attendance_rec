
import 'package:fluent_ui/fluent_ui.dart';

Future<dynamic> actionModal(context, Widget title, Widget content, List<Widget>? action) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ContentDialog(

        title: title,
        content: content,
        actions: action,
      );
  });
}

Future<dynamic> bigActionModal(context, Widget title, Widget content, List<Widget>? action) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ContentDialog(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.8),
        title: title,
        content: content,
        actions: action,
      );
  });
}

Future<dynamic> mediumActionModal(context, Widget title, Widget content, List<Widget>? action) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ContentDialog(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.5),
        title: title,
        content: content,
        actions: action,
      );
  });
}

