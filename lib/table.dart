import 'package:attendance_rec/screen/modal.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;


class SqfEntityDBTable extends StatefulWidget {
  const SqfEntityDBTable(
      {super.key,
      required this.columns,
      required this.source,
      required this.rowsPerPage,
      this.onAddBtn,
      required this.header,
      this.headerSize = 26,
      required this.addTitle,
      required this.addContent,
      // ignore: non_constant_identifier_names
      this.extra_action});

  final List<DataColumn> columns;
  final DataTableSource source;
  final int rowsPerPage;
  final Function()? onAddBtn;
  final String header;
  final Widget addTitle;
  final double headerSize;
  final Widget addContent;
  // ignore: non_constant_identifier_names
  final List<Widget>? extra_action;
  @override
  State<SqfEntityDBTable> createState() => _SqfEntityDBTableState();
}

class _SqfEntityDBTableState extends State<SqfEntityDBTable> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: PaginatedDataTable(
            header: Text(widget.header),
            actions: widget.extra_action! +
                [
                  IconButton(
                      onPressed: () {
                        actionModal(
                          context,
                          widget.addTitle,
                          widget.addContent,
                          [
                            fluent_ui.Button(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close"))
                          ],
                        );
                      },
                      icon: const Icon(Icons.add)),
                ],
            rowsPerPage: widget.rowsPerPage,
            showCheckboxColumn: true,
            columns: widget.columns,
            source: widget.source),
      )
    ]);
  }
}
