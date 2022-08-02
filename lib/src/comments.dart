import 'package:json_annotation/json_annotation.dart';
part 'comments.g.dart';

@JsonSerializable()
class Comment {
  // If the fields are final, we don't need to make them private
  // as they cannot be modified.
  final String? by;
  final int? id;
  final List? kids;
  final int? parent;
  final String? text;
  final int? time;
  final String? type;

  const Comment({
    this.by,
    this.id,
    this.kids,
    this.parent,
    this.text,
    this.time,
    this.type,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
