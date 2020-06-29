import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'profile.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class Profile {
  Profile(
      {this.id,
      this.profilePic,
      this.firstName,
      this.lastName,
      this.occupation,
      this.description,
      this.age,
      this.height});

  @JsonKey(name: '_id')
  String id;

  String profilePic;

  @JsonKey(name: 'firstName')
  String firstName;

  String lastName;
  String occupation;
  String description;
  int age;
  double height;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$ProfileFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ProfileToJson`.
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
