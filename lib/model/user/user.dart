import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "number")
  int? number;

  @JsonKey(name: "password")
  String? password;

  @JsonKey(name: "profileImage")
  String? profileImage; // <-- new field

  User({this.id, this.name, this.email, this.number, this.password, this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
