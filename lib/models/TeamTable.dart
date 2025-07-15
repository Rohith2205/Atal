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


/** This is an auto generated class representing the TeamTable type in your schema. */
class TeamTable extends amplify_core.Model {
  static const classType = const _TeamTableModelType();
  final String id;
  final String? _team_code;
  final List<String>? _team_members;
  final String? _school_name;
  final String? _district;
  final String? _mandal;
  final int? _schoolUID;
  final String? _modules;
  final List<UserTable>? _user;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  TeamTableModelIdentifier get modelIdentifier {
    return TeamTableModelIdentifier(
        id: id
    );
  }

  String? get team_code {
    return _team_code;
  }

  List<String>? get team_members {
    return _team_members;
  }

  String? get school_name {
    return _school_name;
  }

  String? get district {
    return _district;
  }

  String? get mandal {
    return _mandal;
  }

  int? get schoolUID {
    return _schoolUID;
  }

  String? get modules {
    return _modules;
  }

  List<UserTable>? get user {
    return _user;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const TeamTable._internal({required this.id, team_code, team_members, school_name, district, mandal, schoolUID, modules, user, createdAt, updatedAt}): _team_code = team_code, _team_members = team_members, _school_name = school_name, _district = district, _mandal = mandal, _schoolUID = schoolUID, _modules = modules, _user = user, _createdAt = createdAt, _updatedAt = updatedAt;

  factory TeamTable({String? id, String? team_code, List<String>? team_members, String? school_name, String? district, String? mandal, int? schoolUID, String? modules, List<UserTable>? user}) {
    return TeamTable._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        team_code: team_code,
        team_members: team_members != null ? List<String>.unmodifiable(team_members) : team_members,
        school_name: school_name,
        district: district,
        mandal: mandal,
        schoolUID: schoolUID,
        modules: modules,
        user: user != null ? List<UserTable>.unmodifiable(user) : user);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamTable &&
        id == other.id &&
        _team_code == other._team_code &&
        DeepCollectionEquality().equals(_team_members, other._team_members) &&
        _school_name == other._school_name &&
        _district == other._district &&
        _mandal == other._mandal &&
        _schoolUID == other._schoolUID &&
        _modules == other._modules &&
        DeepCollectionEquality().equals(_user, other._user);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("TeamTable {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("team_code=" + "$_team_code" + ", ");
    buffer.write("team_members=" + (_team_members != null ? _team_members!.toString() : "null") + ", ");
    buffer.write("school_name=" + "$_school_name" + ", ");
    buffer.write("district=" + "$_district" + ", ");
    buffer.write("mandal=" + "$_mandal" + ", ");
    buffer.write("schoolUID=" + (_schoolUID != null ? _schoolUID!.toString() : "null") + ", ");
    buffer.write("modules=" + "$_modules" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  TeamTable copyWith({String? team_code, List<String>? team_members, String? school_name, String? district, String? mandal, int? schoolUID, String? modules, List<UserTable>? user}) {
    return TeamTable._internal(
        id: id,
        team_code: team_code ?? this.team_code,
        team_members: team_members ?? this.team_members,
        school_name: school_name ?? this.school_name,
        district: district ?? this.district,
        mandal: mandal ?? this.mandal,
        schoolUID: schoolUID ?? this.schoolUID,
        modules: modules ?? this.modules,
        user: user ?? this.user);
  }

  TeamTable copyWithModelFieldValues({
    ModelFieldValue<String?>? team_code,
    ModelFieldValue<List<String>?>? team_members,
    ModelFieldValue<String?>? school_name,
    ModelFieldValue<String?>? district,
    ModelFieldValue<String?>? mandal,
    ModelFieldValue<int?>? schoolUID,
    ModelFieldValue<String?>? modules,
    ModelFieldValue<List<UserTable>?>? user
  }) {
    return TeamTable._internal(
        id: id,
        team_code: team_code == null ? this.team_code : team_code.value,
        team_members: team_members == null ? this.team_members : team_members.value,
        school_name: school_name == null ? this.school_name : school_name.value,
        district: district == null ? this.district : district.value,
        mandal: mandal == null ? this.mandal : mandal.value,
        schoolUID: schoolUID == null ? this.schoolUID : schoolUID.value,
        modules: modules == null ? this.modules : modules.value,
        user: user == null ? this.user : user.value
    );
  }

  TeamTable.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _team_code = json['team_code'],
        _team_members = json['team_members']?.cast<String>(),
        _school_name = json['school_name'],
        _district = json['district'],
        _mandal = json['mandal'],
        _schoolUID = (json['schoolUID'] as num?)?.toInt(),
        _modules = json['modules'],
        _user = json['user']  is Map
            ? (json['user']['items'] is List
            ? (json['user']['items'] as List)
            .where((e) => e != null)
            .map((e) => UserTable.fromJson(new Map<String, dynamic>.from(e)))
            .toList()
            : null)
            : (json['user'] is List
            ? (json['user'] as List)
            .where((e) => e?['serializedData'] != null)
            .map((e) => UserTable.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
            .toList()
            : null),
        _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
        _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;

  Map<String, dynamic> toJson() => {
    'id': id, 'team_code': _team_code, 'team_members': _team_members, 'school_name': _school_name, 'district': _district, 'mandal': _mandal, 'schoolUID': _schoolUID, 'modules': _modules, 'user': _user?.map((UserTable? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  Map<String, Object?> toMap() => {
    'id': id,
    'team_code': _team_code,
    'team_members': _team_members,
    'school_name': _school_name,
    'district': _district,
    'mandal': _mandal,
    'schoolUID': _schoolUID,
    'modules': _modules,
    'user': _user,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TeamTableModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TeamTableModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TEAM_CODE = amplify_core.QueryField(fieldName: "team_code");
  static final TEAM_MEMBERS = amplify_core.QueryField(fieldName: "team_members");
  static final SCHOOL_NAME = amplify_core.QueryField(fieldName: "school_name");
  static final DISTRICT = amplify_core.QueryField(fieldName: "district");
  static final MANDAL = amplify_core.QueryField(fieldName: "mandal");
  static final SCHOOLUID = amplify_core.QueryField(fieldName: "schoolUID");
  static final MODULES = amplify_core.QueryField(fieldName: "modules");
  static final USER = amplify_core.QueryField(
      fieldName: "user",
      fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserTable'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TeamTable";
    modelSchemaDefinition.pluralName = "TeamTables";

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

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TeamTable.TEAM_CODE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TeamTable.TEAM_MEMBERS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TeamTable.SCHOOL_NAME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TeamTable.DISTRICT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TeamTable.MANDAL,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TeamTable.SCHOOLUID,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TeamTable.MODULES,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
        key: TeamTable.USER,
        isRequired: false,
        ofModelName: 'UserTable',
        associatedKey: UserTable.TEAM
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

class _TeamTableModelType extends amplify_core.ModelType<TeamTable> {
  const _TeamTableModelType();

  @override
  TeamTable fromJson(Map<String, dynamic> jsonData) {
    return TeamTable.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'TeamTable';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [TeamTable] in your schema.
 */
class TeamTableModelIdentifier implements amplify_core.ModelIdentifier<TeamTable> {
  final String id;

  /** Create an instance of TeamTableModelIdentifier using [id] the primary key. */
  const TeamTableModelIdentifier({
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
  String toString() => 'TeamTableModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TeamTableModelIdentifier &&
        id == other.id;
  }

  @override
  int get hashCode =>
      id.hashCode;
}