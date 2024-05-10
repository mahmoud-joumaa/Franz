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


/** This is an auto generated class representing the Transcription type in your schema. */
class Transcription {
  final String? _account_id;
  final String? _metadata;
  final String? _s3_bucket;
  final String? _title;
  final String? _transcription_date;
  final String? _transcription_id;

  String get account_id {
    try {
      return _account_id!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get metadata {
    return _metadata;
  }
  
  String get s3_bucket {
    try {
      return _s3_bucket!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get title {
    try {
      return _title!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get transcription_date {
    try {
      return _transcription_date!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get transcription_id {
    try {
      return _transcription_id!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const Transcription._internal({required account_id, metadata, required s3_bucket, required title, required transcription_date, required transcription_id}): _account_id = account_id, _metadata = metadata, _s3_bucket = s3_bucket, _title = title, _transcription_date = transcription_date, _transcription_id = transcription_id;
  
  factory Transcription({required String account_id, String? metadata, required String s3_bucket, required String title, required String transcription_date, required String transcription_id}) {
    return Transcription._internal(
      account_id: account_id,
      metadata: metadata,
      s3_bucket: s3_bucket,
      title: title,
      transcription_date: transcription_date,
      transcription_id: transcription_id);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Transcription &&
      _account_id == other._account_id &&
      _metadata == other._metadata &&
      _s3_bucket == other._s3_bucket &&
      _title == other._title &&
      _transcription_date == other._transcription_date &&
      _transcription_id == other._transcription_id;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Transcription {");
    buffer.write("account_id=" + "$_account_id" + ", ");
    buffer.write("metadata=" + "$_metadata" + ", ");
    buffer.write("s3_bucket=" + "$_s3_bucket" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("transcription_date=" + "$_transcription_date" + ", ");
    buffer.write("transcription_id=" + "$_transcription_id");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Transcription copyWith({String? account_id, String? metadata, String? s3_bucket, String? title, String? transcription_date, String? transcription_id}) {
    return Transcription._internal(
      account_id: account_id ?? this.account_id,
      metadata: metadata ?? this.metadata,
      s3_bucket: s3_bucket ?? this.s3_bucket,
      title: title ?? this.title,
      transcription_date: transcription_date ?? this.transcription_date,
      transcription_id: transcription_id ?? this.transcription_id);
  }
  
  Transcription copyWithModelFieldValues({
    ModelFieldValue<String>? account_id,
    ModelFieldValue<String?>? metadata,
    ModelFieldValue<String>? s3_bucket,
    ModelFieldValue<String>? title,
    ModelFieldValue<String>? transcription_date,
    ModelFieldValue<String>? transcription_id
  }) {
    return Transcription._internal(
      account_id: account_id == null ? this.account_id : account_id.value,
      metadata: metadata == null ? this.metadata : metadata.value,
      s3_bucket: s3_bucket == null ? this.s3_bucket : s3_bucket.value,
      title: title == null ? this.title : title.value,
      transcription_date: transcription_date == null ? this.transcription_date : transcription_date.value,
      transcription_id: transcription_id == null ? this.transcription_id : transcription_id.value
    );
  }
  
  Transcription.fromJson(Map<String, dynamic> json)  
    : _account_id = json['account_id'],
      _metadata = json['metadata'],
      _s3_bucket = json['s3_bucket'],
      _title = json['title'],
      _transcription_date = json['transcription_date'],
      _transcription_id = json['transcription_id'];
  
  Map<String, dynamic> toJson() => {
    'account_id': _account_id, 'metadata': _metadata, 's3_bucket': _s3_bucket, 'title': _title, 'transcription_date': _transcription_date, 'transcription_id': _transcription_id
  };
  
  Map<String, Object?> toMap() => {
    'account_id': _account_id,
    'metadata': _metadata,
    's3_bucket': _s3_bucket,
    'title': _title,
    'transcription_date': _transcription_date,
    'transcription_id': _transcription_id
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Transcription";
    modelSchemaDefinition.pluralName = "Transcriptions";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'account_id',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'metadata',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 's3_bucket',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'title',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'transcription_date',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'transcription_id',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}