// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:mood_tracker_assessment/hive_helper/fields/user_entity_fields.dart';
import 'package:mood_tracker_assessment/hive_helper/hive_adapters.dart';
import 'package:mood_tracker_assessment/hive_helper/hive_types.dart';

part 'user_entity.g.dart';

@HiveType(typeId: HiveTypes.userEntity, adapterName: HiveAdapters.userEntity)
class UserEntity extends HiveObject {
  @HiveField(UserEntityFields.id)
  final String id;
  @HiveField(UserEntityFields.name)
  final String name;
  @HiveField(UserEntityFields.email)
  final String email;
  @HiveField(UserEntityFields.createdAt)
  final String createdAt;
  @HiveField(UserEntityFields.password)
  final String password;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
      'password': password,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: map['createdAt'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) => UserEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  UserEntity copyWith({String? id, String? name, String? email, String? createdAt, String? password}) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
    );
  }
}
