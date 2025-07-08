/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the attendanceTable type in your schema. */
class attendanceTable extends amplify_core.Model {
  static const classType = const _attendanceTableModelType();
  final String id;
  final UserTable? _user;
  final amplify_core.TemporalDate? _date;
  final double? _longitude;
  final double? _latitude;
  final int? _no_of_boys;
  final int? _no_of_girls;
  final int? _total;
  final int? _teachers;
  final String? _photo;
  final amplify_core.TemporalTime? _start_time;
  final amplify_core.TemporalTime? _end_time;
  final String? _class_attended;
  final String? _module_name;
  final int? _module_no;
  final String? _remarks;
  final amplify_core.TemporalTimestamp? _timestamp;
  final String? _topics_covered;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  attendanceTableModelIdentifier get modelIdentifier {
      return attendanceTableModelIdentifier(
        id: id
      );
  }
  
  UserTable? get user {
    return _user;
  }
  
  amplify_core.TemporalDate? get date {
    return _date;
  }
  
  double? get longitude {
    return _longitude;
  }
  
  double? get latitude {
    return _latitude;
  }
  
  int? get no_of_boys {
    return _no_of_boys;
  }
  
  int? get no_of_girls {
    return _no_of_girls;
  }
  
  int? get total {
    return _total;
  }
  
  int? get teachers {
    return _teachers;
  }
  
  String? get photo {
    return _photo;
  }
  
  amplify_core.TemporalTime? get start_time {
    return _start_time;
  }
  
  amplify_core.TemporalTime? get end_time {
    return _end_time;
  }
  
  String? get class_attended {
    return _class_attended;
  }
  
  String? get module_name {
    return _module_name;
  }
  
  int? get module_no {
    return _module_no;
  }
  
  String? get remarks {
    return _remarks;
  }
  
  amplify_core.TemporalTimestamp? get timestamp {
    return _timestamp;
  }
  
