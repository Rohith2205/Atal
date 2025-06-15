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


/** This is an auto generated class representing the ResourceTable type in your schema. */
class ResourceTable extends amplify_core.Model {
  static const classType = const _ResourceTableModelType();
  final String id;
  final int? _moduleID;
  final int? _module_no;
  final String? _module_name;
  final String? _url;
  final String? _module_photo;
  final bool? _isValid;
  final String? _teamID_list;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ResourceTableModelIdentifier get modelIdentifier {
      return ResourceTableModelIdentifier(
        id: id
      );
  }
  
  int get moduleID {
    try {
      return _moduleID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int? get module_no {
    return _module_no;
  }
  
  String? get module_name {
    return _module_name;
  }
  
  String? get url {
    return _url;
  }
  
  String? get module_photo {
    return _module_photo;
  }
  
  bool? get isValid {
    return _isValid;
  }
  
  String? get teamID_list {
    return _teamID_list;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ResourceTable._internal({required this.id, required moduleID, module_no, module_name, url, module_photo, isValid, teamID_list, createdAt, updatedAt}): _moduleID = moduleID, _module_no = module_no, _module_name = module_name, _url = url, _module_photo = module_photo, _isValid = isValid, _teamID_list = teamID_list, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ResourceTable({String? id, required int moduleID, int? module_no, String? module_name, String? url, String? module_photo, bool? isValid, String? teamID_list}) {
    return ResourceTable._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      moduleID: moduleID,
      module_no: module_no,
      module_name: module_name,
      url: url,
      module_photo: module_photo,
      isValid: isValid,
      teamID_list: teamID_list);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResourceTable &&
      id == other.id &&
      _moduleID == other._moduleID &&
      _module_no == other._module_no &&
      _module_name == other._module_name &&
      _url == other._url &&
      _module_photo == other._module_photo &&
      _isValid == other._isValid &&
      _teamID_list == other._teamID_list;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ResourceTable {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("moduleID=" + (_moduleID != null ? _moduleID!.toString() : "null") + ", ");
    buffer.write("module_no=" + (_module_no != null ? _module_no!.toString() : "null") + ", ");
    buffer.write("module_name=" + "$_module_name" + ", ");
    buffer.write("url=" + "$_url" + ", ");
    buffer.write("module_photo=" + "$_module_photo" + ", ");
    buffer.write("isValid=" + (_isValid != null ? _isValid!.toString() : "null") + ", ");
    buffer.write("teamID_list=" + "$_teamID_list" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ResourceTable copyWith({int? moduleID, int? module_no, String? module_name, String? url, String? module_photo, bool? isValid, String? teamID_list}) {
    return ResourceTable._internal(
      id: id,
      moduleID: moduleID ?? this.moduleID,
      module_no: module_no ?? this.module_no,
      module_name: module_name ?? this.module_name,
      url: url ?? this.url,
      module_photo: module_photo ?? this.module_photo,
      isValid: isValid ?? this.isValid,
      teamID_list: teamID_list ?? this.teamID_list);
  }
  
  ResourceTable copyWithModelFieldValues({
    ModelFieldValue<int>? moduleID,
    ModelFieldValue<int?>? module_no,
    ModelFieldValue<String?>? module_name,
    ModelFieldValue<String?>? url,
    ModelFieldValue<String?>? module_photo,
    ModelFieldValue<bool?>? isValid,
    ModelFieldValue<String?>? teamID_list
  }) {
    return ResourceTable._internal(
      id: id,
      moduleID: moduleID == null ? this.moduleID : moduleID.value,
      module_no: module_no == null ? this.module_no : module_no.value,
      module_name: module_name == null ? this.module_name : module_name.value,
      url: url == null ? this.url : url.value,
      module_photo: module_photo == null ? this.module_photo : module_photo.value,
      isValid: isValid == null ? this.isValid : isValid.value,
      teamID_list: teamID_list == null ? this.teamID_list : teamID_list.value
    );
  }
  
  ResourceTable.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _moduleID = (json['moduleID'] as num?)?.toInt(),
      _module_no = (json['module_no'] as num?)?.toInt(),
      _module_name = json['module_name'],
      _url = json['url'],
      _module_photo = json['module_photo'],
      _isValid = json['isValid'],
      _teamID_list = json['teamID_list'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'moduleID': _moduleID, 'module_no': _module_no, 'module_name': _module_name, 'url': _url, 'module_photo': _module_photo, 'isValid': _isValid, 'teamID_list': _teamID_list, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'moduleID': _moduleID,
    'module_no': _module_no,
    'module_name': _module_name,
    'url': _url,
    'module_photo': _module_photo,
    'isValid': _isValid,
    'teamID_list': _teamID_list,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ResourceTableModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ResourceTableModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final MODULEID = amplify_core.QueryField(fieldName: "moduleID");
  static final MODULE_NO = amplify_core.QueryField(fieldName: "module_no");
  static final MODULE_NAME = amplify_core.QueryField(fieldName: "module_name");
  static final URL = amplify_core.QueryField(fieldName: "url");
  static final MODULE_PHOTO = amplify_core.QueryField(fieldName: "module_photo");
  static final ISVALID = amplify_core.QueryField(fieldName: "isValid");
  static final TEAMID_LIST = amplify_core.QueryField(fieldName: "teamID_list");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ResourceTable";
    modelSchemaDefinition.pluralName = "ResourceTables";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        provider: amplify_core.AuthRuleProvider.IAM,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ResourceTable.MODULEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ResourceTable.MODULE_NO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ResourceTable.MODULE_NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ResourceTable.URL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ResourceTable.MODULE_PHOTO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ResourceTable.ISVALID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ResourceTable.TEAMID_LIST,
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

class _ResourceTableModelType extends amplify_core.ModelType<ResourceTable> {
  const _ResourceTableModelType();
  
  @override
  ResourceTable fromJson(Map<String, dynamic> jsonData) {
    return ResourceTable.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ResourceTable';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ResourceTable] in your schema.
 */
class ResourceTableModelIdentifier implements amplify_core.ModelIdentifier<ResourceTable> {
  final String id;

  /** Create an instance of ResourceTableModelIdentifier using [id] the primary key. */
  const ResourceTableModelIdentifier({
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
  String toString() => 'ResourceTableModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ResourceTableModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}