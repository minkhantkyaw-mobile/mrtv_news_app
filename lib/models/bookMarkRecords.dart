import 'package:hive/hive.dart';
import 'base_record.dart';

part 'bookMarkRecords.g.dart'; // for code generation

@HiveType(typeId: 1) // make sure typeId is unique and consistent
class Bookmarkrecords extends HiveObject {
  @HiveField(0)
  final int nid;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? video;

  @HiveField(3)
  final String? image;

  @HiveField(4)
  final String? postedDate;

  @HiveField(5)
  final String? source;

  @HiveField(6)
  final String? body;

  Bookmarkrecords({
    required this.nid,
    required this.title,
    this.video,
    this.image,
    this.postedDate,
    this.source,
    this.body,
  });

  factory Bookmarkrecords.fromBaseRecord(BaseRecord record, String source) {
    return Bookmarkrecords(
      nid: record.nid ?? 0,
      title: record.title ?? '',
      video: record.video,
      image: record.image,
      postedDate: record.postedDate,
      source: source,
      body: record.body,
    );
  }
}
