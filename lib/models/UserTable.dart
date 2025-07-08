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
import 'package:collection/collection.dart';


/** This is an auto generated class representing the UserTable type in your schema. */
class UserTable extends amplify_core.Model {
  static const classType = const _UserTableModelType();
  final String id;
  final String? _name;
  final String? _reg_no;
  final String? _email;
  final String? _phone;
  final String? _device_id;
  final String? _university;
  final String? _district;
  final String? _mandal;
  final String? _college;
  final bool? _isPolicy;
  final UserTableGender? _gender;
  final String? _branch;
  final List<attendanceTable>? _attendance;
  final List<SuggestionsTable>? _suggestion;
  final TeamTable? _team;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserTableModelIdentifier get modelIdentifier {
      return UserTableModelIdentifier(
        id: id
      );
  }
  
  String? get name {
    return _name;
  }
  
  String? get reg_no {
    return _reg_no;
  }
  
  String? get email {
    return _email;
  }
  
  String? get phone {
    return _phone;
  }
  
  String? get device_id {
    return _device_id;
  }
  
  String? get university {
    return _university;
  }
  
  String? get district {
    return _district;
  }
  
  String? get mandal {
    return _mandal;
  }
  
  String? get college {
    return _college;
  }
  
  bool? get isPolicy {
    return _isPolicy;
  }
  
  UserTableGender? get gender {
    return _gender;
  }
  
  String? get branch {
    return _branch;
  }
  
  List<attendanceTable>? get attendance {
    return _attendance;
  }
  
  List<SuggestionsTable>? get suggestion {
    return _suggestion;
  }
  
