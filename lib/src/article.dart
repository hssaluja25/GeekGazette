import 'package:json_annotation/json_annotation.dart';
part 'article.g.dart';

@JsonSerializable()
class Article {
  final int? id;
  bool? deleted;
  final String? type;
  final String? by;
  final int? time;
  final String? text;
  bool? dead;
  final String? parent;
  final int? poll;
  List? kids;
  final String? url;
  final int? score;
  final String? title;
  final List? parts;
  final int? descendants;

  Article(
      {this.id,
      this.deleted,
      this.type,
      this.by,
      this.time,
      this.text,
      this.dead,
      this.parent,
      this.poll,
      this.kids,
      this.url,
      this.score,
      this.title,
      this.parts,
      this.descendants});

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
