// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodEntityAdapter extends TypeAdapter<MoodEntity> {
  @override
  final int typeId = 1;

  @override
  MoodEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodEntity(
      id: fields[0] as String,
      userId: fields[1] as String?,
      mood: fields[2] as String,
      description: fields[3] as String,
      createdAt: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MoodEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.mood)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
