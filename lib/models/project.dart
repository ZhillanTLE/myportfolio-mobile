import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Portfolio project synchronized with the Django REST Framework API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.year,
    required this.description,
    required this.techStack,
    this.projectUrl = '',
    this.projectImageUrl = '',
    this.repoUrl = '',
    this.imageSrc = '',
    this.id,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String year;
  final String description;
  final String techStack;
  @JsonKey(name: 'live_url', defaultValue: '')
  final String projectUrl;
  @JsonKey(name: 'image', defaultValue: '')
  final String projectImageUrl;

  // Read from the API only, never sent by the form.
  @JsonKey(defaultValue: '', includeToJson: false)
  final String repoUrl;
  @JsonKey(defaultValue: '', includeToJson: false)
  final String imageSrc;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
