// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:fluent_ui/fluent_ui.dart' as Fluent;

class SqfEntityDBTableDataSource<T extends TableBase> extends DataTableSource {
  late final List<T> data;
  late final List<Map> dataRow;

  RxInt selectedRow = 0.obs;
  final BuildContext context;
  late RxList dataWithSelected = data
      .asMap()
      .entries
      .map((e) {
        return {"index": e.value.toArgsWithIds()[0], "selected": false};
      })
      .toList()
      .obs;

  void resetSelected() {
    selectedRow.value = 0;
    dataWithSelected.value = data.asMap().entries.map((e) {
      return {"index": e.value.toArgsWithIds()[0], "selected": false};
    }).toList();
  }

  SqfEntityDBTableDataSource({required this.context});
  Future<void> onEditPressed(index, context) async {}
  Future<void> onDeletePressed(index, context) async {}
  Future<void> onViewPressed(index, context) async {}
  @override
  DataRow? getRow(int index) {
    final item = dataRow[index];
    return DataRow.byIndex(
        onSelectChanged: (value) {
          onSelectAction(value, index, dataWithSelected[index]['index']);
        },
        index: index,
        selected: dataWithSelected[index]['selected'],
        cells: [
          for (var field in item.keys)
            DataCell(
              Text(item[field].toString()),
            ),
          DataCell(Row(
            children: [
              Fluent.IconButton(
                  onPressed: () async {
                    await onViewPressed(
                        dataWithSelected[index]['index'], context);
                  },
                  icon: const Icon(Fluent.FluentIcons.view)),
              const SizedBox(
                width: 10,
              ),
              Fluent.IconButton(
                  onPressed: () async {
                    await onEditPressed(
                        dataWithSelected[index]['index'], context);
                  },
                  icon: const Icon(Iconsax.edit)),
              const SizedBox(
                width: 10,
              ),
              Fluent.IconButton(
                  onPressed: () async {
                    await onDeletePressed(
                        dataWithSelected[index]['index'], context);
                  },
                  icon: const Icon(Icons.delete)),
              const SizedBox(
                width: 20,
              ),
            ],
          ))
        ]);
  }

  void onSelectAction(value, int index, int id) {
    dataWithSelected[index]['selected'] = value!;
    value == true ? selectedRow.value++ : selectedRow.value--;
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selectedRow.value;
}
