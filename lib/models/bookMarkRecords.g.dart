// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookMarkRecords.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkrecordsAdapter extends TypeAdapter<Bookmarkrecords> {
  @override
  final int typeId = 1;

  @override
  Bookmarkrecords read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bookmarkrecords(
      nid: fields[0] as int,
      title: fields[1] as String,
      video: fields[2] as String?,
      image: fields[3] as String?,
      postedDate: fields[4] as String?,
      source: fields[5] as String?,
      body: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Bookmarkrecords obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nid)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.video)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.postedDate)
      ..writeByte(5)
      ..write(obj.source)
      ..writeByte(6)
      ..write(obj.body);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkrecordsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