  String? get topics_covered {
    return _topics_covered;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const attendanceTable._internal({required this.id, user, date, longitude, latitude, no_of_boys, no_of_girls, total, teachers, photo, start_time, end_time, class_attended, module_name, module_no, remarks, timestamp, topics_covered, createdAt, updatedAt}): _user = user, _date = date, _longitude = longitude, _latitude = latitude, _no_of_boys = no_of_boys, _no_of_girls = no_of_girls, _total = total, _teachers = teachers, _photo = photo, _start_time = start_time, _end_time = end_time, _class_attended = class_attended, _module_name = module_name, _module_no = module_no, _remarks = remarks, _timestamp = timestamp, _topics_covered = topics_covered, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory attendanceTable({String? id, UserTable? user, amplify_core.TemporalDate? date, double? longitude, double? latitude, int? no_of_boys, int? no_of_girls, int? total, int? teachers, String? photo, amplify_core.TemporalTime? start_time, amplify_core.TemporalTime? end_time, String? class_attended, String? module_name, int? module_no, String? remarks, amplify_core.TemporalTimestamp? timestamp, String? topics_covered}) {
    return attendanceTable._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      user: user,
      date: date,
      longitude: longitude,
      latitude: latitude,
      no_of_boys: no_of_boys,
      no_of_girls: no_of_girls,
      total: total,
      teachers: teachers,
      photo: photo,
      start_time: start_time,
      end_time: end_time,
      class_attended: class_attended,
      module_name: module_name,
      module_no: module_no,
      remarks: remarks,
      timestamp: timestamp,
      topics_covered: topics_covered);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is attendanceTable &&
      id == other.id &&
      _user == other._user &&
      _date == other._date &&
      _longitude == other._longitude &&
      _latitude == other._latitude &&
      _no_of_boys == other._no_of_boys &&
      _no_of_girls == other._no_of_girls &&
      _total == other._total &&
      _teachers == other._teachers &&
      _photo == other._photo &&
      _start_time == other._start_time &&
      _end_time == other._end_time &&
      _class_attended == other._class_attended &&
      _module_name == other._module_name &&
      _module_no == other._module_no &&
      _remarks == other._remarks &&
      _timestamp == other._timestamp &&
      _topics_covered == other._topics_covered;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("attendanceTable {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("longitude=" + (_longitude != null ? _longitude!.toString() : "null") + ", ");
    buffer.write("latitude=" + (_latitude != null ? _latitude!.toString() : "null") + ", ");
    buffer.write("no_of_boys=" + (_no_of_boys != null ? _no_of_boys!.toString() : "null") + ", ");
    buffer.write("no_of_girls=" + (_no_of_girls != null ? _no_of_girls!.toString() : "null") + ", ");
    buffer.write("total=" + (_total != null ? _total!.toString() : "null") + ", ");
    buffer.write("teachers=" + (_teachers != null ? _teachers!.toString() : "null") + ", ");
    buffer.write("photo=" + "$_photo" + ", ");
    buffer.write("start_time=" + (_start_time != null ? _start_time!.format() : "null") + ", ");
    buffer.write("end_time=" + (_end_time != null ? _end_time!.format() : "null") + ", ");
    buffer.write("class_attended=" + "$_class_attended" + ", ");
    buffer.write("module_name=" + "$_module_name" + ", ");
    buffer.write("module_no=" + (_module_no != null ? _module_no!.toString() : "null") + ", ");
    buffer.write("remarks=" + "$_remarks" + ", ");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp!.toString() : "null") + ", ");
    buffer.write("topics_covered=" + "$_topics_covered" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  attendanceTable copyWith({UserTable? user, amplify_core.TemporalDate? date, double? longitude, double? latitude, int? no_of_boys, int? no_of_girls, int? total, int? teachers, String? photo, amplify_core.TemporalTime? start_time, amplify_core.TemporalTime? end_time, String? class_attended, String? module_name, int? module_no, String? remarks, amplify_core.TemporalTimestamp? timestamp, String? topics_covered}) {
    return attendanceTable._internal(
      id: id,
      user: user ?? this.user,
      date: date ?? this.date,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      no_of_boys: no_of_boys ?? this.no_of_boys,
      no_of_girls: no_of_girls ?? this.no_of_girls,
      total: total ?? this.total,
      teachers: teachers ?? this.teachers,
      photo: photo ?? this.photo,
      start_time: start_time ?? this.start_time,
      end_time: end_time ?? this.end_time,
      class_attended: class_attended ?? this.class_attended,
      module_name: module_name ?? this.module_name,
      module_no: module_no ?? this.module_no,
      remarks: remarks ?? this.remarks,
      timestamp: timestamp ?? this.timestamp,
      topics_covered: topics_covered ?? this.topics_covered);
  }
  
  attendanceTable copyWithModelFieldValues({
    ModelFieldValue<UserTable?>? user,
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<double?>? longitude,
    ModelFieldValue<double?>? latitude,
    ModelFieldValue<int?>? no_of_boys,
    ModelFieldValue<int?>? no_of_girls,
    ModelFieldValue<int?>? total,
    ModelFieldValue<int?>? teachers,
    ModelFieldValue<String?>? photo,
    ModelFieldValue<amplify_core.TemporalTime?>? start_time,
    ModelFieldValue<amplify_core.TemporalTime?>? end_time,
    ModelFieldValue<String?>? class_attended,
    ModelFieldValue<String?>? module_name,
    ModelFieldValue<int?>? module_no,
    ModelFieldValue<String?>? remarks,
    ModelFieldValue<amplify_core.TemporalTimestamp?>? timestamp,
    ModelFieldValue<String?>? topics_covered
  }) {
    return attendanceTable._internal(
      id: id,
      user: user == null ? this.user : user.value,
      date: date == null ? this.date : date.value,
      longitude: longitude == null ? this.longitude : longitude.value,
      latitude: latitude == null ? this.latitude : latitude.value,
      no_of_boys: no_of_boys == null ? this.no_of_boys : no_of_boys.value,
      no_of_girls: no_of_girls == null ? this.no_of_girls : no_of_girls.value,
      total: total == null ? this.total : total.value,
      teachers: teachers == null ? this.teachers : teachers.value,
      photo: photo == null ? this.photo : photo.value,
      start_time: start_time == null ? this.start_time : start_time.value,
      end_time: end_time == null ? this.end_time : end_time.value,
      class_attended: class_attended == null ? this.class_attended : class_attended.value,
      module_name: module_name == null ? this.module_name : module_name.value,
      module_no: module_no == null ? this.module_no : module_no.value,
      remarks: remarks == null ? this.remarks : remarks.value,
      timestamp: timestamp == null ? this.timestamp : timestamp.value,
      topics_covered: topics_covered == null ? this.topics_covered : topics_covered.value
    );
  }
  
  attendanceTable.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? UserTable.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : UserTable.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _longitude = (json['longitude'] as num?)?.toDouble(),
      _latitude = (json['latitude'] as num?)?.toDouble(),
      _no_of_boys = (json['no_of_boys'] as num?)?.toInt(),
      _no_of_girls = (json['no_of_girls'] as num?)?.toInt(),
      _total = (json['total'] as num?)?.toInt(),
      _teachers = (json['teachers'] as num?)?.toInt(),
      _photo = json['photo'],
      _start_time = json['start_time'] != null ? amplify_core.TemporalTime.fromString(json['start_time']) : null,
      _end_time = json['end_time'] != null ? amplify_core.TemporalTime.fromString(json['end_time']) : null,
      _class_attended = json['class_attended'],
      _module_name = json['module_name'],
      _module_no = (json['module_no'] as num?)?.toInt(),
      _remarks = json['remarks'],
      _timestamp = json['timestamp'] != null ? amplify_core.TemporalTimestamp.fromSeconds(json['timestamp']) : null,
      _topics_covered = json['topics_covered'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user': _user?.toJson(), 'date': _date?.format(), 'longitude': _longitude, 'latitude': _latitude, 'no_of_boys': _no_of_boys, 'no_of_girls': _no_of_girls, 'total': _total, 'teachers': _teachers, 'photo': _photo, 'start_time': _start_time?.format(), 'end_time': _end_time?.format(), 'class_attended': _class_attended, 'module_name': _module_name, 'module_no': _module_no, 'remarks': _remarks, 'timestamp': _timestamp?.toSeconds(), 'topics_covered': _topics_covered, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'user': _user,
    'date': _date,
    'longitude': _longitude,
    'latitude': _latitude,
    'no_of_boys': _no_of_boys,
    'no_of_girls': _no_of_girls,
    'total': _total,
    'teachers': _teachers,
    'photo': _photo,
    'start_time': _start_time,
    'end_time': _end_time,
    'class_attended': _class_attended,
    'module_name': _module_name,
    'module_no': _module_no,
    'remarks': _remarks,
    'timestamp': _timestamp,
    'topics_covered': _topics_covered,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<attendanceTableModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<attendanceTableModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserTable'));
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final LONGITUDE = amplify_core.QueryField(fieldName: "longitude");
  static final LATITUDE = amplify_core.QueryField(fieldName: "latitude");
  static final NO_OF_BOYS = amplify_core.QueryField(fieldName: "no_of_boys");
  static final NO_OF_GIRLS = amplify_core.QueryField(fieldName: "no_of_girls");
  static final TOTAL = amplify_core.QueryField(fieldName: "total");
  static final TEACHERS = amplify_core.QueryField(fieldName: "teachers");
  static final PHOTO = amplify_core.QueryField(fieldName: "photo");
  static final START_TIME = amplify_core.QueryField(fieldName: "start_time");
  static final END_TIME = amplify_core.QueryField(fieldName: "end_time");
  static final CLASS_ATTENDED = amplify_core.QueryField(fieldName: "class_attended");
  static final MODULE_NAME = amplify_core.QueryField(fieldName: "module_name");
  static final MODULE_NO = amplify_core.QueryField(fieldName: "module_no");
  static final REMARKS = amplify_core.QueryField(fieldName: "remarks");
  static final TIMESTAMP = amplify_core.QueryField(fieldName: "timestamp");
  static final TOPICS_COVERED = amplify_core.QueryField(fieldName: "topics_covered");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "attendanceTable";
    modelSchemaDefinition.pluralName = "attendanceTables";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        provider: amplify_core.AuthRuleProvider.IAM,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: attendanceTable.USER,
      isRequired: false,
      targetNames: ['user_id'],
      ofModelName: 'UserTable'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.LONGITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.LATITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.NO_OF_BOYS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.NO_OF_GIRLS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.TOTAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.TEACHERS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.PHOTO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.START_TIME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.time)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.END_TIME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.time)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.CLASS_ATTENDED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.MODULE_NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.MODULE_NO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.REMARKS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.TIMESTAMP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: attendanceTable.TOPICS_COVERED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _attendanceTableModelType extends amplify_core.ModelType<attendanceTable> {
  const _attendanceTableModelType();
  
  @override
  attendanceTable fromJson(Map<String, dynamic> jsonData) {
    return attendanceTable.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'attendanceTable';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [attendanceTable] in your schema.
 */
class attendanceTableModelIdentifier implements amplify_core.ModelIdentifier<attendanceTable> {
  final String id;

  /** Create an instance of attendanceTableModelIdentifier using [id] the primary key. */
  const attendanceTableModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'attendanceTableModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is attendanceTableModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}