  TeamTable? get team {
    return _team;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UserTable._internal({required this.id, name, reg_no, email, phone, device_id, university, district, mandal, college, isPolicy, gender, branch, attendance, suggestion, team, createdAt, updatedAt}): _name = name, _reg_no = reg_no, _email = email, _phone = phone, _device_id = device_id, _university = university, _district = district, _mandal = mandal, _college = college, _isPolicy = isPolicy, _gender = gender, _branch = branch, _attendance = attendance, _suggestion = suggestion, _team = team, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UserTable({String? id, String? name, String? reg_no, String? email, String? phone, String? device_id, String? university, String? district, String? mandal, String? college, bool? isPolicy, UserTableGender? gender, String? branch, List<attendanceTable>? attendance, List<SuggestionsTable>? suggestion, TeamTable? team}) {
    return UserTable._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      reg_no: reg_no,
      email: email,
      phone: phone,
      device_id: device_id,
      university: university,
      district: district,
      mandal: mandal,
      college: college,
      isPolicy: isPolicy,
      gender: gender,
      branch: branch,
      attendance: attendance != null ? List<attendanceTable>.unmodifiable(attendance) : attendance,
      suggestion: suggestion != null ? List<SuggestionsTable>.unmodifiable(suggestion) : suggestion,
      team: team);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserTable &&
      id == other.id &&
      _name == other._name &&
      _reg_no == other._reg_no &&
      _email == other._email &&
      _phone == other._phone &&
      _device_id == other._device_id &&
      _university == other._university &&
      _district == other._district &&
      _mandal == other._mandal &&
      _college == other._college &&
      _isPolicy == other._isPolicy &&
      _gender == other._gender &&
      _branch == other._branch &&
      DeepCollectionEquality().equals(_attendance, other._attendance) &&
      DeepCollectionEquality().equals(_suggestion, other._suggestion) &&
      _team == other._team;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserTable {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("reg_no=" + "$_reg_no" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("phone=" + "$_phone" + ", ");
    buffer.write("device_id=" + "$_device_id" + ", ");
    buffer.write("university=" + "$_university" + ", ");
    buffer.write("district=" + "$_district" + ", ");
    buffer.write("mandal=" + "$_mandal" + ", ");
    buffer.write("college=" + "$_college" + ", ");
    buffer.write("isPolicy=" + (_isPolicy != null ? _isPolicy!.toString() : "null") + ", ");
    buffer.write("gender=" + (_gender != null ? amplify_core.enumToString(_gender)! : "null") + ", ");
    buffer.write("branch=" + "$_branch" + ", ");
    buffer.write("team=" + (_team != null ? _team!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserTable copyWith({String? name, String? reg_no, String? email, String? phone, String? device_id, String? university, String? district, String? mandal, String? college, bool? isPolicy, UserTableGender? gender, String? branch, List<attendanceTable>? attendance, List<SuggestionsTable>? suggestion, TeamTable? team}) {
    return UserTable._internal(
      id: id,
      name: name ?? this.name,
      reg_no: reg_no ?? this.reg_no,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      device_id: device_id ?? this.device_id,
      university: university ?? this.university,
      district: district ?? this.district,
      mandal: mandal ?? this.mandal,
      college: college ?? this.college,
      isPolicy: isPolicy ?? this.isPolicy,
      gender: gender ?? this.gender,
      branch: branch ?? this.branch,
      attendance: attendance ?? this.attendance,
      suggestion: suggestion ?? this.suggestion,
      team: team ?? this.team);
  }
  
  UserTable copyWithModelFieldValues({
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? reg_no,
    ModelFieldValue<String?>? email,
    ModelFieldValue<String?>? phone,
    ModelFieldValue<String?>? device_id,
    ModelFieldValue<String?>? university,
    ModelFieldValue<String?>? district,
    ModelFieldValue<String?>? mandal,
    ModelFieldValue<String?>? college,
    ModelFieldValue<bool?>? isPolicy,
    ModelFieldValue<UserTableGender?>? gender,
    ModelFieldValue<String?>? branch,
    ModelFieldValue<List<attendanceTable>?>? attendance,
    ModelFieldValue<List<SuggestionsTable>?>? suggestion,
    ModelFieldValue<TeamTable?>? team
  }) {
    return UserTable._internal(
      id: id,
      name: name == null ? this.name : name.value,
      reg_no: reg_no == null ? this.reg_no : reg_no.value,
      email: email == null ? this.email : email.value,
      phone: phone == null ? this.phone : phone.value,
      device_id: device_id == null ? this.device_id : device_id.value,
      university: university == null ? this.university : university.value,
      district: district == null ? this.district : district.value,
      mandal: mandal == null ? this.mandal : mandal.value,
      college: college == null ? this.college : college.value,
      isPolicy: isPolicy == null ? this.isPolicy : isPolicy.value,
      gender: gender == null ? this.gender : gender.value,
      branch: branch == null ? this.branch : branch.value,
      attendance: attendance == null ? this.attendance : attendance.value,
      suggestion: suggestion == null ? this.suggestion : suggestion.value,
      team: team == null ? this.team : team.value
    );
  }
  
  UserTable.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _reg_no = json['reg_no'],
      _email = json['email'],
      _phone = json['phone'],
      _device_id = json['device_id'],
      _university = json['university'],
      _district = json['district'],
      _mandal = json['mandal'],
      _college = json['college'],
      _isPolicy = json['isPolicy'],
      _gender = amplify_core.enumFromString<UserTableGender>(json['gender'], UserTableGender.values),
      _branch = json['branch'],
      _attendance = json['attendance']  is Map
        ? (json['attendance']['items'] is List
          ? (json['attendance']['items'] as List)
              .where((e) => e != null)
              .map((e) => attendanceTable.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['attendance'] is List
          ? (json['attendance'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => attendanceTable.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _suggestion = json['suggestion']  is Map
        ? (json['suggestion']['items'] is List
          ? (json['suggestion']['items'] as List)
              .where((e) => e != null)
              .map((e) => SuggestionsTable.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['suggestion'] is List
          ? (json['suggestion'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => SuggestionsTable.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _team = json['team'] != null
        ? json['team']['serializedData'] != null
          ? TeamTable.fromJson(new Map<String, dynamic>.from(json['team']['serializedData']))
          : TeamTable.fromJson(new Map<String, dynamic>.from(json['team']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'reg_no': _reg_no, 'email': _email, 'phone': _phone, 'device_id': _device_id, 'university': _university, 'district': _district, 'mandal': _mandal, 'college': _college, 'isPolicy': _isPolicy, 'gender': amplify_core.enumToString(_gender), 'branch': _branch, 'attendance': _attendance?.map((attendanceTable? e) => e?.toJson()).toList(), 'suggestion': _suggestion?.map((SuggestionsTable? e) => e?.toJson()).toList(), 'team': _team?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'reg_no': _reg_no,
    'email': _email,
    'phone': _phone,
    'device_id': _device_id,
    'university': _university,
    'district': _district,
    'mandal': _mandal,
    'college': _college,
    'isPolicy': _isPolicy,
    'gender': _gender,
    'branch': _branch,
    'attendance': _attendance,
    'suggestion': _suggestion,
    'team': _team,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserTableModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserTableModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final REG_NO = amplify_core.QueryField(fieldName: "reg_no");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final PHONE = amplify_core.QueryField(fieldName: "phone");
  static final DEVICE_ID = amplify_core.QueryField(fieldName: "device_id");
  static final UNIVERSITY = amplify_core.QueryField(fieldName: "university");
  static final DISTRICT = amplify_core.QueryField(fieldName: "district");
  static final MANDAL = amplify_core.QueryField(fieldName: "mandal");
  static final COLLEGE = amplify_core.QueryField(fieldName: "college");
  static final ISPOLICY = amplify_core.QueryField(fieldName: "isPolicy");
  static final GENDER = amplify_core.QueryField(fieldName: "gender");
  static final BRANCH = amplify_core.QueryField(fieldName: "branch");
  static final ATTENDANCE = amplify_core.QueryField(
    fieldName: "attendance",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'attendanceTable'));
  static final SUGGESTION = amplify_core.QueryField(
    fieldName: "suggestion",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SuggestionsTable'));
  static final TEAM = amplify_core.QueryField(
    fieldName: "team",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'TeamTable'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserTable";
    modelSchemaDefinition.pluralName = "UserTables";
    
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
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.REG_NO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.EMAIL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.PHONE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.DEVICE_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.UNIVERSITY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.DISTRICT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.MANDAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.COLLEGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.ISPOLICY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.GENDER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTable.BRANCH,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: UserTable.ATTENDANCE,
      isRequired: false,
      ofModelName: 'attendanceTable',
      associatedKey: attendanceTable.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: UserTable.SUGGESTION,
      isRequired: false,
      ofModelName: 'SuggestionsTable',
      associatedKey: SuggestionsTable.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: UserTable.TEAM,
      isRequired: false,
      targetNames: ['team_code'],
      ofModelName: 'TeamTable'
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

class _UserTableModelType extends amplify_core.ModelType<UserTable> {
  const _UserTableModelType();
  
  @override
  UserTable fromJson(Map<String, dynamic> jsonData) {
    return UserTable.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserTable';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserTable] in your schema.
 */
class UserTableModelIdentifier implements amplify_core.ModelIdentifier<UserTable> {
  final String id;

  /** Create an instance of UserTableModelIdentifier using [id] the primary key. */
  const UserTableModelIdentifier({
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
  String toString() => 'UserTableModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserTableModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}