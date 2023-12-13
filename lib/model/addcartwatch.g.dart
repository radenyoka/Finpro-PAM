// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addcartwatch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddCartWatchAdapter extends TypeAdapter<AddCartWatch> {
  @override
  final int typeId = 0;

  @override
  AddCartWatch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddCartWatch(
      title: fields[0] as String,
      thumbnail: fields[1] as String,
      rating: fields[4] as double,
      price: fields[2] as int,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AddCartWatch obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.thumbnail)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddCartWatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
