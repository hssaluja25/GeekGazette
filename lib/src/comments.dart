import 'package:json_annotation/json_annotation.dart';
part 'comments.g.dart';

@JsonSerializable()
class Comment {
  // * If text of comment is null then we do not display it, if anything else is null then we have no problem.
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
