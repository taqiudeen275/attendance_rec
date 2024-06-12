// ignore_for_file: unused_import

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import '../tools/helper.dart';
import 'view.list.dart';

part 'model.g.dart';
// part 'model.g.view.dart'; // you do not need this part if you do not want to use the Form Generator property

const tableStaff = SqfEntityTable(
  tableName: 'staff',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('first_name', DbType.text),
    SqfEntityField('last_name', DbType.text),
    SqfEntityField('email', DbType.text),
    SqfEntityField('phone_number', DbType.text),
    SqfEntityField('staff_id', DbType.text),
    SqfEntityField('rank', DbType.text),
    SqfEntityFieldRelationship(
        parentTable: tableDepartment,
        relationType: RelationType.ONE_TO_MANY,
        deleteRule: DeleteRule.SET_NULL,
        defaultValue: 0),
    SqfEntityField('employment_status', DbType.text),
    SqfEntityField('join_date', DbType.datetime),
  ],
);

const tableAttendance = SqfEntityTable(
  tableName: 'attendance',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  fields: [
    SqfEntityFieldRelationship(
        parentTable: tableStaff,
        relationType: RelationType.ONE_TO_MANY,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
    SqfEntityField('date', DbType.datetime),
    SqfEntityField('check_in_time', DbType.datetime),
    SqfEntityField('check_out_time', DbType.datetime),
    SqfEntityField('attendance_status', DbType.text),
    SqfEntityField('notes', DbType.text),
  ],
);

const tableDepartment = SqfEntityTable(
  tableName: 'department',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  fields: [
    SqfEntityField(
      'name',
      DbType.text,
    ),
    SqfEntityField('description', DbType.text),
    SqfEntityField('head_of_department', DbType.text),
  ],
);

const tableStaffLessonNote = SqfEntityTable(
  tableName: 'staff_lesson_note',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  fields: [
    SqfEntityFieldRelationship(
        parentTable: tableStaff,
        relationType: RelationType.ONE_TO_MANY,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
    SqfEntityField('academic_year', DbType.text),
    SqfEntityField('term', DbType.text),
    SqfEntityField('week_1', DbType.bool),
    SqfEntityField('week_2', DbType.bool),
    SqfEntityField('week_3', DbType.bool),
    SqfEntityField('week_4', DbType.bool),
    SqfEntityField('week_5', DbType.bool),
    SqfEntityField('week_6', DbType.bool),
    SqfEntityField('week_7', DbType.bool),
    SqfEntityField('week_8', DbType.bool),
    SqfEntityField('week_9', DbType.bool),
    SqfEntityField('week_10', DbType.bool),
    SqfEntityField('week_11', DbType.bool),
    SqfEntityField('week_12', DbType.bool),
  ],
);

const tablePLC = SqfEntityTable(
  tableName: 'plc',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  fields: [
    SqfEntityFieldRelationship(
      parentTable: tableStaff,
      relationType: RelationType.ONE_TO_MANY,
      deleteRule: DeleteRule.CASCADE,
      defaultValue: 0,
    ),
    SqfEntityField('academic_year', DbType.text),
    SqfEntityField('term', DbType.text),
    SqfEntityField('week_1', DbType.bool),
    SqfEntityField('week_2', DbType.bool),
    SqfEntityField('week_3', DbType.bool),
    SqfEntityField('week_4', DbType.bool),
    SqfEntityField('week_5', DbType.bool),
    SqfEntityField('week_6', DbType.bool),
    SqfEntityField('week_7', DbType.bool),
    SqfEntityField('week_8', DbType.bool),
    SqfEntityField('week_9', DbType.bool),
    SqfEntityField('week_10', DbType.bool),
    SqfEntityField('week_11', DbType.bool),
    SqfEntityField('week_12', DbType.bool),
  ],
);
const tableUser = SqfEntityTable(
  tableName: 'user',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  fields: [
    SqfEntityFieldRelationship(
      parentTable: tableStaff,
      relationType: RelationType.ONE_TO_MANY,
      deleteRule: DeleteRule.SET_NULL,
      defaultValue: 0,
    ),
    SqfEntityField('username', DbType.text),
    SqfEntityField('password', DbType.text),
  ],
);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
  // maxValue:  10000, /* optional. default is max int (9.223.372.036.854.775.807) */
  // modelName: 'SQEidentity',
  /* optional. SqfEntity will set it to sequenceName automatically when the modelName is null*/
  // cycle : false,   /* optional. default is false; */
  // minValue = 0;    /* optional. default is 0 */
  // incrementBy = 1; /* optional. default is 1 */
  // startWith = 0;   /* optional. default is 0 */
);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  modelName: 'AttendanceDbModel', // optional
  databaseName: 'attendance.db',

  // put defined tables into the tables list.
  databaseTables: [
    tableStaff,
    tableAttendance,
    tableDepartment,
    tableStaffLessonNote,
    tablePLC,
    tableUser,
  ],

  // put defined sequences into the sequences list.
  sequences: [seqIdentity],
);
