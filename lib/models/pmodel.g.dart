// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PModelAdapter extends TypeAdapter<PModel> {
  @override
  final int typeId = 1;

  @override
  PModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PModel(
      path: fields[0] as String,
      size: fields[1] as double,
      lastModified: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
