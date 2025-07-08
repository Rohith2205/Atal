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


/** This is an auto generated class representing the SuggestionsTable type in your schema. */
class SuggestionsTable extends amplify_core.Model {
  static const classType = const _SuggestionsTableModelType();
  final String id;
  final UserTable? _user;
  final int? _suggestionID;
  final String? _type;
  final String? _concern;
  final String? _photo;
  final int? _schoolUID;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SuggestionsTableModelIdentifier get modelIdentifier {
      return SuggestionsTableModelIdentifier(
        id: id
      );
  }
  
  UserTable? get user {
    return _user;
  }
  
  int? get suggestionID {
    return _suggestionID;
  }
  
  String? get type {
    return _type;
  }
  
  String? get concern {
    return _concern;
  }
  
  String? get photo {
    return _photo;
  }
  
  int? get schoolUID {
    return _schoolUID;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const SuggestionsTable._internal({required this.id, user, suggestionID, type, concern, photo, schoolUID, createdAt, updatedAt}): _user = user, _suggestionID = suggestionID, _type = type, _concern = concern, _photo = photo, _schoolUID = schoolUID, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SuggestionsTable({String? id, UserTable? user, int? suggestionID, String? type, String? concern, String? photo, int? schoolUID, required String UserId}) {
    return SuggestionsTable._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      user: user,
      suggestionID: suggestionID,
      type: type,
      concern: concern,
      photo: photo,
      schoolUID: schoolUID);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SuggestionsTable &&
      id == other.id &&
      _user == other._user &&
      _suggestionID == other._suggestionID &&
      _type == other._type &&
      _concern == other._concern &&
      _photo == other._photo &&
      _schoolUID == other._schoolUID;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SuggestionsTable {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("suggestionID=" + (_suggestionID != null ? _suggestionID!.toString() : "null") + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("concern=" + "$_concern" + ", ");
    buffer.write("photo=" + "$_photo" + ", ");
    buffer.write("schoolUID=" + (_schoolUID != null ? _schoolUID!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SuggestionsTable copyWith({UserTable? user, int? suggestionID, String? type, String? concern, String? photo, int? schoolUID}) {
    return SuggestionsTable._internal(
      id: id,
      user: user ?? this.user,
      suggestionID: suggestionID ?? this.suggestionID,
      type: type ?? this.type,
      concern: concern ?? this.concern,
      photo: photo ?? this.photo,
      schoolUID: schoolUID ?? this.schoolUID);
  }
  
  SuggestionsTable copyWithModelFieldValues({
    ModelFieldValue<UserTable?>? user,
    ModelFieldValue<int?>? suggestionID,
    ModelFieldValue<String?>? type,
    ModelFieldValue<String?>? concern,
    ModelFieldValue<String?>? photo,
    ModelFieldValue<int?>? schoolUID
  }) {
    return SuggestionsTable._internal(
      id: id,
      user: user == null ? this.user : user.value,
      suggestionID: suggestionID == null ? this.suggestionID : suggestionID.value,
      type: type == null ? this.type : type.value,
      concern: concern == null ? this.concern : concern.value,
      photo: photo == null ? this.photo : photo.value,
      schoolUID: schoolUID == null ? this.schoolUID : schoolUID.value
    );
  }
  
  SuggestionsTable.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? UserTable.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : UserTable.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
      _suggestionID = (json['suggestionID'] as num?)?.toInt(),
      _type = json['type'],
      _concern = json['concern'],
      _photo = json['photo'],
      _schoolUID = (json['schoolUID'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user': _user?.toJson(), 'suggestionID': _suggestionID, 'type': _type, 'concern': _concern, 'photo': _photo, 'schoolUID': _schoolUID, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'user': _user,
    'suggestionID': _suggestionID,
    'type': _type,
    'concern': _concern,
    'photo': _photo,
    'schoolUID': _schoolUID,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SuggestionsTableModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SuggestionsTableModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserTable'));
  static final SUGGESTIONID = amplify_core.QueryField(fieldName: "suggestionID");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final CONCERN = amplify_core.QueryField(fieldName: "concern");
  static final PHOTO = amplify_core.QueryField(fieldName: "photo");
  static final SCHOOLUID = amplify_core.QueryField(fieldName: "schoolUID");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SuggestionsTable";
    modelSchemaDefinition.pluralName = "SuggestionsTables";
    
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
      key: SuggestionsTable.USER,
      isRequired: false,
      targetNames: ['user_id'],
      ofModelName: 'UserTable'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SuggestionsTable.SUGGESTIONID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SuggestionsTable.TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SuggestionsTable.CONCERN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SuggestionsTable.PHOTO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SuggestionsTable.SCHOOLUID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
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

class _SuggestionsTableModelType extends amplify_core.ModelType<SuggestionsTable> {
  const _SuggestionsTableModelType();
  
  @override
  SuggestionsTable fromJson(Map<String, dynamic> jsonData) {
    return SuggestionsTable.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SuggestionsTable';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SuggestionsTable] in your schema.
 */
class SuggestionsTableModelIdentifier implements amplify_core.ModelIdentifier<SuggestionsTable> {
  final String id;

  /** Create an instance of SuggestionsTableModelIdentifier using [id] the primary key. */
  const SuggestionsTableModelIdentifier({
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
  String toString() => 'SuggestionsTableModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SuggestionsTableModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}