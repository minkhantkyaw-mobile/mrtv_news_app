// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkItemAdapter extends TypeAdapter<BookmarkItem> {
  @override
  final int typeId = 0;

  @override
  BookmarkItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkItem(
      nid: fields[0] as int,
      title: fields[1] as String,
      video: fields[2] as String?,
      image: fields[3] as String?,
      postedDate: fields[4] as String?,
      source: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkItem obj) {
    writer
      ..writeByte(6)
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
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
