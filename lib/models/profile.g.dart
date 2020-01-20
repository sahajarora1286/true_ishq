// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    id: json['_id'] as String,
    profilePic: json['profilePic'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    occupation: json['occupation'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      '_id': instance.id,
      'profilePic': instance.profilePic,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'occupation': instance.occupation,
      'description': instance.description,
    };
