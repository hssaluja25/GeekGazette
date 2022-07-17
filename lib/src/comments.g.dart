// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      by: json['by'] as String?,
      id: json['id'] as int?,
      kids: json['kids'] as List<dynamic>?,
      parent: json['parent'] as int?,
      text: json['text'] as String?,
      time: json['time'] as int?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'by': instance.by,
      'id': instance.id,
      'kids': instance.kids,
      'parent': instance.parent,
      'text': instance.text,
      'time': instance.time,
      'type': instance.type,
    };
